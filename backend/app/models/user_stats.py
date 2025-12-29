"""User prediction statistics model"""
from datetime import datetime
from sqlalchemy import Column, String, Integer, DECIMAL, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship

from app.core.database import Base


class UserPredictionStats(Base):
    """UserPredictionStats model for tracking user prediction performance"""

    __tablename__ = "user_prediction_stats"

    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    total_predictions = Column(Integer, default=0, nullable=False)  # Predictions created
    total_participations = Column(Integer, default=0, nullable=False)  # Predictions voted on
    correct_count = Column(Integer, default=0, nullable=False)
    accuracy_rate = Column(DECIMAL(5, 2), default=0.00, nullable=False)  # Percentage
    current_streak = Column(Integer, default=0, nullable=False)
    max_streak = Column(Integer, default=0, nullable=False)
    prediction_score = Column(Integer, default=0, nullable=False)  # Gamification points
    rank_title = Column(String(50), default='预测新手', nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    user = relationship("User", back_populates="prediction_stats")

    def __repr__(self):
        return f"<UserPredictionStats(user_id={self.user_id}, accuracy_rate={self.accuracy_rate})>"
