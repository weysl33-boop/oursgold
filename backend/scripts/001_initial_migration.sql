-- Initial migration: Create all tables
-- Revision: 001

-- Create alembic_version table first
CREATE TABLE IF NOT EXISTS alembic_version (
    version_num VARCHAR(32) NOT NULL,
    CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);

-- Create users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);

-- Create symbols table
CREATE TABLE symbols (
    code VARCHAR(20) PRIMARY KEY,
    name_cn VARCHAR(100) NOT NULL,
    name_en VARCHAR(100) NOT NULL,
    market VARCHAR(20) NOT NULL,
    symbol_type VARCHAR(20) NOT NULL,
    base_currency VARCHAR(10),
    quote_currency VARCHAR(10),
    decimal_places INTEGER DEFAULT 2 NOT NULL,
    unit VARCHAR(20),
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE INDEX idx_symbols_market ON symbols(market);
CREATE INDEX idx_symbols_type ON symbols(symbol_type);

-- Create quotes table
CREATE TABLE quotes (
    id BIGSERIAL PRIMARY KEY,
    symbol_code VARCHAR(20) REFERENCES symbols(code) ON DELETE CASCADE NOT NULL,
    price DECIMAL(20, 8) NOT NULL,
    change DECIMAL(20, 8),
    change_percent DECIMAL(10, 4),
    high DECIMAL(20, 8),
    low DECIMAL(20, 8),
    open DECIMAL(20, 8),
    prev_close DECIMAL(20, 8),
    volume BIGINT,
    timestamp TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE INDEX idx_quotes_symbol_timestamp ON quotes(symbol_code, timestamp);
CREATE INDEX idx_quotes_timestamp ON quotes(timestamp);

-- Create comments table
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    symbol_code VARCHAR(20) REFERENCES symbols(code) ON DELETE CASCADE NOT NULL,
    content TEXT NOT NULL,
    price_at_comment DECIMAL(20, 8) NOT NULL,
    parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    likes_count INTEGER DEFAULT 0 NOT NULL,
    replies_count INTEGER DEFAULT 0 NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
    is_deleted BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE INDEX idx_comments_symbol ON comments(symbol_code, created_at);
CREATE INDEX idx_comments_user ON comments(user_id, created_at);
CREATE INDEX idx_comments_parent ON comments(parent_id);

-- Create comment_likes table
CREATE TABLE comment_likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    comment_id UUID REFERENCES comments(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    UNIQUE(comment_id, user_id)
);

CREATE INDEX idx_comment_likes_comment ON comment_likes(comment_id);
CREATE INDEX idx_comment_likes_user ON comment_likes(user_id);

-- Create predictions table
CREATE TABLE predictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    symbol_code VARCHAR(20) REFERENCES symbols(code) ON DELETE CASCADE NOT NULL,
    question TEXT NOT NULL,
    options JSONB NOT NULL,
    price_at_create DECIMAL(20, 8) NOT NULL,
    price_at_verify DECIMAL(20, 8),
    verify_time TIMESTAMP NOT NULL,
    correct_option VARCHAR(1),
    verify_rule VARCHAR(20) DEFAULT 'auto' NOT NULL,
    auto_verify_conditions JSONB,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    participants_count INTEGER DEFAULT 0 NOT NULL,
    comments_count INTEGER DEFAULT 0 NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE INDEX idx_predictions_symbol ON predictions(symbol_code, created_at);
CREATE INDEX idx_predictions_user ON predictions(user_id, created_at);
CREATE INDEX idx_predictions_status ON predictions(status, verify_time);

-- Create votes table
CREATE TABLE votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    prediction_id UUID REFERENCES predictions(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    selected_option VARCHAR(1) NOT NULL,
    price_at_vote DECIMAL(20, 8) NOT NULL,
    is_correct BOOLEAN,
    voted_at TIMESTAMP DEFAULT NOW() NOT NULL,
    UNIQUE(prediction_id, user_id)
);

CREATE INDEX idx_votes_prediction ON votes(prediction_id);
CREATE INDEX idx_votes_user ON votes(user_id, voted_at);

-- Create user_prediction_stats table
CREATE TABLE user_prediction_stats (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    total_predictions INTEGER DEFAULT 0 NOT NULL,
    total_participations INTEGER DEFAULT 0 NOT NULL,
    correct_count INTEGER DEFAULT 0 NOT NULL,
    accuracy_rate DECIMAL(5, 2) DEFAULT 0.00 NOT NULL,
    current_streak INTEGER DEFAULT 0 NOT NULL,
    max_streak INTEGER DEFAULT 0 NOT NULL,
    prediction_score INTEGER DEFAULT 0 NOT NULL,
    rank_title VARCHAR(50) DEFAULT '预测新手' NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE INDEX idx_user_stats_accuracy ON user_prediction_stats(accuracy_rate DESC);
CREATE INDEX idx_user_stats_score ON user_prediction_stats(prediction_score DESC);

-- Create news table
CREATE TABLE news (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(500) NOT NULL,
    content TEXT,
    summary TEXT,
    source VARCHAR(100) NOT NULL,
    source_url VARCHAR(1000) NOT NULL,
    author VARCHAR(200),
    category VARCHAR(50) NOT NULL,
    thumbnail_url VARCHAR(1000),
    related_symbols TEXT[],
    published_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE INDEX idx_news_category ON news(category, published_at);
CREATE INDEX idx_news_published_at ON news(published_at);
CREATE UNIQUE INDEX idx_news_source_url ON news(source_url);

-- Insert migration version
INSERT INTO alembic_version (version_num) VALUES ('001');
