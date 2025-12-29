"""Database fixtures for E2E testing"""
import pytest
import pytest_asyncio
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.pool import NullPool
from typing import AsyncGenerator

from app.core.config import settings
from app.core.database import Base
from app.models import User, Symbol
from app.core.security import get_password_hash


# Test database URL (use separate test database)
TEST_DATABASE_URL = settings.DATABASE_URL.replace("gold_platform", "gold_platform_test")


@pytest_asyncio.fixture(scope="session")
async def test_engine():
    """Create test database engine"""
    engine = create_async_engine(
        TEST_DATABASE_URL,
        echo=False,
        poolclass=NullPool,  # Disable connection pooling for tests
    )

    # Create all tables
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    yield engine

    # Drop all tables after tests
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)

    await engine.dispose()


@pytest_asyncio.fixture
async def db_session(test_engine) -> AsyncGenerator[AsyncSession, None]:
    """
    Create a new database session for each test with transaction rollback.

    This ensures test isolation - each test runs in a transaction that is
    rolled back after the test completes.
    """
    # Create session factory
    async_session = async_sessionmaker(
        test_engine,
        class_=AsyncSession,
        expire_on_commit=False,
    )

    async with async_session() as session:
        # Begin a transaction
        async with session.begin():
            yield session
            # Transaction will be rolled back automatically after yield


@pytest_asyncio.fixture(scope="session")
async def seed_test_symbols(test_engine):
    """Seed test database with default symbols (once per session)"""
    async_session = async_sessionmaker(
        test_engine,
        class_=AsyncSession,
        expire_on_commit=False,
    )

    async with async_session() as session:
        # Check if symbols already exist
        from sqlalchemy import select
        stmt = select(Symbol)
        result = await session.execute(stmt)
        existing = result.scalars().first()

        if not existing:
            # Insert default symbols
            symbols = [
                Symbol(
                    code="XAUUSD",
                    name_cn="伦敦金",
                    name_en="Spot Gold",
                    market="LBMA",
                    symbol_type="gold",
                    base_currency="XAU",
                    quote_currency="USD",
                    decimal_places=2,
                    unit="盎司",
                    description="London Bullion Market Association spot gold price"
                ),
                Symbol(
                    code="XAGUSD",
                    name_cn="伦敦银",
                    name_en="Spot Silver",
                    market="LBMA",
                    symbol_type="silver",
                    base_currency="XAG",
                    quote_currency="USD",
                    decimal_places=3,
                    unit="盎司",
                    description="London Bullion Market Association spot silver price"
                ),
                Symbol(
                    code="EURUSD",
                    name_cn="欧元/美元",
                    name_en="EUR/USD",
                    market="FOREX",
                    symbol_type="currency",
                    base_currency="EUR",
                    quote_currency="USD",
                    decimal_places=5,
                    description="Euro vs US Dollar exchange rate"
                ),
            ]

            for symbol in symbols:
                session.add(symbol)

            await session.commit()


@pytest_asyncio.fixture
async def test_user(db_session: AsyncSession) -> User:
    """Create a test user for authenticated requests"""
    user = User(
        username="testuser",
        email="test@example.com",
        password_hash=get_password_hash("TestPassword123!"),
        is_active=True
    )

    db_session.add(user)
    await db_session.commit()
    await db_session.refresh(user)

    return user


@pytest_asyncio.fixture
async def auth_token(test_user: User) -> str:
    """Generate JWT token for test user"""
    from app.core.security import create_access_token
    from datetime import timedelta

    access_token = create_access_token(
        data={"sub": str(test_user.id), "email": test_user.email},
        expires_delta=timedelta(hours=1)
    )

    return access_token


@pytest.fixture
def auth_headers(auth_token: str) -> dict:
    """Generate authorization headers for authenticated requests"""
    return {"Authorization": f"Bearer {auth_token}"}
