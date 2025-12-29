"""Vote model"""
from datetime import datetime
from sqlalchemy import Column, String, DECIMAL, Boolean, DateTime, ForeignKey, Index
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid

from app.core.database import Base


class Vote(Base):
    """Vote model for prediction voting"""

    __tablename__ = "votes"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    prediction_id = Column(UUID(as_uuid=True), ForeignKey("predictions.id", ondelete="CASCADE"), nullable=False)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    selected_option = Column(String(1), nullable=False)  # A, B, C, or D
    price_at_vote = Column(DECIMAL(20, 8), nullable=False)  # Price when user voted
    is_correct = Column(Boolean, nullable=True)  # Filled after verification
    voted_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    prediction = relationship("Prediction", back_populates="votes")
    user = relationship("User", back_populates="votes")

    # Indexes
    __table_args__ = (
        Index('idx_votes_prediction', 'prediction_id'),
        Index('idx_votes_user', 'user_id', 'voted_at'),
    )

    def __repr__(self):
        return f"<Vote(id={self.id}, prediction_id={self.prediction_id}, selected_option={self.selected_option})>"
