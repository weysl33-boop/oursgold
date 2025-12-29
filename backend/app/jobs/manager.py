"""Job manager for background tasks"""
import logging
from typing import List, Optional

from app.jobs.base import BaseJob
from app.jobs.price_fetcher import PriceFetcherJob
from app.jobs.news_fetcher import NewsFetcherJob
from app.jobs.prediction_verifier import PredictionVerifierJob

logger = logging.getLogger(__name__)


class JobManager:
    """
    Manager for all background jobs.

    Responsibilities:
    - Initialize and start all background jobs
    - Stop all jobs on application shutdown
    - Provide health check for jobs
    """

    def __init__(
        self,
        market_data_service=None,
        news_service=None,
        prediction_repository=None,
        vote_repository=None,
        user_stats_repository=None,
        news_repository=None,
        redis_client=None,
        websocket_manager=None,
        notification_service=None,
    ):
        """
        Initialize the job manager with required services.

        Args:
            market_data_service: Service for fetching market data
            news_service: Service for fetching news
            prediction_repository: Repository for predictions
            vote_repository: Repository for votes
            user_stats_repository: Repository for user stats
            news_repository: Repository for news
            redis_client: Redis client
            websocket_manager: WebSocket manager
            notification_service: Notification service
        """
        self.jobs: List[BaseJob] = []

        # Initialize jobs
        self._initialize_jobs(
            market_data_service=market_data_service,
            news_service=news_service,
            prediction_repository=prediction_repository,
            vote_repository=vote_repository,
            user_stats_repository=user_stats_repository,
            news_repository=news_repository,
            redis_client=redis_client,
            websocket_manager=websocket_manager,
            notification_service=notification_service,
        )

    def _initialize_jobs(self, **kwargs) -> None:
        """Initialize all background jobs"""

        # Price Fetcher Job (every 5 seconds)
        price_fetcher = PriceFetcherJob(
            market_data_service=kwargs.get("market_data_service"),
            redis_client=kwargs.get("redis_client"),
            websocket_manager=kwargs.get("websocket_manager"),
        )
        self.jobs.append(price_fetcher)

        # News Fetcher Job (every 15 minutes)
        news_fetcher = NewsFetcherJob(
            news_service=kwargs.get("news_service"),
            news_repository=kwargs.get("news_repository"),
            redis_client=kwargs.get("redis_client"),
        )
        self.jobs.append(news_fetcher)

        # Prediction Verifier Job (every 1 minute)
        prediction_verifier = PredictionVerifierJob(
            prediction_repository=kwargs.get("prediction_repository"),
            vote_repository=kwargs.get("vote_repository"),
            user_stats_repository=kwargs.get("user_stats_repository"),
            market_data_service=kwargs.get("market_data_service"),
            websocket_manager=kwargs.get("websocket_manager"),
            notification_service=kwargs.get("notification_service"),
        )
        self.jobs.append(prediction_verifier)

        logger.info(f"Initialized {len(self.jobs)} background jobs")

    def start_all(self) -> None:
        """Start all background jobs"""
        logger.info("Starting all background jobs...")

        for job in self.jobs:
            try:
                job.start()
                logger.info(f"Started {job.__class__.__name__}")
            except Exception as e:
                logger.error(
                    f"Failed to start {job.__class__.__name__}: {str(e)}",
                    exc_info=True
                )

        logger.info("All background jobs started")

    async def stop_all(self) -> None:
        """Stop all background jobs"""
        logger.info("Stopping all background jobs...")

        for job in self.jobs:
            try:
                await job.stop()
                logger.info(f"Stopped {job.__class__.__name__}")
            except Exception as e:
                logger.error(
                    f"Failed to stop {job.__class__.__name__}: {str(e)}",
                    exc_info=True
                )

        logger.info("All background jobs stopped")

    def get_job_status(self) -> List[dict]:
        """
        Get status of all jobs.

        Returns:
            List of job status dictionaries
        """
        status_list = []

        for job in self.jobs:
            status_list.append({
                "name": job.__class__.__name__,
                "running": job._running,
                "interval_seconds": job.interval_seconds,
            })

        return status_list
