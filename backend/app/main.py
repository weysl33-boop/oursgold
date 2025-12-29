"""Main FastAPI application"""
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.jobs.manager import JobManager
from app.api.v1 import api_router

# Global job manager instance
job_manager: JobManager = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Lifespan context manager for startup and shutdown events.

    Handles:
    - Starting background jobs on startup
    - Stopping background jobs on shutdown
    """
    global job_manager

    # Startup: Initialize and start background jobs
    # TODO: Initialize services and repositories when they are implemented
    job_manager = JobManager(
        # market_data_service=market_data_service,
        # news_service=news_service,
        # prediction_repository=prediction_repository,
        # vote_repository=vote_repository,
        # user_stats_repository=user_stats_repository,
        # news_repository=news_repository,
        # redis_client=redis_client,
        # websocket_manager=websocket_manager,
        # notification_service=notification_service,
    )

    job_manager.start_all()

    yield

    # Shutdown: Stop all background jobs
    await job_manager.stop_all()


# Create FastAPI app
app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    debug=settings.DEBUG,
    docs_url="/api/docs",
    redoc_url="/api/redoc",
    openapi_url="/api/openapi.json",
    lifespan=lifespan,
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API routers
app.include_router(api_router, prefix="/api/v1")


@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "name": settings.APP_NAME,
        "version": settings.APP_VERSION,
        "status": "running"
    }


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}


@app.get("/jobs/status")
async def jobs_status():
    """
    Get status of all background jobs.

    Returns:
        Status information for all running jobs
    """
    if not job_manager:
        return {"error": "Job manager not initialized"}

    return {
        "jobs": job_manager.get_job_status(),
        "total_jobs": len(job_manager.jobs),
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host=settings.HOST,
        port=settings.PORT,
        reload=settings.DEBUG,
    )

