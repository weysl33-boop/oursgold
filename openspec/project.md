# Project Context

## Purpose

This is a **precious metals and forex market tracking app** with integrated social community features. The app provides real-time market data for gold, silver, and major currencies, combined with unique social interaction mechanisms including:

- Real-time price tracking for precious metals (gold, silver) and forex markets
- Price-anchored commenting system that records the price at the time of each comment
- ABCD-style price prediction voting system with accuracy tracking
- Community discussion features with prediction leaderboards
- Currency conversion calculator

**Key Differentiators:**
- Price-anchored comments: Every comment automatically records the market price at posting time
- Prediction voting system: Users can create and participate in price movement predictions with automatic verification
- Prediction accuracy tracking: System validates predictions and maintains user accuracy scores and rankings
- Pure community platform: No trading functionality, no investment advice - social interaction only

**Target Users:**
- Investment beginners (40%)
- Amateur investors (35%)
- Professional investors (15%)
- Financial industry professionals (10%)

## Tech Stack

### Mobile Frontend
- **Framework**: Flutter
- **Platform**: Cross-platform (iOS & Android)
- **UI Components**: Custom widgets with Material Design
- **Charts**: TradingView lightweight charts integration
- **State Management**: [To be determined - e.g., Provider, Riverpod, Bloc]

### Backend
- **Framework**: Python FastAPI
- **API Style**: RESTful + WebSocket for real-time data
- **Authentication**: JWT-based authentication
- **Async Processing**: Python asyncio for high-performance async operations

### Database & Caching
- **Primary Database**: PostgreSQL
  - User data, comments, predictions, voting records
  - Relational data with ACID compliance
- **Cache & Real-time Data**: Redis
  - Real-time price data caching
  - Session management
  - Rate limiting

### Real-time Communication
- **Protocol**: WebSocket
- **Use Cases**:
  - Live price updates (≤5 second intervals)
  - Real-time comment notifications
  - Prediction result notifications

### External Services
- Real-time market data API (to be selected)
- News feed API (optional)
- Content moderation API for comment filtering

## Project Conventions

### Code Style

**Python (Backend)**
- Follow PEP 8 style guide
- Use type hints for all function signatures
- Maximum line length: 100 characters
- Use Black for code formatting
- Use isort for import sorting
- Naming conventions:
  - snake_case for functions, variables, and module names
  - PascalCase for class names
  - UPPER_CASE for constants

**Dart/Flutter (Mobile)**
- Follow official Dart style guide
- Use effective Dart conventions
- Maximum line length: 80 characters
- Naming conventions:
  - lowerCamelCase for variables, functions, parameters
  - UpperCamelCase for classes, enums, typedefs
  - lowercase_with_underscores for library names

**General**
- Write self-documenting code with clear variable names
- Add comments for complex business logic
- Use meaningful commit messages following conventional commits format

### Architecture Patterns

**Backend Architecture**
- Clean Architecture / Layered Architecture:
  - API Layer (FastAPI routes)
  - Service Layer (business logic)
  - Repository Layer (data access)
  - Model Layer (data models)
- Dependency Injection for loose coupling
- Repository pattern for database operations
- Service pattern for business logic encapsulation

**Mobile Architecture**
- Feature-based folder structure
- Separation of concerns:
  - Presentation layer (UI widgets)
  - Business logic layer (state management)
  - Data layer (API clients, local storage)
- Repository pattern for data sources
- Use cases / interactors for business logic

**API Design**
- RESTful principles for CRUD operations
- WebSocket for real-time bidirectional communication
- Versioned APIs (e.g., /api/v1/)
- Consistent error response format
- Pagination for list endpoints

### Testing Strategy

**Backend Testing**
- Unit tests for service layer and business logic (pytest)
- Integration tests for API endpoints
- Database tests with test fixtures
- Minimum 70% code coverage target
- Mock external API dependencies

**Mobile Testing**
- Widget tests for UI components
- Unit tests for business logic
- Integration tests for critical user flows
- Golden tests for visual regression

**Testing Principles**
- Write tests before or alongside feature implementation
- Test behavior, not implementation details
- Use descriptive test names that explain the scenario
- Maintain fast test execution times

### Git Workflow

**Branching Strategy**
- `main` - production-ready code
- `develop` - integration branch for features
- `feature/*` - new features (e.g., feature/price-prediction-voting)
- `bugfix/*` - bug fixes
- `hotfix/*` - urgent production fixes

**Commit Conventions**
- Follow Conventional Commits specification
- Format: `<type>(<scope>): <description>`
- Types: feat, fix, docs, style, refactor, test, chore
- Examples:
  - `feat(prediction): add ABCD voting system`
  - `fix(comments): correct price anchoring timestamp`
  - `docs(api): update WebSocket event documentation`

**Pull Request Process**
- Create PR from feature branch to develop
- Require code review before merging
- Run automated tests in CI/CD pipeline
- Squash commits when merging to keep history clean

## Domain Context

### Financial Markets Knowledge

**Precious Metals Markets**
- **Shanghai Gold Exchange (SGE)**: Au99.99, Au99.95, Au100g, Au(T+D), mAu(T+D), SHAU
- **London Bullion Market (LBMA)**: XAU/USD (spot gold), XAG/USD (spot silver), XPT, XPD
- **COMEX**: GC (gold futures), SI (silver futures)
- Prices quoted in USD per troy ounce or CNY per gram
- Trading hours vary by market (24/5 for spot markets)

**Forex Markets**
- Major currency pairs: EUR/USD, GBP/USD, USD/JPY, USD/CNY, AUD/USD, USD/CAD, USD/CHF
- Base currency vs quote currency convention
- Pip movements and decimal precision vary by pair
- 24/5 trading (Sunday evening to Friday evening)

**Market Data Requirements**
- Real-time price updates (≤5 second latency)
- OHLCV data (Open, High, Low, Close, Volume)
- Historical data for charting (1D, 5D, 1M, 6M, 1Y, All)
- Market status indicators (trading/closed)

### Social Features Domain

**Price-Anchored Comments**
- Every comment captures the exact market price at posting time
- Provides context for understanding user sentiment in relation to price levels
- Historical comments show how opinions evolved with price changes

**Prediction Voting System**
- ABCD multiple-choice format for predictions
- Time-bound predictions with automatic verification
- System records price at prediction creation and verification time
- Accuracy calculated based on actual price movement vs predicted outcome
- Gamification through accuracy scores, streaks, and leaderboards

**User Engagement Metrics**
- Prediction accuracy rate (correct predictions / total predictions)
- Prediction streak (consecutive correct predictions)
- Participation count (total predictions participated in)
- Community ranking based on accuracy and activity

## Important Constraints

### Regulatory & Legal
- **No Trading Functionality**: This is a pure community/information platform
- **No Investment Advice**: All predictions and comments are user-generated opinions only
- **Disclaimer Requirements**: Clear disclaimers that content is not financial advice
- **Content Moderation**: Required to prevent market manipulation claims or illegal advice
- **Data Privacy**: Comply with GDPR/local privacy regulations for user data

### Technical Constraints
- **Real-time Performance**: Price updates must be ≤5 seconds latency
- **Scalability**: Design for growth from MVP to thousands of concurrent users
- **Mobile-First**: Primary platform is mobile (iOS/Android)
- **Offline Capability**: Consider offline mode for viewing cached data
- **API Rate Limits**: Respect rate limits from external market data providers

### Business Constraints
- **MVP Scope**: Focus on core features first (see PRD section 1.3)
- **No Paid Features**: Initial version is free; monetization deferred to future versions
- **Content Quality**: Maintain high-quality community discussions
- **User Retention**: Prediction system designed to increase daily active users

### Data Constraints
- **Price Accuracy**: Market data must be accurate and reliable
- **Data Retention**: Historical price data for charting (minimum 1 year)
- **Comment History**: Preserve price-anchored comments indefinitely for context
- **Prediction Records**: Maintain complete prediction history for accuracy calculations

## External Dependencies

### Critical Dependencies

**Market Data Provider** (To be selected)
- Real-time price feeds for precious metals and forex
- Historical OHLCV data
- WebSocket or REST API support
- Candidates: Alpha Vantage, Twelve Data, Polygon.io, or specialized commodity data providers

**Authentication & User Management**
- JWT token-based authentication
- OAuth 2.0 for social login (optional: Google, Apple)
- Email verification service

**Content Moderation**
- Automated content filtering API
- Profanity detection
- Spam prevention

### Optional Dependencies

**News Feed API**
- Financial news aggregation
- Market analysis articles
- Candidates: NewsAPI, Finnhub, Alpha Vantage News

**Push Notifications**
- Firebase Cloud Messaging (FCM) for mobile notifications
- Price alerts
- Prediction result notifications
- Comment reply notifications

**Analytics & Monitoring**
- Application performance monitoring (APM)
- User analytics and behavior tracking
- Error tracking and logging
- Candidates: Sentry, DataDog, Google Analytics

**CDN & Storage**
- User avatar storage
- News article images
- Chart image caching
- Candidates: AWS S3, Cloudflare, Google Cloud Storage

### Development Tools
- **Version Control**: Git / GitHub
- **CI/CD**: GitHub Actions or GitLab CI
- **API Documentation**: OpenAPI/Swagger for FastAPI
- **Database Migrations**: Alembic (Python)
- **Code Quality**: Black, isort, pylint (Python); dartfmt, dart analyze (Flutter)
