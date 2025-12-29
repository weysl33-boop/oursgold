"""Comment model"""
from datetime import datetime
from sqlalchemy import Column, String, Text, DECIMAL, Integer, Boolean, DateTime, ForeignKey, Index
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid

from app.core.database import Base


class Comment(Base):
    """Comment model for price-anchored comments"""

    __tablename__ = "comments"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    symbol_code = Column(String(20), ForeignKey("symbols.code", ondelete="CASCADE"), nullable=False)
    content = Column(Text, nullable=False)
    price_at_comment = Column(DECIMAL(20, 8), nullable=False)  # Key feature: price anchor
    parent_id = Column(UUID(as_uuid=True), ForeignKey("comments.id", ondelete="CASCADE"), nullable=True)
    likes_count = Column(Integer, default=0, nullable=False)
    replies_count = Column(Integer, default=0, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    is_deleted = Column(Boolean, default=False, nullable=False)

    # Relationships
    user = relationship("User", back_populates="comments")
    symbol = relationship("Symbol", back_populates="comments")
    parent = relationship("Comment", remote_side=[id], backref="replies")
    likes = relationship("CommentLike", back_populates="comment", cascade="all, delete-orphan")

    # Indexes
    __table_args__ = (
        Index('idx_comments_symbol', 'symbol_code', 'created_at'),
        Index('idx_comments_user', 'user_id', 'created_at'),
        Index('idx_comments_parent', 'parent_id'),
    )

    def __repr__(self):
        return f"<Comment(id={self.id}, user_id={self.user_id}, symbol={self.symbol_code})>"


class CommentLike(Base):
    """CommentLike model for tracking comment likes"""

    __tablename__ = "comment_likes"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    comment_id = Column(UUID(as_uuid=True), ForeignKey("comments.id", ondelete="CASCADE"), nullable=False)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    comment = relationship("Comment", back_populates="likes")
    user = relationship("User")

    # Indexes and constraints
    __table_args__ = (
        Index('idx_comment_likes_comment', 'comment_id'),
        Index('idx_comment_likes_user', 'user_id'),
    )

    def __repr__(self):
        return f"<CommentLike(id={self.id}, comment_id={self.comment_id}, user_id={self.user_id})>"
