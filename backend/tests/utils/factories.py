"""Test data factories using Faker"""
from datetime import datetime, timedelta
from typing import Optional
from faker import Faker
from uuid import UUID

fake = Faker()


def create_test_user_data(
    username: Optional[str] = None,
    email: Optional[str] = None,
    password: Optional[str] = None
) -> dict:
    """Generate test user data"""
    return {
        "username": username or fake.user_name(),
        "email": email or fake.email(),
        "password": password or "TestPassword123!"
    }


def create_test_comment_data(
    symbol_code: str = "XAUUSD",
    content: Optional[str] = None,
    parent_id: Optional[UUID] = None
) -> dict:
    """Generate test comment data"""
    return {
        "symbol_code": symbol_code,
        "content": content or fake.sentence(nb_words=10),
        "parent_id": str(parent_id) if parent_id else None
    }


def create_test_prediction_data(
    symbol_code: str = "XAUUSD",
    question: Optional[str] = None,
    hours_until_verify: int = 1
) -> dict:
    """Generate test prediction data"""
    verify_time = datetime.utcnow() + timedelta(hours=hours_until_verify)

    return {
        "symbol_code": symbol_code,
        "question": question or f"{symbol_code}价格会涨还是跌？",
        "options": [
            {"key": "A", "text": "涨超1%"},
            {"key": "B", "text": "小幅上涨"},
            {"key": "C", "text": "横盘"},
            {"key": "D", "text": "下跌"}
        ],
        "verify_time": verify_time.isoformat() + "Z",
        "verify_rule": "auto"
    }


def create_test_vote_data(selected_option: str = "A") -> dict:
    """Generate test vote data"""
    assert selected_option in ["A", "B", "C", "D"], "Invalid option"

    return {
        "selected_option": selected_option
    }


def create_mock_quote_data(
    symbol_code: str = "XAUUSD",
    price: float = 2650.50
) -> dict:
    """Generate mock quote data for testing"""
    return {
        "symbol_code": symbol_code,
        "price": price,
        "change": fake.pyfloat(min_value=-50, max_value=50, right_digits=2),
        "change_percent": fake.pyfloat(min_value=-2, max_value=2, right_digits=2),
        "high": price + fake.pyfloat(min_value=0, max_value=20, right_digits=2),
        "low": price - fake.pyfloat(min_value=0, max_value=20, right_digits=2),
        "open": price + fake.pyfloat(min_value=-10, max_value=10, right_digits=2),
        "prev_close": price - fake.pyfloat(min_value=-10, max_value=10, right_digits=2),
        "volume": fake.random_int(min=10000, max=1000000),
        "timestamp": datetime.utcnow().isoformat() + "Z"
    }


def create_mock_historical_data(
    symbol_code: str = "XAUUSD",
    num_points: int = 10
) -> list:
    """Generate mock historical OHLCV data"""
    base_price = 2650.0
    data = []

    for i in range(num_points):
        timestamp = datetime.utcnow() - timedelta(minutes=5 * (num_points - i))
        open_price = base_price + fake.pyfloat(min_value=-10, max_value=10, right_digits=2)
        high_price = open_price + fake.pyfloat(min_value=0, max_value=5, right_digits=2)
        low_price = open_price - fake.pyfloat(min_value=0, max_value=5, right_digits=2)
        close_price = fake.pyfloat(min_value=low_price, max_value=high_price, right_digits=2)

        data.append({
            "timestamp": timestamp.isoformat() + "Z",
            "open": open_price,
            "high": high_price,
            "low": low_price,
            "close": close_price,
            "volume": fake.random_int(min=1000, max=100000)
        })

    return data
