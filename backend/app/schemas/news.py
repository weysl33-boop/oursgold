"""News schemas"""
from datetime import datetime
from typing import Optional
from uuid import UUID
from pydantic import BaseModel, Field


class NewsBase(BaseModel):
    """Base news schema"""
    title: str = Field(..., min_length=1, max_length=500)
    source: str = Field(..., max_length=100)
    source_url: str = Field(..., max_length=1000)
    category: str = Field(..., pattern="^(gold|forex|market|economic)$")


class NewsCreate(NewsBase):
    """Schema for news creation"""
    content: Optional[str] = None
    summary: Optional[str] = None
    author: Optional[str] = Field(None, max_length=200)
    thumbnail_url: Optional[str] = Field(None, max_length=1000)
    related_symbols: Optional[list[str]] = None
    published_at: datetime


class NewsUpdate(BaseModel):
    """Schema for news update"""
    title: Optional[str] = Field(None, min_length=1, max_length=500)
    content: Optional[str] = None
    summary: Optional[str] = None
    thumbnail_url: Optional[str] = Field(None, max_length=1000)
    related_symbols: Optional[list[str]] = None


class NewsResponse(NewsBase):
    """Schema for news response"""
    id: UUID
    content: Optional[str] = None
    summary: Optional[str] = None
    author: Optional[str] = None
    thumbnail_url: Optional[str] = None
    related_symbols: Optional[list[str]] = None
    published_at: datetime
    created_at: datetime

    class Config:
        from_attributes = True


class NewsListItem(BaseModel):
    """Schema for news list item (without full content)"""
    id: UUID
    title: str
    summary: Optional[str] = None
    source: str
    category: str
    thumbnail_url: Optional[str] = None
    published_at: datetime

    class Config:
        from_attributes = True


class NewsListResponse(BaseModel):
    """Schema for news list response with pagination"""
    news: list[NewsListItem]
    pagination: dict
