"""Tests for background jobs"""
import pytest
import asyncio
from unittest.mock import AsyncMock, MagicMock, patch
from decimal import Decimal

from app.jobs.base import BaseJob
from app.jobs.price_fetcher import PriceFetcherJob
from app.jobs.news_fetcher import NewsFetcherJob
from app.jobs.prediction_verifier import PredictionVerifierJob
from app.jobs.manager import JobManager


class TestBaseJob:
    """Tests for BaseJob"""

    class DummyJob(BaseJob):
        """Dummy job for testing"""

        def __init__(self, interval_seconds=1):
            super().__init__(interval_seconds)
            self.execute_count = 0

        async def execute(self):
            self.execute_count += 1

    @pytest.mark.asyncio
    async def test_job_starts_and_stops(self):
        """Test that job can be started and stopped"""
        job = self.DummyJob(interval_seconds=1)

        # Start job
        job.start()
        assert job._running is True

        # Let it run for a bit
        await asyncio.sleep(0.1)

        # Stop job
        await job.stop()
        assert job._running is False

    @pytest.mark.asyncio
    async def test_job_executes_periodically(self):
        """Test that job executes at the specified interval"""
        job = self.DummyJob(interval_seconds=0.1)

        job.start()
        await asyncio.sleep(0.35)  # Should execute ~3 times
        await job.stop()

        assert job.execute_count >= 2  # At least 2 executions


class TestPriceFetcherJob:
    """Tests for PriceFetcherJob"""

    @pytest.mark.asyncio
    async def test_execute_fetches_prices(self):
        """Test that execute fetches prices for all symbols"""
        # Mock services
        market_data_service = AsyncMock()
        market_data_service.get_latest_quote.return_value = {
            "price": 2658.50,
            "change": 28.30,
            "change_percent": 1.08,
        }

        redis_client = AsyncMock()
        websocket_manager = AsyncMock()

        # Create job
        job = PriceFetcherJob(
            market_data_service=market_data_service,
            redis_client=redis_client,
            websocket_manager=websocket_manager,
        )

        # Execute
        await job.execute()

        # Verify market data service was called
        assert market_data_service.get_latest_quote.called

    @pytest.mark.asyncio
    async def test_caches_price_in_redis(self):
        """Test that prices are cached in Redis"""
        market_data_service = AsyncMock()
        market_data_service.get_latest_quote.return_value = {
            "price": 2658.50,
        }

        redis_client = AsyncMock()

        job = PriceFetcherJob(
            market_data_service=market_data_service,
            redis_client=redis_client,
        )

        await job.execute()

        # Verify Redis hset was called
        assert redis_client.hset.called
        # Verify TTL was set
        assert redis_client.expire.called


class TestNewsFetcherJob:
    """Tests for NewsFetcherJob"""

    @pytest.mark.asyncio
    async def test_execute_fetches_news(self):
        """Test that execute fetches news from sources"""
        # Mock services
        news_service = AsyncMock()
        news_service.fetch_by_category.return_value = [
            {
                "title": "Gold prices surge",
                "url": "https://example.com/news/1",
                "source": "Example News",
            }
        ]

        news_repository = AsyncMock()
        news_repository.exists_by_url.return_value = False
        news_repository.create.return_value = {"id": "123"}

        redis_client = AsyncMock()
        redis_client.keys.return_value = []

        # Create job
        job = NewsFetcherJob(
            news_service=news_service,
            news_repository=news_repository,
            redis_client=redis_client,
        )

        # Execute
        await job.execute()

        # Verify news service was called
        assert news_service.fetch_by_category.called
        # Verify articles were stored
        assert news_repository.create.called

    @pytest.mark.asyncio
    async def test_deduplicates_existing_articles(self):
        """Test that existing articles are not stored again"""
        news_service = AsyncMock()
        news_service.fetch_by_category.return_value = [
            {"title": "News 1", "url": "https://example.com/1"}
        ]

        news_repository = AsyncMock()
        news_repository.exists_by_url.return_value = True  # Already exists

        job = NewsFetcherJob(
            news_service=news_service,
            news_repository=news_repository,
        )

        await job.execute()

        # Verify create was NOT called
        assert not news_repository.create.called


class TestPredictionVerifierJob:
    """Tests for PredictionVerifierJob"""

    @pytest.mark.asyncio
    async def test_execute_verifies_predictions(self):
        """Test that execute verifies predictions"""
        # Mock repositories and services
        prediction_repository = AsyncMock()
        prediction_repository.find_by_criteria.return_value = [
            {
                "id": "pred-123",
                "symbol_code": "XAUUSD",
                "price_at_create": 2650.00,
                "verify_rule": "auto",
                "auto_verify_conditions": {
                    "A": {"condition": "price_change_percent >= 1.0"},
                    "B": {"condition": "price_change_percent < 1.0"},
                },
            }
        ]

        vote_repository = AsyncMock()
        user_stats_repository = AsyncMock()

        market_data_service = AsyncMock()
        market_data_service.get_latest_quote.return_value = {
            "price": 2680.00  # 1.13% increase
        }

        # Create job
        job = PredictionVerifierJob(
            prediction_repository=prediction_repository,
            vote_repository=vote_repository,
            user_stats_repository=user_stats_repository,
            market_data_service=market_data_service,
        )

        # Execute
        await job.execute()

        # Verify prediction was updated
        assert prediction_repository.update.called

    def test_calculate_price_change(self):
        """Test price change calculation"""
        job = PredictionVerifierJob()

        # Test increase
        change = job._calculate_price_change(
            Decimal("2650.00"), Decimal("2680.00")
        )
        assert change == Decimal("1.13")

        # Test decrease
        change = job._calculate_price_change(
            Decimal("2650.00"), Decimal("2620.00")
        )
        assert change == Decimal("-1.13")

    def test_evaluate_condition(self):
        """Test condition evaluation"""
        job = PredictionVerifierJob()

        # Test >= condition
        assert job._evaluate_condition(
            "price_change_percent >= 1.0", Decimal("1.5")
        ) is True
        assert job._evaluate_condition(
            "price_change_percent >= 1.0", Decimal("0.5")
        ) is False

        # Test < condition
        assert job._evaluate_condition(
            "price_change_percent < 1.0", Decimal("0.5")
        ) is True


class TestJobManager:
    """Tests for JobManager"""

    def test_initializes_all_jobs(self):
        """Test that manager initializes all jobs"""
        manager = JobManager()

        assert len(manager.jobs) == 3
        assert isinstance(manager.jobs[0], PriceFetcherJob)
        assert isinstance(manager.jobs[1], NewsFetcherJob)
        assert isinstance(manager.jobs[2], PredictionVerifierJob)

    def test_start_all_starts_jobs(self):
        """Test that start_all starts all jobs"""
        manager = JobManager()

        manager.start_all()

        for job in manager.jobs:
            assert job._running is True

    @pytest.mark.asyncio
    async def test_stop_all_stops_jobs(self):
        """Test that stop_all stops all jobs"""
        manager = JobManager()

        manager.start_all()
        await manager.stop_all()

        for job in manager.jobs:
            assert job._running is False

    def test_get_job_status(self):
        """Test getting job status"""
        manager = JobManager()
        manager.start_all()

        status = manager.get_job_status()

        assert len(status) == 3
        assert all(job["running"] is True for job in status)
