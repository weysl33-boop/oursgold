"""Symbol model"""
from datetime import datetime
from sqlalchemy import Column, String, Integer, Boolean, DateTime, Text
from sqlalchemy.orm import relationship

from app.core.database import Base


class Symbol(Base):
    """Symbol model for market instruments (gold, silver, forex, etc.)"""
    
    __tablename__ = "symbols"
    
    code = Column(String(20), primary_key=True)  # e.g., "XAUUSD", "EURUSD"
    name_cn = Column(String(100), nullable=False)  # e.g., "伦敦金"
    name_en = Column(String(100), nullable=False)  # e.g., "Spot Gold"
    market = Column(String(20), nullable=False, index=True)  # SGE, LBMA, COMEX, FOREX
    symbol_type = Column(String(20), nullable=False, index=True)  # gold, silver, currency
    base_currency = Column(String(10), nullable=True)
    quote_currency = Column(String(10), nullable=True)
    decimal_places = Column(Integer, default=2, nullable=False)
    unit = Column(String(20), nullable=True)  # "盎司", "克"
    description = Column(Text, nullable=True)
    is_active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    
    # Relationships
    quotes = relationship("Quote", back_populates="symbol", cascade="all, delete-orphan")
    comments = relationship("Comment", back_populates="symbol", cascade="all, delete-orphan")
    predictions = relationship("Prediction", back_populates="symbol", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<Symbol(code={self.code}, name_en={self.name_en})>"

