# Background Jobs Module

This module contains all background tasks for the Gold Social Platform backend.

## Overview

The jobs module implements three main background tasks:

1. **Price Fetcher Job** - Fetches market prices every 5 seconds (Task 1.4.4)
2. **News Fetcher Job** - Fetches financial news every 15 minutes (Task 1.5.3)
3. **Prediction Verifier Job** - Verifies predictions at their deadline every 1 minute (Task 1.7.8)

## Architecture

### Base Job Class

All jobs inherit from `BaseJob`, which provides:
- Automatic periodic execution at configurable intervals
- Graceful start/stop lifecycle management
- Error handling and logging
- Async/await support

### Job Manager

The `JobManager` class:
- Initializes all jobs with required dependencies
- Starts jobs on application startup
- Stops jobs on application shutdown
- Provides health check status

## Jobs

### 1. Price Fetcher Job (`price_fetcher.py`)

**Purpose**: Fetch and cache real-time market prices

**Interval**: 5 seconds

**Tasks**:
- Fetch latest prices from external market data API
- Cache in Redis with 5s TTL
- Broadcast price updates via WebSocket
- Optionally store historical data in PostgreSQL

**Dependencies**:
- `market_data_service`: External API client
- `redis_client`: Redis cache
- `websocket_manager`: WebSocket broadcaster

**Default Symbols**:
- XAUUSD (Spot Gold)
- XAGUSD (Spot Silver)
- EURUSD (EUR/USD)
- GBPUSD (GBP/USD)
- USDJPY (USD/JPY)
- BTCUSD (Bitcoin)

**Implementation Status**: ✅ Complete (Phase 1.4.4)

### 2. News Fetcher Job (`news_fetcher.py`)

**Purpose**: Aggregate financial news from external sources

**Interval**: 15 minutes (900 seconds)

**Tasks**:
- Fetch news from RSS/API sources
- Deduplicate articles by URL
- Store new articles in database
- Invalidate news cache

**Categories**:
- Precious metals (gold, silver)
- Forex markets
- General financial markets

**Dependencies**:
- `news_service`: External news API client
- `news_repository`: Database storage
- `redis_client`: Cache invalidation

**Implementation Status**: ✅ Complete (Phase 1.5.3)

### 3. Prediction Verifier Job (`prediction_verifier.py`)

**Purpose**: Verify price predictions when they reach their deadline

**Interval**: 60 seconds (1 minute)

**Tasks**:
1. Find predictions where `verify_time <= NOW()` and `status = 'active'`
2. Fetch current market price
3. Calculate price change percentage
4. Determine correct option based on auto-verify conditions
5. Update prediction record with results
6. Mark all votes as correct/incorrect
7. Update user prediction statistics
8. Broadcast verification results via WebSocket
9. Send push notifications to participants

**Dependencies**:
- `prediction_repository`: Prediction data access
- `vote_repository`: Vote data access
- `user_stats_repository`: User statistics
- `market_data_service`: Current price fetching
- `websocket_manager`: Result broadcasting
- `notification_service`: Push notifications

**Verification Rules**:
- **Auto**: Evaluate conditions based on price change percentage
- **Manual**: Requires admin to set correct answer

**Example Conditions**:
```json
{
  "A": {"condition": "price_change_percent >= 1.0"},
  "B": {"condition": "price_change_percent > 0 AND price_change_percent < 1.0"},
  "C": {"condition": "price_change_percent >= -0.5 AND price_change_percent <= 0"},
  "D": {"condition": "price_change_percent < -0.5"}
}
```

**Implementation Status**: ✅ Complete (Phase 1.7.8)

## Usage

### Starting Jobs

Jobs are automatically started when the FastAPI application starts:

```python
from app.jobs.manager import JobManager

# Initialize job manager with dependencies
job_manager = JobManager(
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

# Start all jobs
job_manager.start_all()
```

### Stopping Jobs

Jobs are automatically stopped on application shutdown:

```python
# Stop all jobs gracefully
await job_manager.stop_all()
```

### Checking Job Status

Use the `/jobs/status` endpoint to check job health:

```bash
curl http://localhost:8000/jobs/status
```

Response:
```json
{
  "jobs": [
    {
      "name": "PriceFetcherJob",
      "running": true,
      "interval_seconds": 5
    },
    {
      "name": "NewsFetcherJob",
      "running": true,
      "interval_seconds": 900
    },
    {
      "name": "PredictionVerifierJob",
      "running": true,
      "interval_seconds": 60
    }
  ],
  "total_jobs": 3
}
```

## Integration with Main App

The jobs are integrated into `app/main.py` using FastAPI's lifespan context manager:

```python
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Start jobs
    job_manager = JobManager(...)
    job_manager.start_all()

    yield

    # Shutdown: Stop jobs
    await job_manager.stop_all()

app = FastAPI(lifespan=lifespan)
```

## Testing

Run tests with:

```bash
pytest tests/test_jobs.py -v
```

Tests cover:
- Base job lifecycle (start/stop)
- Periodic execution
- Price fetching and caching
- News deduplication
- Prediction verification logic
- Price change calculation
- Condition evaluation
- Job manager initialization

## Logging

All jobs use structured logging:

```python
import logging
logger = logging.getLogger(__name__)

# Logs include:
logger.info("Starting price fetch")
logger.debug(f"Cached price for {symbol}")
logger.error(f"Failed to fetch price: {str(e)}", exc_info=True)
```

## Error Handling

Jobs are resilient to errors:
- Individual symbol failures don't stop the entire job
- Database errors are logged but don't crash the job
- Network errors are handled with retries (implemented in services)
- Jobs continue running even if dependencies are not configured

## Future Enhancements

### Phase 4: Real-time Features
- [ ] Redis Pub/Sub for multi-instance WebSocket broadcasting
- [ ] Horizontal scaling support
- [ ] Job execution monitoring and metrics
- [ ] Dynamic interval adjustment based on market hours
- [ ] Failover and health checks

### Performance Optimizations
- [ ] Batch database operations
- [ ] Connection pooling for external APIs
- [ ] Caching strategy improvements
- [ ] Rate limiting for external API calls

## Dependencies

Required services (to be implemented in other modules):
- `MarketDataService` - External market data API client
- `NewsService` - External news API/RSS client
- `PredictionRepository` - Prediction database access
- `VoteRepository` - Vote database access
- `UserStatsRepository` - User statistics database access
- `NewsRepository` - News database access
- `RedisClient` - Redis cache client
- `WebSocketManager` - WebSocket connection manager
- `NotificationService` - Push notification service

## Notes

- All jobs use `asyncio` for concurrent operations
- Jobs are designed to be stateless for horizontal scaling
- Each job logs its execution time and error rates
- Jobs can be individually disabled by not adding them to the manager
- The job manager can be extended to support dynamic job registration

## Related Files

- `app/jobs/base.py` - Base job implementation
- `app/jobs/price_fetcher.py` - Price fetching job
- `app/jobs/news_fetcher.py` - News fetching job
- `app/jobs/prediction_verifier.py` - Prediction verification job
- `app/jobs/manager.py` - Job manager
- `app/main.py` - FastAPI integration
- `tests/test_jobs.py` - Job tests

## OpenSpec Tasks

This module implements the following OpenSpec tasks:

- ✅ Task 1.4.4: Create background job to fetch prices every 5 seconds
- ✅ Task 1.5.3: Create background job to fetch news every 15 minutes
- ✅ Task 1.7.8: Create background job for prediction verification at deadline
