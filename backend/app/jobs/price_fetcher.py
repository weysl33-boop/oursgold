"""Price fetching background job (Task 1.4.4)"""
import logging
from typing import Optional

from app.jobs.base import BaseJob

logger = logging.getLogger(__name__)


class PriceFetcherJob(BaseJob):
    """
    Background job to fetch market prices every 5 seconds.

    Implements Task 1.4.4: Create background job to fetch prices every 5 seconds

    Responsibilities:
    - Fetch latest prices from external market data API
    - Store in Redis with 5s TTL
    - Optionally store in PostgreSQL for historical data
    - Broadcast to WebSocket clients subscribed to each symbol
    """

    def __init__(
        self,
        market_data_service=None,
        redis_client=None,
        websocket_manager=None,
    ):
        """
        Initialize the price fetcher job.

        Args:
            market_data_service: Service to fetch market data from external API
            redis_client: Redis client for caching
            websocket_manager: Manager to broadcast price updates
        """
        super().__init__(interval_seconds=5)
        self.market_data_service = market_data_service
        self.redis_client = redis_client
        self.websocket_manager = websocket_manager

    async def execute(self) -> None:
        """Fetch and cache prices for all active symbols"""
        try:
            # TODO: Get list of active symbols from database
            # For now, use default symbols
            default_symbols = [
                "XAUUSD",  # Spot Gold
                "XAGUSD",  # Spot Silver
                "EURUSD",  # EUR/USD
                "GBPUSD",  # GBP/USD
                "USDJPY",  # USD/JPY
                "BTCUSD",  # Bitcoin
            ]

            logger.debug(f"Fetching prices for {len(default_symbols)} symbols")

            for symbol in default_symbols:
                try:
                    # Fetch price from external API
                    price_data = await self._fetch_price_for_symbol(symbol)

                    if price_data:
                        # Cache in Redis
                        await self._cache_price(symbol, price_data)

                        # Broadcast to WebSocket clients
                        await self._broadcast_price(symbol, price_data)

                        # Optionally store in database for historical data
                        # await self._store_historical_price(symbol, price_data)

                except Exception as e:
                    logger.error(f"Error fetching price for {symbol}: {str(e)}")

            logger.debug("Price fetching completed")

        except Exception as e:
            logger.error(f"Error in price fetching job: {str(e)}", exc_info=True)

    async def _fetch_price_for_symbol(self, symbol: str) -> Optional[dict]:
        """
        Fetch price data for a specific symbol from external API.

        Args:
            symbol: Symbol code (e.g., "XAUUSD")

        Returns:
            Price data dictionary or None if failed
        """
        if not self.market_data_service:
            logger.warning("Market data service not configured")
            return None

        try:
            # Call market data service to fetch from external API
            # This will be implemented in the market data service
            price_data = await self.market_data_service.get_latest_quote(symbol)
            return price_data
        except Exception as e:
            logger.error(f"Failed to fetch price for {symbol}: {str(e)}")
            return None

    async def _cache_price(self, symbol: str, price_data: dict) -> None:
        """
        Cache price data in Redis with 5s TTL.

        Args:
            symbol: Symbol code
            price_data: Price data to cache
        """
        if not self.redis_client:
            logger.warning("Redis client not configured")
            return

        try:
            cache_key = f"quote:{symbol}"
            # Store as hash in Redis
            await self.redis_client.hset(cache_key, mapping=price_data)
            # Set TTL to 5 seconds
            await self.redis_client.expire(cache_key, 5)

            logger.debug(f"Cached price for {symbol}")
        except Exception as e:
            logger.error(f"Failed to cache price for {symbol}: {str(e)}")

    async def _broadcast_price(self, symbol: str, price_data: dict) -> None:
        """
        Broadcast price update to WebSocket clients.

        Args:
            symbol: Symbol code
            price_data: Price data to broadcast
        """
        if not self.websocket_manager:
            logger.warning("WebSocket manager not configured")
            return

        try:
            message = {
                "type": "price_update",
                "payload": {
                    "symbol_code": symbol,
                    **price_data
                }
            }
            # Broadcast to all clients subscribed to this symbol
            await self.websocket_manager.broadcast_to_symbol(symbol, message)

            logger.debug(f"Broadcasted price update for {symbol}")
        except Exception as e:
            logger.error(f"Failed to broadcast price for {symbol}: {str(e)}")

    async def _store_historical_price(self, symbol: str, price_data: dict) -> None:
        """
        Store price data in PostgreSQL for historical charting.

        Args:
            symbol: Symbol code
            price_data: Price data to store
        """
        # TODO: Implement historical price storage
        # This will be implemented when the quotes repository is ready
        pass
