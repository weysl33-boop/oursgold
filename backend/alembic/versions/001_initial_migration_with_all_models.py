"""Initial migration with all models

Revision ID: 001
Revises:
Create Date: 2025-12-29 08:51:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = '001'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Create users table
    op.create_table(
        'users',
        sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column('username', sa.String(50), nullable=False, unique=True),
        sa.Column('email', sa.String(255), nullable=False, unique=True),
        sa.Column('password_hash', sa.String(255), nullable=False),
        sa.Column('avatar_url', sa.String(500), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
        sa.Column('updated_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
        sa.Column('is_active', sa.Boolean(), nullable=False, server_default=sa.text('TRUE')),
    )
    op.create_index('idx_users_email', 'users', ['email'])
    op.create_index('idx_users_username', 'users', ['username'])

    # Create symbols table
    op.create_table(
        'symbols',
        sa.Column('code', sa.String(20), primary_key=True),
        sa.Column('name_cn', sa.String(100), nullable=False),
        sa.Column('name_en', sa.String(100), nullable=False),
        sa.Column('market', sa.String(20), nullable=False),
        sa.Column('symbol_type', sa.String(20), nullable=False),
        sa.Column('base_currency', sa.String(10), nullable=True),
        sa.Column('quote_currency', sa.String(10), nullable=True),
        sa.Column('decimal_places', sa.Integer(), nullable=False, server_default=sa.text('2')),
        sa.Column('unit', sa.String(20), nullable=True),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('is_active', sa.Boolean(), nullable=False, server_default=sa.text('TRUE')),
        sa.Column('created_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
    )
    op.create_index('idx_symbols_market', 'symbols', ['market'])
    op.create_index('idx_symbols_type', 'symbols', ['symbol_type'])

    # Create quotes table
    op.create_table(
        'quotes',
        sa.Column('id', sa.BigInteger(), primary_key=True, autoincrement=True),
        sa.Column('symbol_code', sa.String(20), sa.ForeignKey('symbols.code', ondelete='CASCADE'), nullable=False),
        sa.Column('price', sa.DECIMAL(20, 8), nullable=False),
        sa.Column('change', sa.DECIMAL(20, 8), nullable=True),
        sa.Column('change_percent', sa.DECIMAL(10, 4), nullable=True),
        sa.Column('high', sa.DECIMAL(20, 8), nullable=True),
        sa.Column('low', sa.DECIMAL(20, 8), nullable=True),
        sa.Column('open', sa.DECIMAL(20, 8), nullable=True),
        sa.Column('prev_close', sa.DECIMAL(20, 8), nullable=True),
        sa.Column('volume', sa.BigInteger(), nullable=True),
        sa.Column('timestamp', sa.DateTime(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
    )
    op.create_index('idx_quotes_symbol_timestamp', 'quotes', ['symbol_code', 'timestamp'])
    op.create_index('idx_quotes_timestamp', 'quotes', ['timestamp'])

    # Create comments table
    op.create_table(
        'comments',
        sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column('user_id', postgresql.UUID(as_uuid=True), sa.ForeignKey('users.id', ondelete='CASCADE'), nullable=False),
        sa.Column('symbol_code', sa.String(20), sa.ForeignKey('symbols.code', ondelete='CASCADE'), nullable=False),
        sa.Column('content', sa.Text(), nullable=False),
        sa.Column('price_at_comment', sa.DECIMAL(20, 8), nullable=False),
        sa.Column('parent_id', postgresql.UUID(as_uuid=True), sa.ForeignKey('comments.id', ondelete='CASCADE'), nullable=True),
        sa.Column('likes_count', sa.Integer(), nullable=False, server_default=sa.text('0')),
        sa.Column('replies_count', sa.Integer(), nullable=False, server_default=sa.text('0')),
        sa.Column('created_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
        sa.Column('updated_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
        sa.Column('is_deleted', sa.Boolean(), nullable=False, server_default=sa.text('FALSE')),
    )
    op.create_index('idx_comments_symbol', 'comments', ['symbol_code', 'created_at'])
    op.create_index('idx_comments_user', 'comments', ['user_id', 'created_at'])
    op.create_index('idx_comments_parent', 'comments', ['parent_id'])

    # Create comment_likes table
    op.create_table(
        'comment_likes',
        sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column('comment_id', postgresql.UUID(as_uuid=True), sa.ForeignKey('comments.id', ondelete='CASCADE'), nullable=False),
        sa.Column('user_id', postgresql.UUID(as_uuid=True), sa.ForeignKey('users.id', ondelete='CASCADE'), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
    )
    op.create_index('idx_comment_likes_comment', 'comment_likes', ['comment_id'])
    op.create_index('idx_comment_likes_user', 'comment_likes', ['user_id'])
    op.create_unique_constraint('uq_comment_likes_comment_user', 'comment_likes', ['comment_id', 'user_id'])

    # Create predictions table
    op.create_table(
        'predictions',
        sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column('user_id', postgresql.UUID(as_uuid=True), sa.ForeignKey('users.id', ondelete='CASCADE'), nullable=False),
        sa.Column('symbol_code', sa.String(20), sa.ForeignKey('symbols.code', ondelete='CASCADE'), nullable=False),
        sa.Column('question', sa.Text(), nullable=False),
        sa.Column('options', postgresql.JSONB(), nullable=False),
        sa.Column('price_at_create', sa.DECIMAL(20, 8), nullable=False),
        sa.Column('price_at_verify', sa.DECIMAL(20, 8), nullable=True),
        sa.Column('verify_time', sa.DateTime(), nullable=False),
        sa.Column('correct_option', sa.String(1), nullable=True),
        sa.Column('verify_rule', sa.String(20), nullable=False, server_default=sa.text("'auto'")),
        sa.Column('auto_verify_conditions', postgresql.JSONB(), nullable=True),
        sa.Column('status', sa.String(20), nullable=False, server_default=sa.text("'active'")),
        sa.Column('participants_count', sa.Integer(), nullable=False, server_default=sa.text('0')),
        sa.Column('comments_count', sa.Integer(), nullable=False, server_default=sa.text('0')),
        sa.Column('created_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
        sa.Column('updated_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
    )
    op.create_index('idx_predictions_symbol', 'predictions', ['symbol_code', 'created_at'])
    op.create_index('idx_predictions_user', 'predictions', ['user_id', 'created_at'])
    op.create_index('idx_predictions_status', 'predictions', ['status', 'verify_time'])

    # Create votes table
    op.create_table(
        'votes',
        sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column('prediction_id', postgresql.UUID(as_uuid=True), sa.ForeignKey('predictions.id', ondelete='CASCADE'), nullable=False),
        sa.Column('user_id', postgresql.UUID(as_uuid=True), sa.ForeignKey('users.id', ondelete='CASCADE'), nullable=False),
        sa.Column('selected_option', sa.String(1), nullable=False),
        sa.Column('price_at_vote', sa.DECIMAL(20, 8), nullable=False),
        sa.Column('is_correct', sa.Boolean(), nullable=True),
        sa.Column('voted_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
    )
    op.create_index('idx_votes_prediction', 'votes', ['prediction_id'])
    op.create_index('idx_votes_user', 'votes', ['user_id', 'voted_at'])
    op.create_unique_constraint('uq_votes_prediction_user', 'votes', ['prediction_id', 'user_id'])

    # Create user_prediction_stats table
    op.create_table(
        'user_prediction_stats',
        sa.Column('user_id', postgresql.UUID(as_uuid=True), sa.ForeignKey('users.id', ondelete='CASCADE'), primary_key=True),
        sa.Column('total_predictions', sa.Integer(), nullable=False, server_default=sa.text('0')),
        sa.Column('total_participations', sa.Integer(), nullable=False, server_default=sa.text('0')),
        sa.Column('correct_count', sa.Integer(), nullable=False, server_default=sa.text('0')),
        sa.Column('accuracy_rate', sa.DECIMAL(5, 2), nullable=False, server_default=sa.text('0.00')),
        sa.Column('current_streak', sa.Integer(), nullable=False, server_default=sa.text('0')),
        sa.Column('max_streak', sa.Integer(), nullable=False, server_default=sa.text('0')),
        sa.Column('prediction_score', sa.Integer(), nullable=False, server_default=sa.text('0')),
        sa.Column('rank_title', sa.String(50), nullable=False, server_default=sa.text("'预测新手'")),
        sa.Column('updated_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
    )
    op.create_index('idx_user_stats_accuracy', 'user_prediction_stats', ['accuracy_rate'])
    op.create_index('idx_user_stats_score', 'user_prediction_stats', ['prediction_score'])

    # Create news table
    op.create_table(
        'news',
        sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column('title', sa.String(500), nullable=False),
        sa.Column('content', sa.Text(), nullable=True),
        sa.Column('summary', sa.Text(), nullable=True),
        sa.Column('source', sa.String(100), nullable=False),
        sa.Column('source_url', sa.String(1000), nullable=False),
        sa.Column('author', sa.String(200), nullable=True),
        sa.Column('category', sa.String(50), nullable=False),
        sa.Column('thumbnail_url', sa.String(1000), nullable=True),
        sa.Column('related_symbols', postgresql.ARRAY(sa.String()), nullable=True),
        sa.Column('published_at', sa.DateTime(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
        sa.Column('updated_at', sa.DateTime(), nullable=False, server_default=sa.text('NOW()')),
    )
    op.create_index('idx_news_category', 'news', ['category', 'published_at'])
    op.create_index('idx_news_published_at', 'news', ['published_at'])
    op.create_index('idx_news_source_url', 'news', ['source_url'], unique=True)


def downgrade() -> None:
    op.drop_table('news')
    op.drop_table('user_prediction_stats')
    op.drop_table('votes')
    op.drop_table('predictions')
    op.drop_table('comment_likes')
    op.drop_table('comments')
    op.drop_table('quotes')
    op.drop_table('symbols')
    op.drop_table('users')
