"""Market data client for fetching prices from external API"""
import asyncio
from typing import Dict, List, Optional
from datetime import datetime
import httpx
from app.core.config import settings


class MarketDataClient:
    """Client for fetching market data from Twelve Data API"""

    def __init__(self):
        self.base_url = settings.MARKET_DATA_BASE_URL
        self.api_key = settings.MARKET_DATA_API_KEY
        self.rate_limit = settings.MARKET_DATA_RATE_LIMIT
        self._semaphore = asyncio.Semaphore(self.rate_limit)

    async def get_quote(self, symbol: str) -> Optional[Dict]:
        """
        Get current quote for a single symbol

        Args:
            symbol: Symbol code (e.g., "XAUUSD", "EURUSD")

        Returns:
            Quote data or None if failed
        """
        async with self._semaphore:
            try:
                async with httpx.AsyncClient() as client:
                    response = await client.get(
                        f"{self.base_url}/quote",
                        params={
                            "symbol": symbol,
                            "apikey": self.api_key
                        },
                        timeout=10.0
                    )

                    if response.status_code == 200:
                        data = response.json()
                        return self._parse_quote(symbol, data)

                    return None
            except Exception as e:
                print(f"Error fetching quote for {symbol}: {e}")
                return None

    async def get_multiple_quotes(self, symbols: List[str]) -> Dict[str, Dict]:
        """
        Get quotes for multiple symbols

        Args:
            symbols: List of symbol codes

        Returns:
            Dictionary mapping symbol to quote data
        """
        tasks = [self.get_quote(symbol) for symbol in symbols]
        results = await asyncio.gather(*tasks, return_exceptions=True)

        quotes = {}
        for symbol, result in zip(symbols, results):
            if result and not isinstance(result, Exception):
                quotes[symbol] = result

        return quotes

    async def get_time_series(
        self,
        symbol: str,
        interval: str = "5min",
        outputsize: int = 100
    ) -> Optional[List[Dict]]:
        """
        Get historical time series data

        Args:
            symbol: Symbol code
            interval: Time interval (1min, 5min, 15min, 30min, 1h, 1day)
            outputsize: Number of data points to return

        Returns:
            List of OHLCV data points or None if failed
        """
        async with self._semaphore:
            try:
                async with httpx.AsyncClient() as client:
                    response = await client.get(
                        f"{self.base_url}/time_series",
                        params={
                            "symbol": symbol,
                            "interval": interval,
                            "outputsize": outputsize,
                            "apikey": self.api_key
                        },
                        timeout=15.0
                    )

                    if response.status_code == 200:
                        data = response.json()
                        return self._parse_time_series(data)

                    return None
            except Exception as e:
                print(f"Error fetching time series for {symbol}: {e}")
                return None

    def _parse_quote(self, symbol: str, data: Dict) -> Dict:
        """Parse quote data from API response"""
        try:
            return {
                "symbol_code": symbol,
                "price": float(data.get("close", 0)),
                "change": float(data.get("change", 0)),
                "change_percent": float(data.get("percent_change", 0)),
                "high": float(data.get("high", 0)),
                "low": float(data.get("low", 0)),
                "open": float(data.get("open", 0)),
                "prev_close": float(data.get("previous_close", 0)),
                "volume": int(data.get("volume", 0)) if data.get("volume") else None,
                "timestamp": datetime.utcnow()
            }
        except (ValueError, KeyError) as e:
            print(f"Error parsing quote data: {e}")
            return None

    def _parse_time_series(self, data: Dict) -> List[Dict]:
        """Parse time series data from API response"""
        try:
            values = data.get("values", [])
            result = []

            for item in values:
                result.append({
                    "timestamp": datetime.fromisoformat(item["datetime"].replace("Z", "+00:00")),
                    "open": float(item["open"]),
                    "high": float(item["high"]),
                    "low": float(item["low"]),
                    "close": float(item["close"]),
                    "volume": int(item.get("volume", 0)) if item.get("volume") else None
                })

            return result
        except (ValueError, KeyError) as e:
            print(f"Error parsing time series data: {e}")
            return []


# Global instance
market_data_client = MarketDataClient()
