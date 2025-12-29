"""Vote schemas"""
from datetime import datetime
from typing import Optional
from decimal import Decimal
from uuid import UUID
from pydantic import BaseModel, Field


class VoteBase(BaseModel):
    """Base vote schema"""
    selected_option: str = Field(..., pattern="^[A-D]$")


class VoteCreate(VoteBase):
    """Schema for vote creation"""
    pass


class VoteResponse(VoteBase):
    """Schema for vote response"""
    id: UUID
    prediction_id: UUID
    user_id: UUID
    price_at_vote: Decimal
    is_correct: Optional[bool] = None
    voted_at: datetime

    class Config:
        from_attributes = True


class VoteResultResponse(BaseModel):
    """Schema for vote result response"""
    prediction_id: UUID
    user_vote: str
    price_at_vote: Decimal
    vote_distribution: dict
    participants_count: int
