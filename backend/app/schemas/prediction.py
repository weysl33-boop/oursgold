"""Prediction schemas"""
from datetime import datetime
from typing import Optional
from decimal import Decimal
from uuid import UUID
from pydantic import BaseModel, Field

from app.schemas.user import UserResponse


class PredictionOption(BaseModel):
    """Schema for prediction option"""
    key: str = Field(..., pattern="^[A-D]$")
    text: str = Field(..., min_length=1, max_length=100)


class AutoVerifyCondition(BaseModel):
    """Schema for auto verification condition"""
    condition: str = Field(..., max_length=200)


class PredictionBase(BaseModel):
    """Base prediction schema"""
    symbol_code: str = Field(..., max_length=20)
    question: str = Field(..., min_length=5, max_length=500)
    options: list[PredictionOption] = Field(..., min_items=2, max_items=4)
    verify_time: datetime


class PredictionCreate(PredictionBase):
    """Schema for prediction creation"""
    verify_rule: str = Field(default="auto", pattern="^(auto|manual)$")
    auto_verify_conditions: Optional[dict[str, AutoVerifyCondition]] = None


class PredictionUpdate(BaseModel):
    """Schema for prediction update"""
    status: Optional[str] = Field(None, pattern="^(active|ended|cancelled)$")
    correct_option: Optional[str] = Field(None, pattern="^[A-D]$")


class PredictionResponse(PredictionBase):
    """Schema for prediction response"""
    id: UUID
    user: UserResponse
    price_at_create: Decimal
    price_at_verify: Optional[Decimal] = None
    correct_option: Optional[str] = None
    verify_rule: str
    status: str
    participants_count: int
    comments_count: int
    created_at: datetime

    class Config:
        from_attributes = True


class VoteDistribution(BaseModel):
    """Schema for vote distribution"""
    count: int
    percentage: float


class PredictionWithVotes(PredictionResponse):
    """Schema for prediction with vote statistics"""
    user_voted: bool = False
    user_vote: Optional[str] = None
    vote_distribution: dict[str, VoteDistribution] = {}
    time_remaining: Optional[int] = None  # seconds


class PredictionListResponse(BaseModel):
    """Schema for prediction list response with pagination"""
    predictions: list[PredictionWithVotes]
    pagination: dict
