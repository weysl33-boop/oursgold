"""Comment schemas"""
from datetime import datetime
from typing import Optional
from decimal import Decimal
from uuid import UUID
from pydantic import BaseModel, Field

from app.schemas.user import UserResponse


class CommentBase(BaseModel):
    """Base comment schema"""
    symbol_code: str = Field(..., max_length=20)
    content: str = Field(..., min_length=1, max_length=2000)


class CommentCreate(CommentBase):
    """Schema for comment creation"""
    parent_id: Optional[UUID] = None


class CommentUpdate(BaseModel):
    """Schema for comment update"""
    content: str = Field(..., min_length=1, max_length=2000)


class CommentResponse(CommentBase):
    """Schema for comment response"""
    id: UUID
    user: UserResponse
    price_at_comment: Decimal
    parent_id: Optional[UUID] = None
    likes_count: int
    replies_count: int
    created_at: datetime
    is_deleted: bool

    class Config:
        from_attributes = True


class CommentWithReplies(CommentResponse):
    """Schema for comment with replies"""
    replies: list[CommentResponse] = []


class CommentLikeResponse(BaseModel):
    """Schema for comment like response"""
    comment_id: UUID
    likes_count: int
    user_liked: bool


class CommentListResponse(BaseModel):
    """Schema for comment list response with pagination"""
    comments: list[CommentWithReplies]
    pagination: dict
