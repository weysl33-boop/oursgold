"""Test assertion helpers"""
from typing import Any, Dict, Optional
from decimal import Decimal
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select


def assert_response_success(response: Dict[str, Any], expected_status: int = 200):
    """Assert that API response is successful"""
    assert response.get("status") == expected_status, (
        f"Expected status {expected_status}, got {response.get('status')}. "
        f"Response: {response.get('data')}"
    )
    assert "error" not in response, f"Unexpected error in response: {response.get('error')}"


def assert_response_error(response: Dict[str, Any], expected_status: int, error_message: Optional[str] = None):
    """Assert that API response contains expected error"""
    assert response.get("status") == expected_status, (
        f"Expected error status {expected_status}, got {response.get('status')}"
    )

    if error_message:
        data = response.get("data", {})
        detail = data.get("detail", "") if isinstance(data, dict) else str(data)
        assert error_message.lower() in detail.lower(), (
            f"Expected error message containing '{error_message}', got '{detail}'"
        )


async def assert_database_record_exists(session: AsyncSession, model, **filters):
    """Assert that a database record exists with given filters"""
    stmt = select(model)
    for key, value in filters.items():
        stmt = stmt.where(getattr(model, key) == value)

    result = await session.execute(stmt)
    record = result.scalar_one_or_none()

    assert record is not None, (
        f"Expected {model.__name__} record with filters {filters} to exist, but not found"
    )

    return record


async def assert_database_record_count(session: AsyncSession, model, expected_count: int, **filters):
    """Assert that database has expected number of records"""
    from sqlalchemy import func

    stmt = select(func.count()).select_from(model)
    for key, value in filters.items():
        stmt = stmt.where(getattr(model, key) == value)

    result = await session.execute(stmt)
    count = result.scalar()

    assert count == expected_count, (
        f"Expected {expected_count} {model.__name__} records with filters {filters}, "
        f"but found {count}"
    )


def assert_price_anchored(record, expected_price: Optional[Decimal] = None, tolerance: float = 0.01):
    """Assert that a record has price anchoring field set correctly"""
    price_field = None

    # Determine which price field to check
    if hasattr(record, "price_at_comment"):
        price_field = record.price_at_comment
    elif hasattr(record, "price_at_create"):
        price_field = record.price_at_create
    elif hasattr(record, "price_at_vote"):
        price_field = record.price_at_vote

    assert price_field is not None, "Record does not have a price anchoring field"
    assert price_field > 0, f"Price anchoring field must be positive, got {price_field}"

    if expected_price:
        diff = abs(float(price_field) - float(expected_price))
        assert diff <= tolerance, (
            f"Price anchoring value {price_field} differs from expected {expected_price} "
            f"by more than tolerance {tolerance}"
        )


def assert_performance_within_threshold(timing: Dict[str, float], max_ms: float = 200):
    """Assert that API response time is within acceptable threshold"""
    total_time = timing.get("total", 0)

    assert total_time <= max_ms, (
        f"Response time {total_time:.2f}ms exceeds threshold of {max_ms}ms. "
        f"Timing breakdown: {timing}"
    )


def assert_jwt_token_valid(token: str):
    """Assert that JWT token is valid and properly formatted"""
    assert token, "Token is empty"
    assert isinstance(token, str), f"Token must be string, got {type(token)}"

    # JWT tokens have 3 parts separated by dots
    parts = token.split(".")
    assert len(parts) == 3, f"Invalid JWT format, expected 3 parts, got {len(parts)}"

    # Each part should be base64-encoded (non-empty)
    for i, part in enumerate(parts):
        assert len(part) > 0, f"JWT part {i} is empty"


def assert_pagination_valid(pagination: Dict[str, Any]):
    """Assert that pagination object is valid"""
    assert "page" in pagination, "Pagination missing 'page' field"
    assert "limit" in pagination, "Pagination missing 'limit' field"
    assert "total" in pagination, "Pagination missing 'total' field"
    assert "has_more" in pagination, "Pagination missing 'has_more' field"

    assert pagination["page"] >= 1, "Page must be >= 1"
    assert pagination["limit"] >= 1, "Limit must be >= 1"
    assert pagination["total"] >= 0, "Total must be >= 0"
    assert isinstance(pagination["has_more"], bool), "has_more must be boolean"


def assert_uuid_valid(uuid_str: str):
    """Assert that string is a valid UUID"""
    from uuid import UUID

    try:
        UUID(uuid_str)
    except (ValueError, AttributeError):
        raise AssertionError(f"Invalid UUID format: {uuid_str}")


def assert_timestamp_recent(timestamp_str: str, max_age_seconds: int = 60):
    """Assert that timestamp is recent (within max_age_seconds)"""
    from datetime import datetime, timezone

    try:
        timestamp = datetime.fromisoformat(timestamp_str.replace("Z", "+00:00"))
    except (ValueError, AttributeError):
        raise AssertionError(f"Invalid timestamp format: {timestamp_str}")

    now = datetime.now(timezone.utc)
    age = (now - timestamp).total_seconds()

    assert age <= max_age_seconds, (
        f"Timestamp {timestamp_str} is {age:.1f}s old, exceeds max age of {max_age_seconds}s"
    )
