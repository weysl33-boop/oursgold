"""Quote schemas"""
from datetime import datetime
from typing import Optional
from decimal import Decimal
from pydantic import BaseModel, Field


class QuoteBase(BaseModel):
    """Base quote schema"""
    symbol_code: str = Field(..., max_length=20)
    price: Decimal = Field(..., decimal_places=8)


class QuoteCreate(QuoteBase):
    """Schema for quote creation"""
    change: Optional[Decimal] = Field(None, decimal_places=8)
    change_percent: Optional[Decimal] = Field(None, decimal_places=4)
    high: Optional[Decimal] = Field(None, decimal_places=8)
    low: Optional[Decimal] = Field(None, decimal_places=8)
    open: Optional[Decimal] = Field(None, decimal_places=8)
    prev_close: Optional[Decimal] = Field(None, decimal_places=8)
    volume: Optional[int] = None
    timestamp: datetime


class QuoteResponse(QuoteBase):
    """Schema for quote response"""
    change: Optional[Decimal] = None
    change_percent: Optional[Decimal] = None
    high: Optional[Decimal] = None
    low: Optional[Decimal] = None
    open: Optional[Decimal] = None
    prev_close: Optional[Decimal] = None
    volume: Optional[int] = None
    timestamp: datetime
    market_status: Optional[str] = "trading"

    class Config:
        from_attributes = True


class QuoteWithSymbol(QuoteResponse):
    """Schema for quote with symbol information"""
    name_cn: str
    name_en: str
    market: str


class HistoricalQuote(BaseModel):
    """Schema for historical OHLCV data"""
    timestamp: datetime
    open: Decimal
    high: Decimal
    low: Decimal
    close: Decimal
    volume: Optional[int] = None

    class Config:
        from_attributes = True


class HistoricalQuoteResponse(BaseModel):
    """Schema for historical quote response"""
    symbol_code: str
    period: str
    interval: str
    data: list[HistoricalQuote]
