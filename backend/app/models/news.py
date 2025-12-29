"""News model"""
from datetime import datetime
from sqlalchemy import Column, String, Text, DateTime, Index
from sqlalchemy.dialects.postgresql import UUID, ARRAY
import uuid

from app.core.database import Base


class News(Base):
    """News model for financial news aggregation"""

    __tablename__ = "news"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title = Column(String(500), nullable=False)
    content = Column(Text, nullable=True)
    summary = Column(Text, nullable=True)
    source = Column(String(100), nullable=False)  # Source name (e.g., "Reuters", "Bloomberg")
    source_url = Column(String(1000), nullable=False)  # Original article URL
    author = Column(String(200), nullable=True)
    category = Column(String(50), nullable=False)  # "gold", "forex", "market", "economic"
    thumbnail_url = Column(String(1000), nullable=True)
    related_symbols = Column(ARRAY(String), nullable=True)  # Related symbol codes
    published_at = Column(DateTime, nullable=False)  # Original publication time
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Indexes
    __table_args__ = (
        Index('idx_news_category', 'category', 'published_at'),
        Index('idx_news_published_at', 'published_at'),
        Index('idx_news_source_url', 'source_url', unique=True),  # For deduplication
    )

    def __repr__(self):
        return f"<News(id={self.id}, title={self.title[:50]}, category={self.category})>"
