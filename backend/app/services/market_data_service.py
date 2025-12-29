"""Market data service with Redis caching"""
from typing import Dict, List, Optional
from datetime import datetime, timedelta
import json
import redis.asyncio as redis
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.core.config import settings
from app.models.symbol import Symbol
from app.models.quote import Quote
from app.services.market_data_client import market_data_client


class MarketDataService:
    """Service for managing market data with caching"""

    def __init__(self, db: AsyncSession, redis_client: Optional[redis.Redis] = None):
        self.db = db
        self.redis = redis_client
        self.cache_ttl = 5  # 5 seconds cache TTL

    async def get_quote(self, symbol_code: str) -> Optional[Dict]:
        """
        Get current quote for a symbol (with caching)

        Args:
            symbol_code: Symbol code

        Returns:
            Quote data or None
        """
        # Try to get from cache first
        if self.redis:
            cached = await self._get_from_cache(symbol_code)
            if cached:
                return cached

        # Fetch from external API
        quote_data = await market_data_client.get_quote(symbol_code)

        if quote_data:
            # Store in cache
            if self.redis:
                await self._store_in_cache(symbol_code, quote_data)

            # Optionally store in database for historical data
            await self._store_quote_in_db(quote_data)

        return quote_data

    async def get_multiple_quotes(self, symbol_codes: List[str]) -> Dict[str, Dict]:
        """
        Get quotes for multiple symbols

        Args:
            symbol_codes: List of symbol codes

        Returns:
            Dictionary mapping symbol to quote data
        """
        quotes = {}
        uncached_symbols = []

        # Check cache first
        if self.redis:
            for symbol in symbol_codes:
                cached = await self._get_from_cache(symbol)
                if cached:
                    quotes[symbol] = cached
                else:
                    uncached_symbols.append(symbol)
        else:
            uncached_symbols = symbol_codes

        # Fetch uncached symbols from API
        if uncached_symbols:
            fresh_quotes = await market_data_client.get_multiple_quotes(uncached_symbols)

            for symbol, quote_data in fresh_quotes.items():
                quotes[symbol] = quote_data

                # Store in cache
                if self.redis:
                    await self._store_in_cache(symbol, quote_data)

                # Store in database
                await self._store_quote_in_db(quote_data)

        return quotes

    async def get_historical_data(
        self,
        symbol_code: str,
        period: str = "1D",
        interval: str = "5min"
    ) -> List[Dict]:
        """
        Get historical OHLCV data

        Args:
            symbol_code: Symbol code
            period: Time period (1D, 5D, 1M, 6M, 1Y, ALL)
            interval: Data interval

        Returns:
            List of OHLCV data points
        """
        # Map period to outputsize
        period_map = {
            "1D": 78,      # ~6.5 hours of 5min data
            "5D": 390,     # 5 days of 5min data
            "1M": 120,     # 1 month of 1h data
            "6M": 180,     # 6 months of 1day data
            "1Y": 365,     # 1 year of 1day data
            "ALL": 1000    # Max available
        }

        # Adjust interval based on period
        if period in ["1M", "6M", "1Y", "ALL"]:
            interval = "1day"

        outputsize = period_map.get(period, 100)

        # Fetch from API
        data = await market_data_client.get_time_series(
            symbol_code,
            interval=interval,
            outputsize=outputsize
        )

        return data or []

    async def get_symbol_info(self, symbol_code: str) -> Optional[Symbol]:
        """Get symbol information from database"""
        stmt = select(Symbol).where(Symbol.code == symbol_code)
        result = await self.db.execute(stmt)
        return result.scalar_one_or_none()

    async def get_all_active_symbols(self) -> List[Symbol]:
        """Get all active symbols"""
        stmt = select(Symbol).where(Symbol.is_active == True)
        result = await self.db.execute(stmt)
        return result.scalars().all()

    async def _get_from_cache(self, symbol_code: str) -> Optional[Dict]:
        """Get quote from Redis cache"""
        try:
            key = f"quote:{symbol_code}"
            data = await self.redis.get(key)

            if data:
                return json.loads(data)

            return None
        except Exception as e:
            print(f"Redis get error: {e}")
            return None

    async def _store_in_cache(self, symbol_code: str, quote_data: Dict):
        """Store quote in Redis cache"""
        try:
            key = f"quote:{symbol_code}"
            # Convert datetime to ISO string for JSON serialization
            cache_data = quote_data.copy()
            if isinstance(cache_data.get("timestamp"), datetime):
                cache_data["timestamp"] = cache_data["timestamp"].isoformat()

            await self.redis.setex(
                key,
                self.cache_ttl,
                json.dumps(cache_data)
            )
        except Exception as e:
            print(f"Redis set error: {e}")

    async def _store_quote_in_db(self, quote_data: Dict):
        """Store quote in database for historical data"""
        try:
            quote = Quote(
                symbol_code=quote_data["symbol_code"],
                price=quote_data["price"],
                change=quote_data.get("change"),
                change_percent=quote_data.get("change_percent"),
                high=quote_data.get("high"),
                low=quote_data.get("low"),
                open=quote_data.get("open"),
                prev_close=quote_data.get("prev_close"),
                volume=quote_data.get("volume"),
                timestamp=quote_data["timestamp"]
            )

            self.db.add(quote)
            await self.db.commit()
        except Exception as e:
            print(f"Database store error: {e}")
            await self.db.rollback()
