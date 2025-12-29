"""Seed default symbols into database"""
import asyncio
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker

from app.core.config import settings
from app.models.symbol import Symbol


# Default symbols to seed
DEFAULT_SYMBOLS = [
    # Gold
    {
        "code": "XAUUSD",
        "name_cn": "伦敦金",
        "name_en": "Spot Gold",
        "market": "LBMA",
        "symbol_type": "gold",
        "base_currency": "XAU",
        "quote_currency": "USD",
        "decimal_places": 2,
        "unit": "盎司",
        "description": "London Bullion Market Association spot gold price in USD per troy ounce"
    },
    # Silver
    {
        "code": "XAGUSD",
        "name_cn": "伦敦银",
        "name_en": "Spot Silver",
        "market": "LBMA",
        "symbol_type": "silver",
        "base_currency": "XAG",
        "quote_currency": "USD",
        "decimal_places": 3,
        "unit": "盎司",
        "description": "London Bullion Market Association spot silver price in USD per troy ounce"
    },
    # Major Forex Pairs
    {
        "code": "EURUSD",
        "name_cn": "欧元/美元",
        "name_en": "EUR/USD",
        "market": "FOREX",
        "symbol_type": "currency",
        "base_currency": "EUR",
        "quote_currency": "USD",
        "decimal_places": 5,
        "unit": None,
        "description": "Euro vs US Dollar exchange rate"
    },
    {
        "code": "GBPUSD",
        "name_cn": "英镑/美元",
        "name_en": "GBP/USD",
        "market": "FOREX",
        "symbol_type": "currency",
        "base_currency": "GBP",
        "quote_currency": "USD",
        "decimal_places": 5,
        "unit": None,
        "description": "British Pound vs US Dollar exchange rate"
    },
    {
        "code": "USDJPY",
        "name_cn": "美元/日元",
        "name_en": "USD/JPY",
        "market": "FOREX",
        "symbol_type": "currency",
        "base_currency": "USD",
        "quote_currency": "JPY",
        "decimal_places": 3,
        "unit": None,
        "description": "US Dollar vs Japanese Yen exchange rate"
    },
    {
        "code": "USDCNY",
        "name_cn": "美元/人民币",
        "name_en": "USD/CNY",
        "market": "FOREX",
        "symbol_type": "currency",
        "base_currency": "USD",
        "quote_currency": "CNY",
        "decimal_places": 4,
        "unit": None,
        "description": "US Dollar vs Chinese Yuan exchange rate"
    },
    # Shanghai Gold Exchange (SGE) symbols
    {
        "code": "AU9999",
        "name_cn": "上金所黄金9999",
        "name_en": "SGE Gold 9999",
        "market": "SGE",
        "symbol_type": "gold",
        "base_currency": None,
        "quote_currency": "CNY",
        "decimal_places": 2,
        "unit": "克",
        "description": "Shanghai Gold Exchange 99.99% pure gold price in CNY per gram"
    },
    {
        "code": "AU9995",
        "name_cn": "上金所黄金9995",
        "name_en": "SGE Gold 9995",
        "market": "SGE",
        "symbol_type": "gold",
        "base_currency": None,
        "quote_currency": "CNY",
        "decimal_places": 2,
        "unit": "克",
        "description": "Shanghai Gold Exchange 99.95% pure gold price in CNY per gram"
    },
]


async def seed_symbols():
    """Seed default symbols into database"""
    # Create async engine
    engine = create_async_engine(settings.DATABASE_URL, echo=True)

    # Create async session
    async_session = sessionmaker(
        engine, class_=AsyncSession, expire_on_commit=False
    )

    async with async_session() as session:
        try:
            # Check existing symbols
            from sqlalchemy import select
            stmt = select(Symbol)
            result = await session.execute(stmt)
            existing_symbols = {s.code for s in result.scalars().all()}

            # Add new symbols
            added_count = 0
            for symbol_data in DEFAULT_SYMBOLS:
                if symbol_data["code"] not in existing_symbols:
                    symbol = Symbol(**symbol_data)
                    session.add(symbol)
                    added_count += 1
                    print(f"✓ Added symbol: {symbol_data['code']} - {symbol_data['name_en']}")
                else:
                    print(f"- Symbol already exists: {symbol_data['code']}")

            await session.commit()
            print(f"\n✓ Seeding completed! Added {added_count} new symbols.")

        except Exception as e:
            print(f"✗ Error seeding symbols: {e}")
            await session.rollback()
        finally:
            await engine.dispose()


if __name__ == "__main__":
    asyncio.run(seed_symbols())
