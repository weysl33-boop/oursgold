"""Community and leaderboard schemas"""
from typing import Optional
from decimal import Decimal
from uuid import UUID
from pydantic import BaseModel, Field

from app.schemas.user import UserResponse


class HotTopic(BaseModel):
    """Schema for hot topic"""
    hashtag: str
    discussion_count: int
    heat_score: int
    trending_rank: int


class TrendingSymbol(BaseModel):
    """Schema for trending symbol"""
    symbol_code: str
    name_cn: str
    name_en: str
    comment_count: int
    prediction_count: int
    price_change_percent: Optional[Decimal] = None


class TopComment(BaseModel):
    """Schema for top comment"""
    id: UUID
    user: UserResponse
    symbol_code: str
    content: str
    price_at_comment: Decimal
    likes_count: int
    created_at: str


class UserPredictionStatsResponse(BaseModel):
    """Schema for user prediction stats response"""
    user_id: UUID
    total_predictions: int
    total_participations: int
    correct_count: int
    accuracy_rate: Decimal
    current_streak: int
    max_streak: int
    prediction_score: int
    rank_title: str

    class Config:
        from_attributes = True


class LeaderboardEntry(BaseModel):
    """Schema for leaderboard entry"""
    rank: int
    user: UserResponse
    accuracy_rate: Decimal
    total_participations: int
    current_streak: int
    rank_title: str
    recent_prediction: Optional[dict] = None


class LeaderboardResponse(BaseModel):
    """Schema for leaderboard response"""
    leaderboard: list[LeaderboardEntry]
    user_rank: Optional[int] = None


class CommunityTopicsResponse(BaseModel):
    """Schema for community topics response"""
    topics: list[HotTopic]


class TrendingSymbolsResponse(BaseModel):
    """Schema for trending symbols response"""
    symbols: list[TrendingSymbol]


class TopCommentsResponse(BaseModel):
    """Schema for top comments response"""
    comments: list[TopComment]
