# Add Precious Metals & Forex Social Platform MVP

## Why

The market lacks a mobile-first precious metals and forex tracking app that combines real-time market data with meaningful social interaction. Existing financial apps are either too complex for beginners or lack community features that help users understand market sentiment in context.

This change implements a complete MVP addressing three key user needs:
1. **Contextual market information**: Users need to see not just prices, but understand what others think at specific price points
2. **Predictive engagement**: Users want to test their market intuition and learn from others' predictions
3. **Accessible entry point**: Investment beginners need a simple, non-trading platform to learn and engage

The unique value proposition is the **price-anchored interaction system** - every comment and prediction automatically captures the market price at that moment, providing historical context that traditional social platforms lack.

**Target Users**: Investment beginners (40%), amateur investors (35%), professional investors (15%), financial industry professionals (10%)

## What Changes

This change introduces a complete precious metals and forex social platform with 8 core capabilities across 4 implementation phases.

### New Capabilities

1. **market-data** - Real-time price feeds for precious metals and forex with caching
2. **user-auth** - JWT-based authentication and profile management
3. **price-comments** - Comment system with automatic price anchoring
4. **price-predictions** - ABCD prediction voting with automatic verification and accuracy tracking
5. **community** - Discussion aggregation, hot topics, and prediction leaderboards
6. **realtime-updates** - WebSocket streaming for live prices and notifications
7. **mobile-app** - Flutter cross-platform mobile application
8. **news** - Financial news aggregation and display (NEW)

### Core Features (Per PRD)

**Phase 1: Backend API + Database**
- Market data integration (SGE, LBMA, COMEX, Forex)
- User registration and JWT authentication
- PostgreSQL schema with all core tables
- Redis caching for price data
- RESTful API endpoints
- News aggregation and API
- Search API (symbols, topics, users)

**Phase 2: Mobile UI Foundation**
- Bottom tab navigation (5 tabs: Home, Quotes, FX, Community, Profile)
- Home page: 6 market overview cards with mini trend charts + news section
- Search functionality with real-time suggestions
- Quotes page: Categorized instrument lists (gold, silver, forex, crypto, indices)
- Forex page: Bidirectional currency calculator
- Detail page: TradingView K-line charts (6 time periods: 1D, 5D, 1M, 6M, 1Y, All)
- Profile page: User settings and preferences

**Phase 3: Social Features**
- Price-anchored commenting on any instrument
- ABCD prediction creation with custom questions and options
- Prediction voting system
- Automatic prediction verification at deadline
- Prediction accuracy scoring and user rankings
- Community page: hot topics, trending instruments, top comments, prediction leaderboards
- Comment threading and replies (X/Twitter style)

**Phase 4: Real-time Features**
- WebSocket connection for live price updates (≤5s latency)
- Real-time comment notifications
- Automatic prediction deadline triggers
- Push notifications for prediction results
- Live prediction vote count updates

### Technical Stack
- **Mobile**: Flutter (iOS/Android)
- **Backend**: Python FastAPI (async REST + WebSocket)
- **Database**: PostgreSQL 14+ (primary) + Redis 6+ (cache)
- **Charts**: TradingView lightweight charts
- **Real-time**: WebSocket protocol

## Impact

### Affected Specs
New specifications (greenfield):
- `specs/market-data/spec.md` - Market data ingestion and delivery
- `specs/user-auth/spec.md` - Authentication and user management
- `specs/price-comments/spec.md` - Price-anchored commenting
- `specs/price-predictions/spec.md` - Prediction voting and verification
- `specs/community/spec.md` - Community features and rankings
- `specs/realtime-updates/spec.md` - WebSocket and notifications
- `specs/mobile-app/spec.md` - Flutter mobile application (includes search)
- `specs/news/spec.md` - News aggregation and display (NEW)

### Affected Code
New codebase structure:
```
backend/
  ├── app/
  │   ├── api/v1/          # FastAPI routes
  │   ├── services/        # Business logic
  │   ├── repositories/    # Data access layer
  │   ├── models/          # SQLAlchemy ORM models
  │   ├── schemas/         # Pydantic request/response schemas
  │   └── websocket/       # WebSocket handlers
  ├── alembic/             # Database migrations
  └── tests/               # pytest test suite

mobile/
  ├── lib/
  │   ├── features/        # Feature modules (home, quotes, fx, community, profile)
  │   ├── core/            # Shared utilities, constants
  │   ├── data/            # Repositories, API clients
  │   └── widgets/         # Reusable UI components
  └── test/                # Widget and unit tests
```

### External Dependencies
**Critical:**
- Market data API provider (Alpha Vantage, Twelve Data, or Polygon.io)
- Content moderation API (for comment filtering)

**Infrastructure:**
- PostgreSQL 14+
- Redis 6+
- Docker for containerization
- CI/CD pipeline (GitHub Actions)

### Risks & Mitigations
1. **Market data API costs**: Implement aggressive Redis caching and rate limiting
2. **Real-time scalability**: Start with simple WebSocket, plan for Redis Pub/Sub if needed
3. **Content moderation**: Basic profanity filter initially, professional API before public launch
4. **Regulatory compliance**: Clear disclaimers - no investment advice, no trading functionality

### Breaking Changes
None - greenfield project.

## Success Criteria

### Phase 1 Complete
- [ ] Market data API integration with ≤5s latency
- [ ] User registration and JWT auth functional
- [ ] PostgreSQL schema deployed
- [ ] Redis caching operational
- [ ] OpenAPI documentation complete

### Phase 2 Complete
- [ ] All 5 tabs navigable
- [ ] Home page shows 6 live market cards + news section
- [ ] Search functionality with real-time suggestions works
- [ ] Quotes page displays categorized instruments
- [ ] Forex calculator works bidirectionally
- [ ] Detail page renders TradingView charts

### Phase 3 Complete
- [ ] Price-anchored comments functional
- [ ] ABCD predictions can be created and voted on
- [ ] Automatic prediction verification works
- [ ] Community page shows all rankings
- [ ] Prediction accuracy scores calculate correctly

### Phase 4 Complete
- [ ] WebSocket delivers real-time price updates
- [ ] Prediction deadlines trigger automatically
- [ ] Notifications delivered for prediction results
- [ ] All real-time features working end-to-end

### Overall MVP Success
- [ ] All 8 capabilities functional
- [ ] iOS and Android builds successful
- [ ] 70% backend test coverage
- [ ] API p95 response time <200ms
- [ ] Zero critical security vulnerabilities

