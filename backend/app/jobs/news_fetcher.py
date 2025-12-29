"""News fetching background job (Task 1.5.3)"""
import logging
from typing import Optional, List
from datetime import datetime

from app.jobs.base import BaseJob

logger = logging.getLogger(__name__)


class NewsFetcherJob(BaseJob):
    """
    Background job to fetch financial news every 15 minutes.

    Implements Task 1.5.3: Create background job to fetch news every 15 minutes

    Responsibilities:
    - Fetch news from external sources (RSS/API)
    - Implement deduplication logic
    - Store new articles in database
    - Cache news list in Redis (5min TTL)
    """

    def __init__(
        self,
        news_service=None,
        news_repository=None,
        redis_client=None,
    ):
        """
        Initialize the news fetcher job.

        Args:
            news_service: Service to fetch news from external sources
            news_repository: Repository to store news in database
            redis_client: Redis client for caching
        """
        super().__init__(interval_seconds=900)  # 15 minutes = 900 seconds
        self.news_service = news_service
        self.news_repository = news_repository
        self.redis_client = redis_client

    async def execute(self) -> None:
        """Fetch and store news articles"""
        try:
            logger.info("Starting news fetch")

            # Fetch news from external sources
            news_articles = await self._fetch_news_from_sources()

            if not news_articles:
                logger.info("No new articles fetched")
                return

            logger.info(f"Fetched {len(news_articles)} articles")

            # Deduplicate and filter articles
            new_articles = await self._deduplicate_articles(news_articles)

            if not new_articles:
                logger.info("All articles already exist")
                return

            logger.info(f"Found {len(new_articles)} new articles")

            # Store new articles in database
            stored_count = await self._store_articles(new_articles)

            logger.info(f"Stored {stored_count} new articles")

            # Invalidate news cache to force refresh
            await self._invalidate_news_cache()

        except Exception as e:
            logger.error(f"Error in news fetching job: {str(e)}", exc_info=True)

    async def _fetch_news_from_sources(self) -> List[dict]:
        """
        Fetch news articles from external sources (RSS/API).

        Returns:
            List of news articles
        """
        if not self.news_service:
            logger.warning("News service not configured")
            return []

        try:
            # Fetch from multiple sources
            # Categories: precious metals, forex, crypto, markets
            articles = []

            # Fetch precious metals news
            gold_news = await self.news_service.fetch_by_category("gold")
            articles.extend(gold_news)

            # Fetch forex news
            forex_news = await self.news_service.fetch_by_category("forex")
            articles.extend(forex_news)

            # Fetch general market news
            market_news = await self.news_service.fetch_by_category("markets")
            articles.extend(market_news)

            return articles

        except Exception as e:
            logger.error(f"Failed to fetch news from sources: {str(e)}")
            return []

    async def _deduplicate_articles(self, articles: List[dict]) -> List[dict]:
        """
        Deduplicate articles based on URL or title similarity.

        Args:
            articles: List of fetched articles

        Returns:
            List of new articles that don't exist in database
        """
        if not self.news_repository:
            logger.warning("News repository not configured")
            return articles

        try:
            new_articles = []

            for article in articles:
                # Check if article already exists by URL
                url = article.get("url")
                if not url:
                    continue

                exists = await self.news_repository.exists_by_url(url)

                if not exists:
                    new_articles.append(article)
                else:
                    logger.debug(f"Article already exists: {url}")

            return new_articles

        except Exception as e:
            logger.error(f"Failed to deduplicate articles: {str(e)}")
            return articles  # Return all articles if deduplication fails

    async def _store_articles(self, articles: List[dict]) -> int:
        """
        Store new articles in the database.

        Args:
            articles: List of articles to store

        Returns:
            Number of articles successfully stored
        """
        if not self.news_repository:
            logger.warning("News repository not configured")
            return 0

        stored_count = 0

        for article in articles:
            try:
                # Prepare article data
                news_data = {
                    "title": article.get("title"),
                    "summary": article.get("summary") or article.get("description"),
                    "content": article.get("content"),
                    "url": article.get("url"),
                    "source": article.get("source"),
                    "category": article.get("category", "markets"),
                    "thumbnail_url": article.get("thumbnail_url") or article.get("image_url"),
                    "published_at": article.get("published_at") or datetime.utcnow(),
                    "related_symbols": article.get("related_symbols", []),
                }

                # Store in database
                await self.news_repository.create(news_data)
                stored_count += 1

                logger.debug(f"Stored article: {news_data['title']}")

            except Exception as e:
                logger.error(f"Failed to store article: {str(e)}")

        return stored_count

    async def _invalidate_news_cache(self) -> None:
        """
        Invalidate the news cache in Redis to force refresh.
        """
        if not self.redis_client:
            logger.warning("Redis client not configured")
            return

        try:
            # Delete all news-related cache keys
            cache_patterns = [
                "news:list:*",
                "news:category:*",
                "news:detail:*",
            ]

            for pattern in cache_patterns:
                keys = await self.redis_client.keys(pattern)
                if keys:
                    await self.redis_client.delete(*keys)

            logger.info("Invalidated news cache")

        except Exception as e:
            logger.error(f"Failed to invalidate news cache: {str(e)}")
