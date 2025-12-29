"""API v1 router"""
from fastapi import APIRouter

from app.api.v1 import auth, users, quotes, comments, predictions

api_router = APIRouter()

# Include all v1 routers
api_router.include_router(auth.router)
api_router.include_router(users.router)
api_router.include_router(quotes.router)
api_router.include_router(comments.router)
api_router.include_router(predictions.router)

__all__ = ["api_router"]
