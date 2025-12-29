"""Prediction model"""
from datetime import datetime
from sqlalchemy import Column, String, Text, DECIMAL, Integer, DateTime, ForeignKey, Index
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
import uuid

from app.core.database import Base


class Prediction(Base):
    """Prediction model for ABCD prediction voting"""

    __tablename__ = "predictions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    symbol_code = Column(String(20), ForeignKey("symbols.code", ondelete="CASCADE"), nullable=False)
    question = Column(Text, nullable=False)
    options = Column(JSONB, nullable=False)  # [{"key": "A", "text": "涨超1%"}, ...]
    price_at_create = Column(DECIMAL(20, 8), nullable=False)  # Key feature: price anchor
    price_at_verify = Column(DECIMAL(20, 8), nullable=True)  # Filled at verification
    verify_time = Column(DateTime, nullable=False)
    correct_option = Column(String(1), nullable=True)  # A, B, C, or D
    verify_rule = Column(String(20), default='auto', nullable=False)  # auto or manual
    auto_verify_conditions = Column(JSONB, nullable=True)  # Rules for auto verification
    status = Column(String(20), default='active', nullable=False)  # active, ended, cancelled
    participants_count = Column(Integer, default=0, nullable=False)
    comments_count = Column(Integer, default=0, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    user = relationship("User", back_populates="predictions")
    symbol = relationship("Symbol", back_populates="predictions")
    votes = relationship("Vote", back_populates="prediction", cascade="all, delete-orphan")

    # Indexes
    __table_args__ = (
        Index('idx_predictions_symbol', 'symbol_code', 'created_at'),
        Index('idx_predictions_user', 'user_id', 'created_at'),
        Index('idx_predictions_status', 'status', 'verify_time'),
    )

    def __repr__(self):
        return f"<Prediction(id={self.id}, question={self.question[:30]}, status={self.status})>"
