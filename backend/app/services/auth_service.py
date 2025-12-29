"""Authentication service"""
from datetime import timedelta
from typing import Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from fastapi import HTTPException, status

from app.models.user import User
from app.schemas.user import UserCreate, UserLogin, Token
from app.core.security import verify_password, get_password_hash, create_access_token
from app.core.config import settings


class AuthService:
    """Service for user authentication"""

    def __init__(self, db: AsyncSession):
        self.db = db

    async def register_user(self, user_data: UserCreate) -> User:
        """Register a new user"""
        # Check if username already exists
        stmt = select(User).where(User.username == user_data.username)
        result = await self.db.execute(stmt)
        if result.scalar_one_or_none():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Username already registered"
            )

        # Check if email already exists
        stmt = select(User).where(User.email == user_data.email)
        result = await self.db.execute(stmt)
        if result.scalar_one_or_none():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )

        # Create new user
        hashed_password = get_password_hash(user_data.password)
        new_user = User(
            username=user_data.username,
            email=user_data.email,
            password_hash=hashed_password
        )

        self.db.add(new_user)
        await self.db.commit()
        await self.db.refresh(new_user)

        return new_user

    async def authenticate_user(self, login_data: UserLogin) -> Optional[User]:
        """Authenticate a user with email and password"""
        stmt = select(User).where(User.email == login_data.email)
        result = await self.db.execute(stmt)
        user = result.scalar_one_or_none()

        if not user:
            return None

        if not verify_password(login_data.password, user.password_hash):
            return None

        if not user.is_active:
            return None

        return user

    async def get_user_by_id(self, user_id: UUID) -> Optional[User]:
        """Get user by ID"""
        stmt = select(User).where(User.id == user_id)
        result = await self.db.execute(stmt)
        return result.scalar_one_or_none()

    async def get_user_by_email(self, email: str) -> Optional[User]:
        """Get user by email"""
        stmt = select(User).where(User.email == email)
        result = await self.db.execute(stmt)
        return result.scalar_one_or_none()

    def create_token(self, user: User) -> Token:
        """Create access token for user"""
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            data={"sub": str(user.id), "email": user.email},
            expires_delta=access_token_expires
        )

        return Token(
            access_token=access_token,
            token_type="bearer",
            expires_in=settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60
        )
