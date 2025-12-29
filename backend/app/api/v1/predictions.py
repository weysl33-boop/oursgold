"""Prediction API endpoints"""
from typing import Optional
from uuid import UUID
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_
import redis.asyncio as redis

from app.core.database import get_db
from app.core.deps import get_current_user, get_optional_current_user
from app.core.config import settings
from app.models.user import User
from app.models.prediction import Prediction
from app.models.vote import Vote
from app.schemas.prediction import (
    PredictionCreate,
    PredictionResponse,
    PredictionWithVotes,
    PredictionListResponse,
    VoteDistribution
)
from app.schemas.vote import VoteCreate, VoteResultResponse
from app.services.market_data_service import MarketDataService

router = APIRouter(prefix="/predictions", tags=["Predictions"])


async def get_redis_client():
    """Get Redis client"""
    client = redis.from_url(settings.REDIS_URL, decode_responses=False)
    try:
        yield client
    finally:
        await client.close()


@router.post("/", response_model=PredictionResponse, status_code=status.HTTP_201_CREATED)
async def create_prediction(
    prediction_data: PredictionCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    redis_client: redis.Redis = Depends(get_redis_client)
):
    """Create a new prediction"""
    # Get current price for the symbol
    market_service = MarketDataService(db, redis_client)
    quote = await market_service.get_quote(prediction_data.symbol_code)

    if not quote:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Unable to fetch current price"
        )

    # Validate verify_time is in the future
    if prediction_data.verify_time <= datetime.utcnow():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Verify time must be in the future"
        )

    # Create prediction with price anchor
    prediction = Prediction(
        user_id=current_user.id,
        symbol_code=prediction_data.symbol_code,
        question=prediction_data.question,
        options=[opt.dict() for opt in prediction_data.options],
        price_at_create=quote["price"],
        verify_time=prediction_data.verify_time,
        verify_rule=prediction_data.verify_rule,
        auto_verify_conditions=prediction_data.auto_verify_conditions.dict() if prediction_data.auto_verify_conditions else None
    )

    db.add(prediction)
    await db.commit()
    await db.refresh(prediction)

    # Load user relationship
    await db.refresh(prediction, ["user"])

    return PredictionResponse.model_validate(prediction)


@router.get("/", response_model=PredictionListResponse)
async def get_predictions(
    status_filter: Optional[str] = Query(None, alias="status", regex="^(active|ended|cancelled)$"),
    symbol: Optional[str] = Query(None, description="Filter by symbol"),
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    current_user: Optional[User] = Depends(get_optional_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Get predictions with pagination"""
    # Build query
    stmt = select(Prediction)

    if status_filter:
        stmt = stmt.where(Prediction.status == status_filter)
    else:
        stmt = stmt.where(Prediction.status == "active")

    if symbol:
        stmt = stmt.where(Prediction.symbol_code == symbol)

    # Order by creation time (newest first)
    stmt = stmt.order_by(Prediction.created_at.desc())

    # Count total
    count_stmt = select(func.count()).select_from(stmt.subquery())
    total_result = await db.execute(count_stmt)
    total = total_result.scalar()

    # Apply pagination
    offset = (page - 1) * limit
    stmt = stmt.offset(offset).limit(limit)

    result = await db.execute(stmt)
    predictions = result.scalars().all()

    # Enrich with vote data
    enriched_predictions = []
    for prediction in predictions:
        await db.refresh(prediction, ["user"])

        # Get vote distribution
        vote_stmt = select(
            Vote.selected_option,
            func.count(Vote.id).label("count")
        ).where(Vote.prediction_id == prediction.id).group_by(Vote.selected_option)

        vote_result = await db.execute(vote_stmt)
        vote_counts = {row[0]: row[1] for row in vote_result.all()}

        total_votes = sum(vote_counts.values())
        vote_distribution = {}

        for option in prediction.options:
            count = vote_counts.get(option["key"], 0)
            percentage = (count / total_votes * 100) if total_votes > 0 else 0
            vote_distribution[option["key"]] = VoteDistribution(
                count=count,
                percentage=round(percentage, 2)
            )

        # Check if current user voted
        user_voted = False
        user_vote = None
        if current_user:
            user_vote_stmt = select(Vote).where(
                and_(
                    Vote.prediction_id == prediction.id,
                    Vote.user_id == current_user.id
                )
            )
            user_vote_result = await db.execute(user_vote_stmt)
            user_vote_obj = user_vote_result.scalar_one_or_none()
            if user_vote_obj:
                user_voted = True
                user_vote = user_vote_obj.selected_option

        # Calculate time remaining
        time_remaining = None
        if prediction.status == "active":
            delta = prediction.verify_time - datetime.utcnow()
            time_remaining = max(0, int(delta.total_seconds()))

        enriched_predictions.append(PredictionWithVotes(
            **prediction.__dict__,
            user_voted=user_voted,
            user_vote=user_vote,
            vote_distribution=vote_distribution,
            time_remaining=time_remaining
        ))

    return PredictionListResponse(
        predictions=enriched_predictions,
        pagination={
            "page": page,
            "limit": limit,
            "total": total,
            "has_more": (page * limit) < total
        }
    )


@router.post("/{prediction_id}/vote", response_model=VoteResultResponse)
async def vote_on_prediction(
    prediction_id: UUID,
    vote_data: VoteCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    redis_client: redis.Redis = Depends(get_redis_client)
):
    """Vote on a prediction"""
    # Check if prediction exists and is active
    stmt = select(Prediction).where(Prediction.id == prediction_id)
    result = await db.execute(stmt)
    prediction = result.scalar_one_or_none()

    if not prediction:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Prediction not found"
        )

    if prediction.status != "active":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Prediction is not active"
        )

    if prediction.verify_time <= datetime.utcnow():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Prediction voting has ended"
        )

    # Validate option
    valid_options = [opt["key"] for opt in prediction.options]
    if vote_data.selected_option not in valid_options:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid option. Must be one of: {', '.join(valid_options)}"
        )

    # Check if user already voted
    existing_vote_stmt = select(Vote).where(
        and_(
            Vote.prediction_id == prediction_id,
            Vote.user_id == current_user.id
        )
    )
    existing_vote_result = await db.execute(existing_vote_stmt)
    existing_vote = existing_vote_result.scalar_one_or_none()

    if existing_vote:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You have already voted on this prediction"
        )

    # Get current price
    market_service = MarketDataService(db, redis_client)
    quote = await market_service.get_quote(prediction.symbol_code)

    if not quote:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Unable to fetch current price"
        )

    # Create vote
    vote = Vote(
        prediction_id=prediction_id,
        user_id=current_user.id,
        selected_option=vote_data.selected_option,
        price_at_vote=quote["price"]
    )

    db.add(vote)

    # Update prediction participants count
    prediction.participants_count += 1

    await db.commit()

    # Get updated vote distribution
    vote_stmt = select(
        Vote.selected_option,
        func.count(Vote.id).label("count")
    ).where(Vote.prediction_id == prediction_id).group_by(Vote.selected_option)

    vote_result = await db.execute(vote_stmt)
    vote_counts = {row[0]: row[1] for row in vote_result.all()}

    total_votes = sum(vote_counts.values())
    vote_distribution = {}

    for option in prediction.options:
        count = vote_counts.get(option["key"], 0)
        percentage = (count / total_votes * 100) if total_votes > 0 else 0
        vote_distribution[option["key"]] = {
            "count": count,
            "percentage": round(percentage, 2)
        }

    return VoteResultResponse(
        prediction_id=prediction_id,
        user_vote=vote_data.selected_option,
        price_at_vote=quote["price"],
        vote_distribution=vote_distribution,
        participants_count=prediction.participants_count
    )


@router.get("/{prediction_id}", response_model=PredictionWithVotes)
async def get_prediction(
    prediction_id: UUID,
    current_user: Optional[User] = Depends(get_optional_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Get a single prediction by ID"""
    stmt = select(Prediction).where(Prediction.id == prediction_id)
    result = await db.execute(stmt)
    prediction = result.scalar_one_or_none()

    if not prediction:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Prediction not found"
        )

    await db.refresh(prediction, ["user"])

    # Get vote distribution
    vote_stmt = select(
        Vote.selected_option,
        func.count(Vote.id).label("count")
    ).where(Vote.prediction_id == prediction_id).group_by(Vote.selected_option)

    vote_result = await db.execute(vote_stmt)
    vote_counts = {row[0]: row[1] for row in vote_result.all()}

    total_votes = sum(vote_counts.values())
    vote_distribution = {}

    for option in prediction.options:
        count = vote_counts.get(option["key"], 0)
        percentage = (count / total_votes * 100) if total_votes > 0 else 0
        vote_distribution[option["key"]] = VoteDistribution(
            count=count,
            percentage=round(percentage, 2)
        )

    # Check if current user voted
    user_voted = False
    user_vote = None
    if current_user:
        user_vote_stmt = select(Vote).where(
            and_(
                Vote.prediction_id == prediction_id,
                Vote.user_id == current_user.id
            )
        )
        user_vote_result = await db.execute(user_vote_stmt)
        user_vote_obj = user_vote_result.scalar_one_or_none()
        if user_vote_obj:
            user_voted = True
            user_vote = user_vote_obj.selected_option

    # Calculate time remaining
    time_remaining = None
    if prediction.status == "active":
        delta = prediction.verify_time - datetime.utcnow()
        time_remaining = max(0, int(delta.total_seconds()))

    return PredictionWithVotes(
        **prediction.__dict__,
        user_voted=user_voted,
        user_vote=user_vote,
        vote_distribution=vote_distribution,
        time_remaining=time_remaining
    )
