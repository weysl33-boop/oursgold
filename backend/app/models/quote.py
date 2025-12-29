"""Quote model"""
from datetime import datetime
from sqlalchemy import Column, String, DECIMAL, BigInteger, DateTime, ForeignKey, Index
from sqlalchemy.orm import relationship

from app.core.database import Base


class Quote(Base):
    """Quote model for historical market prices"""

    __tablename__ = "quotes"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    symbol_code = Column(String(20), ForeignKey("symbols.code", ondelete="CASCADE"), nullable=False)
    price = Column(DECIMAL(20, 8), nullable=False)
    change = Column(DECIMAL(20, 8), nullable=True)
    change_percent = Column(DECIMAL(10, 4), nullable=True)
    high = Column(DECIMAL(20, 8), nullable=True)
    low = Column(DECIMAL(20, 8), nullable=True)
    open = Column(DECIMAL(20, 8), nullable=True)
    prev_close = Column(DECIMAL(20, 8), nullable=True)
    volume = Column(BigInteger, nullable=True)
    timestamp = Column(DateTime, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    symbol = relationship("Symbol", back_populates="quotes")

    # Indexes
    __table_args__ = (
        Index('idx_quotes_symbol_timestamp', 'symbol_code', 'timestamp'),
        Index('idx_quotes_timestamp', 'timestamp'),
    )

    def __repr__(self):
        return f"<Quote(symbol={self.symbol_code}, price={self.price}, timestamp={self.timestamp})>"
