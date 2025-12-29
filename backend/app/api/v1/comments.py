"""Comment API endpoints"""
from typing import Optional
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_
import redis.asyncio as redis

from app.core.database import get_db
from app.core.deps import get_current_user, get_optional_current_user
from app.core.config import settings
from app.models.user import User
from app.models.comment import Comment, CommentLike
from app.schemas.comment import (
    CommentCreate,
    CommentResponse,
    CommentWithReplies,
    CommentLikeResponse,
    CommentListResponse
)
from app.services.market_data_service import MarketDataService

router = APIRouter(prefix="/comments", tags=["Comments"])


async def get_redis_client():
    """Get Redis client"""
    client = redis.from_url(settings.REDIS_URL, decode_responses=False)
    try:
        yield client
    finally:
        await client.close()


@router.post("/", response_model=CommentResponse, status_code=status.HTTP_201_CREATED)
async def create_comment(
    comment_data: CommentCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    redis_client: redis.Redis = Depends(get_redis_client)
):
    """Create a new comment (price-anchored)"""
    # Get current price for the symbol
    market_service = MarketDataService(db, redis_client)
    quote = await market_service.get_quote(comment_data.symbol_code)

    if not quote:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Unable to fetch current price"
        )

    # Create comment with price anchor
    comment = Comment(
        user_id=current_user.id,
        symbol_code=comment_data.symbol_code,
        content=comment_data.content,
        price_at_comment=quote["price"],
        parent_id=comment_data.parent_id
    )

    db.add(comment)

    # Update parent's reply count if this is a reply
    if comment_data.parent_id:
        stmt = select(Comment).where(Comment.id == comment_data.parent_id)
        result = await db.execute(stmt)
        parent = result.scalar_one_or_none()
        if parent:
            parent.replies_count += 1

    await db.commit()
    await db.refresh(comment)

    # Load user relationship
    await db.refresh(comment, ["user"])

    return CommentResponse.model_validate(comment)


@router.get("/", response_model=CommentListResponse)
async def get_comments(
    symbol: Optional[str] = Query(None, description="Filter by symbol"),
    user_id: Optional[str] = Query(None, description="Filter by user ID"),
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    current_user: Optional[User] = Depends(get_optional_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Get comments with pagination"""
    # Build query
    stmt = select(Comment).where(Comment.is_deleted == False)

    if symbol:
        stmt = stmt.where(Comment.symbol_code == symbol)

    if user_id:
        try:
            user_uuid = UUID(user_id)
            stmt = stmt.where(Comment.user_id == user_uuid)
        except ValueError:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid user ID format"
            )

    # Only get top-level comments (not replies)
    stmt = stmt.where(Comment.parent_id == None)

    # Order by creation time (newest first)
    stmt = stmt.order_by(Comment.created_at.desc())

    # Count total
    count_stmt = select(func.count()).select_from(stmt.subquery())
    total_result = await db.execute(count_stmt)
    total = total_result.scalar()

    # Apply pagination
    offset = (page - 1) * limit
    stmt = stmt.offset(offset).limit(limit)

    result = await db.execute(stmt)
    comments = result.scalars().all()

    # Load relationships
    for comment in comments:
        await db.refresh(comment, ["user"])

        # Load replies
        replies_stmt = select(Comment).where(
            and_(
                Comment.parent_id == comment.id,
                Comment.is_deleted == False
            )
        ).order_by(Comment.created_at.asc()).limit(5)

        replies_result = await db.execute(replies_stmt)
        replies = replies_result.scalars().all()

        for reply in replies:
            await db.refresh(reply, ["user"])

        comment.replies = replies

    return CommentListResponse(
        comments=[CommentWithReplies.model_validate(c) for c in comments],
        pagination={
            "page": page,
            "limit": limit,
            "total": total,
            "has_more": (page * limit) < total
        }
    )


@router.post("/{comment_id}/like", response_model=CommentLikeResponse)
async def like_comment(
    comment_id: UUID,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Like or unlike a comment"""
    # Check if comment exists
    stmt = select(Comment).where(Comment.id == comment_id)
    result = await db.execute(stmt)
    comment = result.scalar_one_or_none()

    if not comment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Comment not found"
        )

    # Check if already liked
    like_stmt = select(CommentLike).where(
        and_(
            CommentLike.comment_id == comment_id,
            CommentLike.user_id == current_user.id
        )
    )
    like_result = await db.execute(like_stmt)
    existing_like = like_result.scalar_one_or_none()

    if existing_like:
        # Unlike
        await db.delete(existing_like)
        comment.likes_count = max(0, comment.likes_count - 1)
        user_liked = False
    else:
        # Like
        new_like = CommentLike(
            comment_id=comment_id,
            user_id=current_user.id
        )
        db.add(new_like)
        comment.likes_count += 1
        user_liked = True

    await db.commit()

    return CommentLikeResponse(
        comment_id=comment_id,
        likes_count=comment.likes_count,
        user_liked=user_liked
    )


@router.get("/{comment_id}/replies", response_model=list[CommentResponse])
async def get_comment_replies(
    comment_id: UUID,
    db: AsyncSession = Depends(get_db)
):
    """Get all replies for a comment"""
    stmt = select(Comment).where(
        and_(
            Comment.parent_id == comment_id,
            Comment.is_deleted == False
        )
    ).order_by(Comment.created_at.asc())

    result = await db.execute(stmt)
    replies = result.scalars().all()

    # Load user relationships
    for reply in replies:
        await db.refresh(reply, ["user"])

    return [CommentResponse.model_validate(r) for r in replies]
