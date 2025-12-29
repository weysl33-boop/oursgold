"""Symbol schemas"""
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, Field


class SymbolBase(BaseModel):
    """Base symbol schema"""
    code: str = Field(..., max_length=20)
    name_cn: str = Field(..., max_length=100)
    name_en: str = Field(..., max_length=100)
    market: str = Field(..., max_length=20)
    symbol_type: str = Field(..., max_length=20)


class SymbolCreate(SymbolBase):
    """Schema for symbol creation"""
    base_currency: Optional[str] = Field(None, max_length=10)
    quote_currency: Optional[str] = Field(None, max_length=10)
    decimal_places: int = Field(default=2, ge=0, le=8)
    unit: Optional[str] = Field(None, max_length=20)
    description: Optional[str] = None


class SymbolUpdate(BaseModel):
    """Schema for symbol update"""
    name_cn: Optional[str] = Field(None, max_length=100)
    name_en: Optional[str] = Field(None, max_length=100)
    is_active: Optional[bool] = None
    description: Optional[str] = None


class SymbolResponse(SymbolBase):
    """Schema for symbol response"""
    base_currency: Optional[str] = None
    quote_currency: Optional[str] = None
    decimal_places: int
    unit: Optional[str] = None
    description: Optional[str] = None
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True
