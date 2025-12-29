"""Quote API endpoints"""
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
import redis.asyncio as redis

from app.core.database import get_db
from app.core.config import settings
from app.schemas.quote import (
    QuoteResponse,
    QuoteWithSymbol,
    HistoricalQuoteResponse,
    HistoricalQuote
)
from app.services.market_data_service import MarketDataService

router = APIRouter(prefix="/quotes", tags=["Market Data"])


async def get_redis_client():
    """Get Redis client"""
    client = redis.from_url(settings.REDIS_URL, decode_responses=False)
    try:
        yield client
    finally:
        await client.close()


@router.get("/{symbol}", response_model=QuoteWithSymbol)
async def get_quote(
    symbol: str,
    db: AsyncSession = Depends(get_db),
    redis_client: redis.Redis = Depends(get_redis_client)
):
    """Get current quote for a symbol"""
    service = MarketDataService(db, redis_client)

    # Get symbol info
    symbol_info = await service.get_symbol_info(symbol)
    if not symbol_info:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Symbol {symbol} not found"
        )

    # Get quote
    quote_data = await service.get_quote(symbol)
    if not quote_data:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Unable to fetch quote data"
        )

    # Combine symbol info with quote
    return QuoteWithSymbol(
        **quote_data,
        name_cn=symbol_info.name_cn,
        name_en=symbol_info.name_en,
        market=symbol_info.market
    )


@router.get("/", response_model=dict)
async def get_multiple_quotes(
    symbols: str = Query(..., description="Comma-separated list of symbols"),
    db: AsyncSession = Depends(get_db),
    redis_client: redis.Redis = Depends(get_redis_client)
):
    """Get quotes for multiple symbols"""
    symbol_list = [s.strip() for s in symbols.split(",")]

    if len(symbol_list) > 20:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Maximum 20 symbols allowed"
        )

    service = MarketDataService(db, redis_client)
    quotes = await service.get_multiple_quotes(symbol_list)

    # Get symbol info for each
    result = []
    for symbol_code, quote_data in quotes.items():
        symbol_info = await service.get_symbol_info(symbol_code)
        if symbol_info:
            result.append(QuoteWithSymbol(
                **quote_data,
                name_cn=symbol_info.name_cn,
                name_en=symbol_info.name_en,
                market=symbol_info.market
            ))

    return {
        "quotes": result,
        "timestamp": quotes[list(quotes.keys())[0]]["timestamp"] if quotes else None
    }


@router.get("/{symbol}/history", response_model=HistoricalQuoteResponse)
async def get_historical_quotes(
    symbol: str,
    period: str = Query(default="1D", regex="^(1D|5D|1M|6M|1Y|ALL)$"),
    interval: Optional[str] = Query(default=None, regex="^(1min|5min|15min|30min|1h|1day)$"),
    db: AsyncSession = Depends(get_db),
    redis_client: redis.Redis = Depends(get_redis_client)
):
    """Get historical OHLCV data for a symbol"""
    service = MarketDataService(db, redis_client)

    # Check if symbol exists
    symbol_info = await service.get_symbol_info(symbol)
    if not symbol_info:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Symbol {symbol} not found"
        )

    # Determine interval based on period if not specified
    if not interval:
        interval_map = {
            "1D": "5min",
            "5D": "5min",
            "1M": "1h",
            "6M": "1day",
            "1Y": "1day",
            "ALL": "1day"
        }
        interval = interval_map.get(period, "5min")

    # Get historical data
    data = await service.get_historical_data(symbol, period, interval)

    if not data:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Unable to fetch historical data"
        )

    return HistoricalQuoteResponse(
        symbol_code=symbol,
        period=period,
        interval=interval,
        data=[HistoricalQuote(**item) for item in data]
    )
