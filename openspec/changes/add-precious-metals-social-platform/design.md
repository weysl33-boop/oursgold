# Technical Design Document

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Mobile App (Flutter)                     │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐      │
│  │  Home    │  Quotes  │   FX     │Community │ Profile  │      │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘      │
│                           │                                      │
│                           │ HTTP/REST + WebSocket                │
└───────────────────────────┼──────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    API Gateway / Load Balancer                   │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                   FastAPI Backend (Python)                       │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  REST API Endpoints (/api/v1/*)                          │  │
│  │  - Auth, Users, Quotes, Comments, Predictions, Community │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  WebSocket Handler (/ws)                                 │  │
│  │  - Real-time price streaming                             │  │
│  │  - Live comment/prediction updates                       │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Background Jobs                                         │  │
│  │  - Price fetching (every 5s)                             │  │
│  │  - Prediction verification (every 1min)                  │  │
│  └──────────────────────────────────────────────────────────┘  │
└───────────┬─────────────────────────┬───────────────────────────┘
            │                         │
            ▼                         ▼
┌───────────────────────┐   ┌───────────────────────┐
│   PostgreSQL 14+      │   │      Redis 6+         │
│                       │   │                       │
│  - Users              │   │  - Price cache (5s)   │
│  - Symbols            │   │  - Session store      │
│  - Quotes (history)   │   │  - Rate limiting      │
│  - Comments           │   │  - Leaderboard cache  │
│  - Predictions        │   │  - WebSocket Pub/Sub  │
│  - Votes              │   │                       │
│  - User stats         │   │                       │
└───────────────────────┘   └───────────────────────┘
            │
            ▼
┌───────────────────────────────────────────────────┐
│         External Market Data API                  │
│  (Twelve Data / Alpha Vantage / Polygon.io)       │
└───────────────────────────────────────────────────┘
```

### Component Responsibilities

#### Mobile App (Flutter)
- **Presentation Layer**: UI widgets, screens, navigation
- **Business Logic Layer**: State management (Riverpod), view models
- **Data Layer**: API clients, repositories, local storage
- **Responsibilities**:
  - Render UI based on state
  - Handle user interactions
  - Manage WebSocket connections
  - Cache data locally for offline viewing
  - Display real-time updates

#### Backend API (FastAPI)
- **API Layer**: REST endpoints, request validation, response formatting
- **Service Layer**: Business logic, orchestration
- **Repository Layer**: Database queries, data access
- **WebSocket Layer**: Real-time communication
- **Responsibilities**:
  - Authenticate and authorize users
  - Fetch and cache market data
  - Store and retrieve comments/predictions
  - Calculate prediction accuracy
  - Broadcast real-time updates
  - Schedule background jobs

#### PostgreSQL
- **Primary data store** for all persistent data
- **Responsibilities**:
  - Store user accounts and profiles
  - Store comments with price anchors
  - Store predictions and votes
  - Store historical quotes (for charting)
  - Maintain referential integrity
  - Support complex queries (leaderboards, aggregations)

#### Redis
- **Cache and real-time data store**
- **Responsibilities**:
  - Cache latest quotes (5s TTL)
  - Store user sessions (JWT blacklist if needed)
  - Rate limiting counters
  - Cache leaderboard queries (5min TTL)
  - Pub/Sub for WebSocket message broadcasting

---

## Data Models

### Database Schema (PostgreSQL)

#### Users Table
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
```

#### Symbols Table
```sql
CREATE TABLE symbols (
    code VARCHAR(20) PRIMARY KEY,  -- e.g., "XAUUSD", "EURUSD"
    name_cn VARCHAR(100) NOT NULL,  -- e.g., "伦敦金"
    name_en VARCHAR(100) NOT NULL,  -- e.g., "Spot Gold"
    market VARCHAR(20) NOT NULL,    -- SGE, LBMA, COMEX, FOREX
    symbol_type VARCHAR(20) NOT NULL, -- gold, silver, currency
    base_currency VARCHAR(10),
    quote_currency VARCHAR(10),
    decimal_places INT DEFAULT 2,
    unit VARCHAR(20),               -- "盎司", "克"
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_symbols_market ON symbols(market);
CREATE INDEX idx_symbols_type ON symbols(symbol_type);
```

#### Quotes Table (Historical)
```sql
CREATE TABLE quotes (
    id BIGSERIAL PRIMARY KEY,
    symbol_code VARCHAR(20) REFERENCES symbols(code),
    price DECIMAL(20, 8) NOT NULL,
    change DECIMAL(20, 8),
    change_percent DECIMAL(10, 4),
    high DECIMAL(20, 8),
    low DECIMAL(20, 8),
    open DECIMAL(20, 8),
    prev_close DECIMAL(20, 8),
    volume BIGINT,
    timestamp TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_quotes_symbol_timestamp ON quotes(symbol_code, timestamp DESC);
CREATE INDEX idx_quotes_timestamp ON quotes(timestamp DESC);
```

#### Comments Table
```sql
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    symbol_code VARCHAR(20) REFERENCES symbols(code),
    content TEXT NOT NULL,
    price_at_comment DECIMAL(20, 8) NOT NULL,  -- Key feature!
    parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,  -- For replies
    likes_count INT DEFAULT 0,
    replies_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_comments_symbol ON comments(symbol_code, created_at DESC);
CREATE INDEX idx_comments_user ON comments(user_id, created_at DESC);
CREATE INDEX idx_comments_parent ON comments(parent_id);
```

#### Comment Likes Table
```sql
CREATE TABLE comment_likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(comment_id, user_id)
);

CREATE INDEX idx_comment_likes_comment ON comment_likes(comment_id);
CREATE INDEX idx_comment_likes_user ON comment_likes(user_id);
```

#### Predictions Table
```sql
CREATE TABLE predictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    symbol_code VARCHAR(20) REFERENCES symbols(code),
    question TEXT NOT NULL,
    options JSONB NOT NULL,  -- [{"key": "A", "text": "涨超1%"}, ...]
    price_at_create DECIMAL(20, 8) NOT NULL,  -- Key feature!
    price_at_verify DECIMAL(20, 8),           -- Filled at verification
    verify_time TIMESTAMP NOT NULL,
    correct_option VARCHAR(1),  -- A, B, C, or D
    verify_rule VARCHAR(20) DEFAULT 'auto',  -- auto or manual
    auto_verify_conditions JSONB,  -- Rules for auto verification
    status VARCHAR(20) DEFAULT 'active',  -- active, ended, cancelled
    participants_count INT DEFAULT 0,
    comments_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_predictions_symbol ON predictions(symbol_code, created_at DESC);
CREATE INDEX idx_predictions_user ON predictions(user_id, created_at DESC);
CREATE INDEX idx_predictions_status ON predictions(status, verify_time);
```

#### Votes Table
```sql
CREATE TABLE votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    prediction_id UUID REFERENCES predictions(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    selected_option VARCHAR(1) NOT NULL,  -- A, B, C, or D
    price_at_vote DECIMAL(20, 8) NOT NULL,
    is_correct BOOLEAN,  -- Filled after verification
    voted_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(prediction_id, user_id)
);

CREATE INDEX idx_votes_prediction ON votes(prediction_id);
CREATE INDEX idx_votes_user ON votes(user_id, voted_at DESC);
```

#### User Prediction Stats Table
```sql
CREATE TABLE user_prediction_stats (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    total_predictions INT DEFAULT 0,      -- Predictions created
    total_participations INT DEFAULT 0,   -- Predictions voted on
    correct_count INT DEFAULT 0,
    accuracy_rate DECIMAL(5, 2) DEFAULT 0.00,  -- Percentage
    current_streak INT DEFAULT 0,
    max_streak INT DEFAULT 0,
    prediction_score INT DEFAULT 0,       -- Gamification points
    rank_title VARCHAR(50) DEFAULT '预测新手',
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_user_stats_accuracy ON user_prediction_stats(accuracy_rate DESC);
CREATE INDEX idx_user_stats_score ON user_prediction_stats(prediction_score DESC);
```

### Redis Data Structures

#### Latest Quotes Cache
```
Key: quote:{symbol_code}
Type: Hash
TTL: 5 seconds
Fields:
  - price
  - change
  - change_percent
  - high
  - low
  - volume
  - timestamp
```

#### User Sessions
```
Key: session:{user_id}
Type: String (JWT token)
TTL: 24 hours
```

#### Rate Limiting
```
Key: ratelimit:{endpoint}:{user_id}
Type: String (counter)
TTL: 60 seconds
```

#### Leaderboard Cache
```
Key: leaderboard:accuracy
Type: Sorted Set
Score: accuracy_rate
Members: user_id
TTL: 5 minutes
```

---

## API Design

### Authentication Endpoints

#### POST /api/v1/auth/register
**Request:**
```json
{
  "username": "goldtrader123",
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

**Response:**
```json
{
  "user": {
    "id": "uuid",
    "username": "goldtrader123",
    "email": "user@example.com",
    "created_at": "2025-12-27T10:00:00Z"
  },
  "access_token": "eyJhbGc...",
  "token_type": "bearer"
}
```

#### POST /api/v1/auth/login
**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGc...",
  "token_type": "bearer",
  "expires_in": 86400
}
```

### Market Data Endpoints

#### GET /api/v1/quotes/{symbol}
**Response:**
```json
{
  "symbol_code": "XAUUSD",
  "name_cn": "伦敦金",
  "name_en": "Spot Gold",
  "price": 2658.50,
  "change": 28.30,
  "change_percent": 1.08,
  "high": 2665.00,
  "low": 2640.00,
  "open": 2630.20,
  "prev_close": 2630.20,
  "volume": 125000,
  "timestamp": "2025-12-27T10:30:25Z",
  "market_status": "trading"
}
```

#### GET /api/v1/quotes?symbols=XAUUSD,XAGUSD,EURUSD
**Response:**
```json
{
  "quotes": [
    { "symbol_code": "XAUUSD", "price": 2658.50, ... },
    { "symbol_code": "XAGUSD", "price": 31.25, ... },
    { "symbol_code": "EURUSD", "price": 1.0832, ... }
  ],
  "timestamp": "2025-12-27T10:30:25Z"
}
```

#### GET /api/v1/quotes/{symbol}/history?period=1D
**Query Params:**
- `period`: 1D, 5D, 1M, 6M, 1Y, ALL
- `interval`: 1min, 5min, 1hour, 1day (optional)

**Response:**
```json
{
  "symbol_code": "XAUUSD",
  "period": "1D",
  "interval": "5min",
  "data": [
    {
      "timestamp": "2025-12-27T09:00:00Z",
      "open": 2630.00,
      "high": 2635.00,
      "low": 2628.00,
      "close": 2632.50,
      "volume": 5000
    },
    ...
  ]
}
```

### Comment Endpoints

#### POST /api/v1/comments
**Request:**
```json
{
  "symbol_code": "XAUUSD",
  "content": "感觉要突破2660了，准备加仓！",
  "parent_id": null  // null for top-level, UUID for reply
}
```

**Response:**
```json
{
  "id": "uuid",
  "user": {
    "id": "uuid",
    "username": "goldtrader123",
    "avatar_url": "https://..."
  },
  "symbol_code": "XAUUSD",
  "content": "感觉要突破2660了，准备加仓！",
  "price_at_comment": 2658.50,  // Auto-captured!
  "parent_id": null,
  "likes_count": 0,
  "replies_count": 0,
  "created_at": "2025-12-27T10:30:25Z"
}
```

#### GET /api/v1/comments?symbol=XAUUSD&page=1&limit=20
**Response:**
```json
{
  "comments": [
    {
      "id": "uuid",
      "user": { "id": "uuid", "username": "user1", ... },
      "content": "...",
      "price_at_comment": 2658.50,
      "likes_count": 128,
      "replies_count": 23,
      "created_at": "2025-12-27T08:30:00Z",
      "replies": [
        {
          "id": "uuid",
          "user": { "id": "uuid", "username": "user2", ... },
          "content": "我也这么觉得",
          "price_at_comment": 2660.00,
          "created_at": "2025-12-27T08:35:00Z"
        }
      ]
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 156,
    "has_more": true
  }
}
```

#### POST /api/v1/comments/{id}/like
**Response:**
```json
{
  "comment_id": "uuid",
  "likes_count": 129,
  "user_liked": true
}
```

### Prediction Endpoints

#### POST /api/v1/predictions
**Request:**
```json
{
  "symbol_code": "XAUUSD",
  "question": "今晚8点前黄金价格走势如何？",
  "options": [
    { "key": "A", "text": "涨超1%" },
    { "key": "B", "text": "小幅上涨" },
    { "key": "C", "text": "横盘整理" },
    { "key": "D", "text": "下跌" }
  ],
  "verify_time": "2025-12-27T20:00:00Z",
  "verify_rule": "auto",
  "auto_verify_conditions": {
    "A": { "condition": "price_change_percent >= 1.0" },
    "B": { "condition": "price_change_percent > 0 AND price_change_percent < 1.0" },
    "C": { "condition": "price_change_percent >= -0.5 AND price_change_percent <= 0" },
    "D": { "condition": "price_change_percent < -0.5" }
  }
}
```

**Response:**
```json
{
  "id": "uuid",
  "user": { "id": "uuid", "username": "user1", ... },
  "symbol_code": "XAUUSD",
  "question": "今晚8点前黄金价格走势如何？",
  "options": [...],
  "price_at_create": 2650.30,  // Auto-captured!
  "verify_time": "2025-12-27T20:00:00Z",
  "status": "active",
  "participants_count": 0,
  "created_at": "2025-12-27T10:30:00Z"
}
```

#### POST /api/v1/predictions/{id}/vote
**Request:**
```json
{
  "selected_option": "A"
}
```

**Response:**
```json
{
  "prediction_id": "uuid",
  "user_vote": "A",
  "price_at_vote": 2655.80,  // Auto-captured!
  "vote_distribution": {
    "A": { "count": 89, "percentage": 35 },
    "B": { "count": 38, "percentage": 15 },
    "C": { "count": 76, "percentage": 30 },
    "D": { "count": 51, "percentage": 20 }
  },
  "participants_count": 254
}
```

#### GET /api/v1/predictions?status=active&page=1&limit=20
**Response:**
```json
{
  "predictions": [
    {
      "id": "uuid",
      "user": { ... },
      "question": "...",
      "options": [...],
      "price_at_create": 2650.30,
      "verify_time": "2025-12-27T20:00:00Z",
      "status": "active",
      "participants_count": 254,
      "user_voted": true,
      "user_vote": "A",
      "vote_distribution": { ... },
      "time_remaining": 34520  // seconds
    }
  ],
  "pagination": { ... }
}
```

### Community Endpoints

#### GET /api/v1/community/topics
**Response:**
```json
{
  "topics": [
    {
      "hashtag": "#黄金突破2660#",
      "discussion_count": 2300,
      "heat_score": 98,
      "trending_rank": 1
    },
    ...
  ]
}
```

#### GET /api/v1/leaderboard?type=accuracy&limit=50
**Query Params:**
- `type`: accuracy, score, streak, active

**Response:**
```json
{
  "leaderboard": [
    {
      "rank": 1,
      "user": {
        "id": "uuid",
        "username": "预测大师A",
        "avatar_url": "..."
      },
      "accuracy_rate": 82.5,
      "total_participations": 256,
      "current_streak": 12,
      "rank_title": "预测宗师",
      "recent_prediction": {
        "question": "黄金突破2650？",
        "result": "correct"
      }
    },
    ...
  ]
}
```

---

## WebSocket Protocol

### Connection
```
ws://api.example.com/api/v1/ws?token=<jwt_token>
```

### Message Format
All messages are JSON with `type` and `payload` fields.

#### Client → Server Messages

**Subscribe to Symbol**
```json
{
  "type": "subscribe",
  "payload": {
    "symbols": ["XAUUSD", "XAGUSD", "EURUSD"]
  }
}
```

**Unsubscribe from Symbol**
```json
{
  "type": "unsubscribe",
  "payload": {
    "symbols": ["EURUSD"]
  }
}
```

**Ping (Heartbeat)**
```json
{
  "type": "ping"
}
```

#### Server → Client Messages

**Price Update**
```json
{
  "type": "price_update",
  "payload": {
    "symbol_code": "XAUUSD",
    "price": 2658.50,
    "change": 28.30,
    "change_percent": 1.08,
    "timestamp": "2025-12-27T10:30:25Z"
  }
}
```

**New Comment**
```json
{
  "type": "new_comment",
  "payload": {
    "symbol_code": "XAUUSD",
    "comment": { ... }  // Full comment object
  }
}
```

**Prediction Verified**
```json
{
  "type": "prediction_verified",
  "payload": {
    "prediction_id": "uuid",
    "correct_option": "B",
    "price_at_verify": 2662.50,
    "user_result": "correct"  // or "incorrect"
  }
}
```

**Pong (Heartbeat Response)**
```json
{
  "type": "pong"
}
```

---

## Background Jobs

### Price Fetching Job
- **Frequency**: Every 5 seconds
- **Logic**:
  1. Fetch latest prices from external API for all active symbols
  2. Store in Redis with 5s TTL
  3. Optionally store in PostgreSQL for historical data
  4. Broadcast to all WebSocket clients subscribed to each symbol

### Prediction Verification Job
- **Frequency**: Every 1 minute
- **Logic**:
  1. Query predictions where `verify_time <= NOW()` and `status = 'active'`
  2. For each prediction:
     - Fetch current price
     - Calculate `price_change_percent = (current_price - price_at_create) / price_at_create * 100`
     - Determine correct option based on `auto_verify_conditions`
     - Update prediction: `price_at_verify`, `correct_option`, `status = 'ended'`
     - Update all votes: set `is_correct` based on `selected_option == correct_option`
     - Update user stats: increment `correct_count` if correct, update `accuracy_rate`, update `current_streak`
     - Broadcast verification result via WebSocket
     - Send push notification to all participants

---

## Security Considerations

### Authentication & Authorization
- **JWT Tokens**: HS256 algorithm, 24-hour expiration
- **Password Hashing**: bcrypt with salt rounds = 12
- **Token Storage**: Mobile app uses `flutter_secure_storage`
- **Protected Endpoints**: All write operations require authentication
- **Rate Limiting**: 100 requests/minute per user for write operations

### Input Validation
- **Pydantic Schemas**: Validate all request bodies
- **SQL Injection**: Use SQLAlchemy ORM (parameterized queries)
- **XSS Prevention**: Sanitize comment content before storage
- **Content Length**: Limit comment content to 2000 characters
- **Profanity Filter**: Basic word list filter, upgrade to API before launch

### Data Privacy
- **Password Storage**: Never store plaintext passwords
- **Email Privacy**: Don't expose emails in public APIs
- **User Data**: Allow users to export and delete their data (GDPR)
- **Logging**: Don't log sensitive data (passwords, tokens)

### API Security
- **HTTPS Only**: Enforce TLS 1.2+ in production
- **CORS**: Restrict to mobile app origins
- **Rate Limiting**: Redis-based rate limiting per endpoint
- **Request Size**: Limit request body to 1MB
- **WebSocket Auth**: Validate JWT on connection and periodically

---

## Performance Optimization

### Caching Strategy
- **Redis for Hot Data**: Latest quotes (5s TTL), leaderboards (5min TTL)
- **Database Indexes**: On frequently queried columns (symbol_code, user_id, timestamps)
- **Query Optimization**: Use `EXPLAIN ANALYZE` to optimize slow queries
- **Pagination**: Limit list endpoints to 20-50 items per page
- **Lazy Loading**: Mobile app loads images and lists on demand

### Scalability Considerations
- **Horizontal Scaling**: FastAPI is stateless, can run multiple instances behind load balancer
- **Database Connection Pooling**: Use SQLAlchemy connection pool (max 20 connections)
- **Redis Pub/Sub**: For WebSocket message broadcasting across multiple backend instances
- **CDN**: Serve static assets (images, charts) from CDN
- **Database Sharding**: If needed, shard by symbol_code or user_id

### Monitoring & Alerting
- **APM**: Use Sentry or DataDog for error tracking
- **Metrics**: Track API response times, WebSocket connection count, database query times
- **Alerts**: Set up alerts for error rate >1%, API p95 >500ms, WebSocket disconnections >10%
- **Logging**: Structured logging (JSON) with correlation IDs

---

## Deployment Architecture

### Development Environment
```
docker-compose.yml:
  - backend (FastAPI)
  - postgres (PostgreSQL 14)
  - redis (Redis 6)
  - nginx (reverse proxy)
```

### Production Environment (Recommended: DigitalOcean)
```
- App Platform: FastAPI backend (auto-scaling)
- Managed PostgreSQL: Primary database
- Managed Redis: Cache and Pub/Sub
- Spaces CDN: Static assets
- Load Balancer: HTTPS termination
- Monitoring: DigitalOcean Monitoring + Sentry
```

### CI/CD Pipeline (GitHub Actions)
```yaml
on: [push, pull_request]
jobs:
  test:
    - Run pytest with coverage
    - Run linting (Black, isort, pylint)
    - Run security scan (bandit)
  build:
    - Build Docker image
    - Push to container registry
  deploy:
    - Deploy to staging (on merge to develop)
    - Deploy to production (on merge to main, manual approval)
```

---

## Open Technical Questions

1. **Market Data Provider**: Final decision between Twelve Data (free tier) vs Polygon.io (paid)
   - **Recommendation**: Start with Twelve Data, evaluate Polygon.io if free tier insufficient

2. **State Management (Flutter)**: Riverpod vs Bloc vs Provider
   - **Recommendation**: Riverpod for better testability and compile-time safety

3. **WebSocket Scaling**: When to implement Redis Pub/Sub?
   - **Recommendation**: Start simple (single backend instance), add Pub/Sub when >100 concurrent users

4. **Content Moderation API**: Which service to use?
   - **Recommendation**: Start with basic profanity filter, integrate professional API (e.g., Perspective API) before public launch

5. **Push Notifications**: FCM only or also APNs directly?
   - **Recommendation**: Use FCM for both iOS and Android (simpler)

6. **Database Backups**: Frequency and retention?
   - **Recommendation**: Daily automated backups, 30-day retention, test restore monthly

7. **Internationalization**: Support multiple languages from start?
   - **Recommendation**: Build i18n structure from start (Chinese + English), add translations in Phase 2

