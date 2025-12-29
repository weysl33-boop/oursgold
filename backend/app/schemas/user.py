"""User schemas"""
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, EmailStr, Field
from uuid import UUID


class UserBase(BaseModel):
    """Base user schema"""
    username: str = Field(..., min_length=3, max_length=50)
    email: EmailStr


class UserCreate(UserBase):
    """Schema for user registration"""
    password: str = Field(..., min_length=8, max_length=100)


class UserUpdate(BaseModel):
    """Schema for user profile update"""
    username: Optional[str] = Field(None, min_length=3, max_length=50)
    avatar_url: Optional[str] = Field(None, max_length=500)


class UserResponse(UserBase):
    """Schema for user response"""
    id: UUID
    avatar_url: Optional[str] = None
    created_at: datetime
    is_active: bool

    class Config:
        from_attributes = True


class UserInDB(UserResponse):
    """Schema for user in database (includes sensitive fields)"""
    password_hash: str
    updated_at: datetime


class UserLogin(BaseModel):
    """Schema for user login"""
    email: EmailStr
    password: str


class Token(BaseModel):
    """Schema for JWT token response"""
    access_token: str
    token_type: str = "bearer"
    expires_in: int


class TokenData(BaseModel):
    """Schema for token payload"""
    user_id: Optional[UUID] = None
    email: Optional[str] = None
