# Implementation Tasks

## Phase 1: Backend API + Database (Foundation)

### 1.1 Project Setup & Infrastructure
- [ ] 1.1.1 Initialize FastAPI project structure with Poetry/pip
- [ ] 1.1.2 Configure PostgreSQL database and create initial schema
- [ ] 1.1.3 Set up Redis for caching and session management
- [ ] 1.1.4 Configure Docker Compose for local development
- [ ] 1.1.5 Set up Alembic for database migrations
- [ ] 1.1.6 Configure pytest with fixtures and test database
- [ ] 1.1.7 Set up pre-commit hooks (Black, isort, pylint)
- [ ] 1.1.8 Create OpenAPI/Swagger documentation structure

**Validation**: `docker-compose up` starts all services, `pytest` runs successfully

### 1.2 Database Models & Schemas
- [ ] 1.2.1 Create User model (id, username, email, password_hash, created_at)
- [ ] 1.2.2 Create Symbol model (code, name_cn, name_en, market, type, decimal_places)
- [ ] 1.2.3 Create Quote model (symbol_code, price, change, high, low, volume, timestamp)
- [ ] 1.2.4 Create Comment model (user_id, symbol_code, content, price_at_comment, timestamp)
- [ ] 1.2.5 Create Prediction model (user_id, symbol_code, question, options, price_at_create, verify_time)
- [ ] 1.2.6 Create Vote model (prediction_id, user_id, selected_option, price_at_vote, is_correct)
- [ ] 1.2.7 Create UserPredictionStats model (user_id, accuracy_rate, total_predictions, streak)
- [ ] 1.2.8 Define Pydantic schemas for all models (request/response DTOs)
- [ ] 1.2.9 Run initial migration to create all tables

**Validation**: All tables created, relationships verified, sample data inserts work

### 1.3 User Authentication System
- [ ] 1.3.1 Implement password hashing (bcrypt)
- [ ] 1.3.2 Create user registration endpoint (POST /api/v1/auth/register)
- [ ] 1.3.3 Create login endpoint with JWT token generation (POST /api/v1/auth/login)
- [ ] 1.3.4 Implement JWT token validation middleware
- [ ] 1.3.5 Create token refresh endpoint (POST /api/v1/auth/refresh)
- [ ] 1.3.6 Create get current user endpoint (GET /api/v1/auth/me)
- [ ] 1.3.7 Create update profile endpoint (PUT /api/v1/users/me)
- [ ] 1.3.8 Write unit tests for auth service (registration, login, token validation)
- [ ] 1.3.9 Write integration tests for auth endpoints

**Validation**: User can register, login, receive JWT, access protected endpoints

### 1.4 Market Data Integration
- [ ] 1.4.1 Research and select market data provider (Twelve Data recommended)
- [ ] 1.4.2 Create market data client service with rate limiting
- [ ] 1.4.3 Implement symbol configuration seeding (default 6 instruments + SGE symbols)
- [ ] 1.4.4 Create background job to fetch prices every 5 seconds
- [ ] 1.4.5 Implement Redis caching for latest quotes (TTL: 5s)
- [ ] 1.4.6 Create endpoint to get current price (GET /api/v1/quotes/{symbol})
- [ ] 1.4.7 Create endpoint to get multiple quotes (GET /api/v1/quotes?symbols=...)
- [ ] 1.4.8 Create endpoint to get historical OHLCV data (GET /api/v1/quotes/{symbol}/history)
- [ ] 1.4.9 Implement error handling for API failures (fallback to cached data)
- [ ] 1.4.10 Write tests with mocked market data API

**Validation**: Prices update every 5s, cached in Redis, API returns correct data

### 1.5 News Aggregation (NEW)
- [ ] 1.5.1 Create news database table with all required fields
- [ ] 1.5.2 Implement news external source integration (RSS/API)
- [ ] 1.5.3 Create background job to fetch news every 15 minutes
- [ ] 1.5.4 Implement news deduplication logic
- [ ] 1.5.5 Create endpoint to get news list (GET /api/v1/news)
- [ ] 1.5.6 Create endpoint to get news detail (GET /api/v1/news/{id})
- [ ] 1.5.7 Implement Redis caching for news list (TTL: 5min)
- [ ] 1.5.8 Write tests for news service

**Validation**: News fetched periodically, cached, API returns correct data

### 1.6 Search API (NEW)
- [ ] 1.6.1 Create search endpoint (GET /api/v1/search)
- [ ] 1.6.2 Implement symbol search by name/code
- [ ] 1.6.3 Implement topic search by hashtag
- [ ] 1.6.4 Implement user search by username
- [ ] 1.6.5 Create search suggestions endpoint (GET /api/v1/search/suggestions)
- [ ] 1.6.6 Implement hot search keywords tracking
- [ ] 1.6.7 Write tests for search service

**Validation**: Search returns relevant results across symbols, topics, users

### 1.7 Core API Endpoints (Comments & Predictions)
- [ ] 1.7.1 Create post comment endpoint (POST /api/v1/comments) - captures current price
- [ ] 1.7.2 Create get comments endpoint (GET /api/v1/comments?symbol=...) with pagination
- [ ] 1.7.3 Create like comment endpoint (POST /api/v1/comments/{id}/like)
- [ ] 1.7.4 Create reply to comment endpoint (POST /api/v1/comments/{id}/replies)
- [ ] 1.7.5 Create prediction endpoint (POST /api/v1/predictions) - captures current price
- [ ] 1.7.6 Create vote on prediction endpoint (POST /api/v1/predictions/{id}/vote)
- [ ] 1.7.7 Create get predictions endpoint (GET /api/v1/predictions?status=active)
- [ ] 1.7.8 Create background job for prediction verification at deadline
- [ ] 1.7.9 Implement prediction accuracy calculation logic
- [ ] 1.7.10 Write tests for comment and prediction services

**Validation**: Comments save with price, predictions verify automatically, accuracy calculates

### 1.8 Community & Leaderboard APIs
- [ ] 1.8.1 Create hot topics endpoint (GET /api/v1/community/topics) - sorted by engagement
- [ ] 1.8.2 Create trending symbols endpoint (GET /api/v1/community/trending)
- [ ] 1.8.3 Create top comments endpoint (GET /api/v1/community/comments/top)
- [ ] 1.8.4 Create prediction leaderboard endpoint (GET /api/v1/leaderboard?type=accuracy)
- [ ] 1.8.5 Create user prediction stats endpoint (GET /api/v1/users/{id}/predictions/stats)
- [ ] 1.8.6 Implement caching for leaderboard queries (Redis, TTL: 5min)
- [ ] 1.8.7 Write tests for community aggregation logic

**Validation**: Leaderboards rank correctly, stats calculate accurately

### 1.9 Phase 1 Finalization
- [ ] 1.9.1 Achieve 70% test coverage on backend
- [ ] 1.9.2 Run security audit (bandit, safety)
- [ ] 1.9.3 Optimize database queries (add indexes where needed)
- [ ] 1.9.4 Document all API endpoints in Swagger
- [ ] 1.9.5 Create Postman collection for manual testing
- [ ] 1.9.6 Set up CI pipeline (GitHub Actions: lint, test, build)

**Validation**: All tests pass, API docs complete, CI green

---

## Phase 2: Mobile UI Foundation (Navigation & Basic Screens)

### 2.1 Flutter Project Setup
- [ ] 2.1.1 Initialize Flutter project with proper package structure
- [ ] 2.1.2 Configure build settings for iOS and Android
- [ ] 2.1.3 Set up dependency injection (get_it or riverpod)
- [ ] 2.1.4 Configure routing (go_router or auto_route)
- [ ] 2.1.5 Set up environment configuration (dev/staging/prod)
- [ ] 2.1.6 Configure linting (analysis_options.yaml)
- [ ] 2.1.7 Set up testing framework (flutter_test, mockito)
- [ ] 2.1.8 Create folder structure (features, core, data, widgets)

**Validation**: `flutter run` launches app, navigation works, tests run

### 2.2 Core Infrastructure (Mobile)
- [ ] 2.2.1 Create API client service with Dio/http
- [ ] 2.2.2 Implement JWT token storage (flutter_secure_storage)
- [ ] 2.2.3 Create authentication interceptor for API requests
- [ ] 2.2.4 Implement error handling and retry logic
- [ ] 2.2.5 Create repository pattern for data layer
- [ ] 2.2.6 Set up state management (Riverpod/Bloc/Provider)
- [ ] 2.2.7 Create theme configuration (light/dark mode)
- [ ] 2.2.8 Implement i18n structure (Chinese + English)

**Validation**: API calls work, auth persists, theme switches, translations load

### 2.3 Bottom Navigation & Shell
- [ ] 2.3.1 Create bottom navigation bar widget (5 tabs)
- [ ] 2.3.2 Implement tab icons (Remix Icons or similar)
- [ ] 2.3.3 Add selected/unselected state styling
- [ ] 2.3.4 Create shell scaffold with safe area handling
- [ ] 2.3.5 Implement tab persistence on navigation
- [ ] 2.3.6 Add haptic feedback on tab switch
- [ ] 2.3.7 Write widget tests for navigation bar

**Validation**: All 5 tabs navigate correctly, styling matches design

### 2.4 Home Page
- [ ] 2.4.1 Create home page scaffold with app bar
- [ ] 2.4.2 Implement search bar UI with navigation to search page
- [ ] 2.4.3 Create market card widget (2-column grid)
- [ ] 2.4.4 Implement mini trend chart widget (fl_chart or similar)
- [ ] 2.4.5 Fetch and display 6 default instruments
- [ ] 2.4.6 Show price, change percentage, and trend direction
- [ ] 2.4.7 Implement pull-to-refresh
- [ ] 2.4.8 Add loading and error states
- [ ] 2.4.9 Navigate to detail page on card tap
- [ ] 2.4.10 Create news section below market cards
- [ ] 2.4.11 Display 3-5 news items with title, category, time, thumbnail
- [ ] 2.4.12 Navigate to news detail/list on tap
- [ ] 2.4.13 Write widget tests for home page

**Validation**: Home page displays 6 cards + news section, prices load, navigation works

### 2.5 Search Page (NEW)
- [ ] 2.5.1 Create search page with search input
- [ ] 2.5.2 Implement real-time search suggestions (debounced)
- [ ] 2.5.3 Display recent search history
- [ ] 2.5.4 Display hot search keywords
- [ ] 2.5.5 Create search result tabs (全部, 市场, 话题, 用户)
- [ ] 2.5.6 Implement symbol search results
- [ ] 2.5.7 Implement topic search results
- [ ] 2.5.8 Implement user search results
- [ ] 2.5.9 Navigate to detail pages from results
- [ ] 2.5.10 Write widget tests for search

**Validation**: Search works with suggestions, results display correctly

### 2.6 Quotes Page
- [ ] 2.6.1 Create quotes page with category chips (自选, 黄金, 外汇, etc.)
- [ ] 2.6.2 Implement horizontal scrollable chip selector
- [ ] 2.6.3 Create quote list item widget with mini chart
- [ ] 2.6.4 Fetch and display categorized instruments
- [ ] 2.6.5 Show market badge (LBMA/COMEX/SGE)
- [ ] 2.6.6 Implement category filtering
- [ ] 2.6.7 Add pull-to-refresh
- [ ] 2.6.8 Navigate to detail page on item tap
- [ ] 2.6.9 Implement favorites/watchlist functionality
- [ ] 2.6.10 Write widget tests for quotes page

**Validation**: Categories filter correctly, all instruments display, favorites work

### 2.7 Forex Page
- [ ] 2.7.1 Create forex page with currency calculator card
- [ ] 2.7.2 Implement source currency selector with flags
- [ ] 2.7.3 Implement target currency selector with flags
- [ ] 2.7.4 Create swap button to reverse currencies
- [ ] 2.7.5 Implement amount input with real-time calculation
- [ ] 2.7.6 Display current exchange rate and update time
- [ ] 2.7.7 Create popular currency pairs list below calculator
- [ ] 2.7.8 Show mini charts for each pair
- [ ] 2.7.9 Navigate to detail page on pair tap
- [ ] 2.7.10 Write widget tests for calculator logic

**Validation**: Calculator converts correctly, swap works, pairs display

### 2.8 Detail Page (Charts Only)
- [ ] 2.8.1 Create detail page scaffold with symbol header
- [ ] 2.8.2 Display current price, change, and market status
- [ ] 2.8.3 Create 3x2 data grid (open, high, low, close, volume, avg volume)
- [ ] 2.8.4 Integrate TradingView chart widget (webview_flutter or native)
- [ ] 2.8.5 Implement time period selector (1D, 5D, 1M, 6M, 1Y, All)
- [ ] 2.8.6 Fetch and display historical OHLCV data
- [ ] 2.8.7 Add chart interaction (pinch zoom, pan)
- [ ] 2.8.8 Implement favorite/star button
- [ ] 2.8.9 Add loading and error states
- [ ] 2.8.10 Write widget tests for detail page

**Validation**: Charts render, time periods switch, data loads correctly

### 2.9 Community Page (Skeleton)
- [ ] 2.9.1 Create community page scaffold
- [ ] 2.9.2 Add section headers (Hot Topics, Trending Symbols, Top Comments)
- [ ] 2.9.3 Create placeholder cards for each section
- [ ] 2.9.4 Implement basic list layout
- [ ] 2.9.5 Add pull-to-refresh
- [ ] 2.9.6 Write widget tests

**Validation**: Page structure displays, sections visible

### 2.10 Profile Page (Skeleton)
- [ ] 2.10.1 Create profile page scaffold
- [ ] 2.10.2 Display user avatar and username
- [ ] 2.10.3 Create settings list (language, theme, notifications)
- [ ] 2.10.4 Add logout button
- [ ] 2.10.5 Implement theme toggle
- [ ] 2.10.6 Implement language toggle
- [ ] 2.10.7 Implement price color preference (红涨绿跌/绿涨红跌)
- [ ] 2.10.8 Write widget tests

**Validation**: Profile displays, settings work, preferences save, logout clears session

### 2.11 News Pages (NEW)
- [ ] 2.11.1 Create news list page with category filter tabs
- [ ] 2.11.2 Implement news list item widget (title, category, time, thumbnail)
- [ ] 2.11.3 Create news detail page with full content
- [ ] 2.11.4 Display related symbols on news detail
- [ ] 2.11.5 Implement pagination for news list
- [ ] 2.11.6 Write widget tests for news pages

**Validation**: News list loads, detail page displays, related symbols link correctly

### 2.12 Phase 2 Finalization
- [ ] 2.12.1 Ensure all pages accessible via bottom nav
- [ ] 2.12.2 Test navigation flow end-to-end
- [ ] 2.12.3 Verify responsive layout on different screen sizes
- [ ] 2.12.4 Test on iOS and Android devices/simulators
- [ ] 2.12.5 Fix any UI/UX issues
- [ ] 2.12.6 Achieve 60% widget test coverage

**Validation**: App navigates smoothly, UI matches design, tests pass

---

## Phase 3: Social Features (Comments & Predictions)

### 3.1 Authentication Flow (Mobile)
- [ ] 3.1.1 Create login screen UI
- [ ] 3.1.2 Create registration screen UI
- [ ] 3.1.3 Implement login form validation
- [ ] 3.1.4 Implement registration form validation
- [ ] 3.1.5 Connect to backend auth endpoints
- [ ] 3.1.6 Store JWT token securely
- [ ] 3.1.7 Implement auto-login on app launch
- [ ] 3.1.8 Handle token expiration and refresh
- [ ] 3.1.9 Add loading and error states
- [ ] 3.1.10 Write integration tests for auth flow

**Validation**: Users can register, login, stay logged in, handle errors

### 3.2 Price-Anchored Comments (Mobile)
- [ ] 3.2.1 Add comment section to detail page
- [ ] 3.2.2 Create comment list item widget with price badge
- [ ] 3.2.3 Display "price at comment time" prominently
- [ ] 3.2.4 Create comment input bottom sheet
- [ ] 3.2.5 Show current price in input sheet
- [ ] 3.2.6 Implement post comment functionality
- [ ] 3.2.7 Fetch and display comments with pagination
- [ ] 3.2.8 Implement like button with optimistic update
- [ ] 3.2.9 Implement reply functionality (nested comments)
- [ ] 3.2.10 Add "load more" for pagination
- [ ] 3.2.11 Write widget tests for comment components

**Validation**: Comments post with price, display correctly, likes work, replies nest

### 3.3 Price Prediction Voting (Mobile)
- [ ] 3.3.1 Create prediction list view (active/ended tabs)
- [ ] 3.3.2 Create prediction card widget showing question and options
- [ ] 3.3.3 Display ABCD options with vote percentages
- [ ] 3.3.4 Implement vote selection and submission
- [ ] 3.3.5 Show countdown timer for active predictions
- [ ] 3.3.6 Create "create prediction" bottom sheet
- [ ] 3.3.7 Implement prediction form (question, 2-4 options, deadline)
- [ ] 3.3.8 Add verification rule selector (manual/automatic)
- [ ] 3.3.9 Submit prediction to backend
- [ ] 3.3.10 Display prediction results after verification
- [ ] 3.3.11 Show correct answer and user's choice
- [ ] 3.3.12 Write widget tests for prediction components

**Validation**: Users create predictions, vote, see results, accuracy tracked

### 3.4 Community Page (Full Implementation)
- [ ] 3.4.1 Implement hot topics list with engagement metrics
- [ ] 3.4.2 Implement trending symbols carousel
- [ ] 3.4.3 Implement top comments feed
- [ ] 3.4.4 Add prediction leaderboard tabs (accuracy, points, streak, active)
- [ ] 3.4.5 Display leaderboard with user rankings
- [ ] 3.4.6 Show user badges/titles (prediction master, etc.)
- [ ] 3.4.7 Implement pull-to-refresh for all sections
- [ ] 3.4.8 Add navigation to detail pages from community items
- [ ] 3.4.9 Write widget tests for community components

**Validation**: All community sections populate, rankings display, navigation works

### 3.5 Profile Page (Prediction Stats)
- [ ] 3.5.1 Fetch and display user prediction statistics
- [ ] 3.5.2 Show accuracy rate, total predictions, streak
- [ ] 3.5.3 Display user title/badge
- [ ] 3.5.4 Create prediction history list (my predictions, my votes)
- [ ] 3.5.5 Show prediction results with correct/incorrect indicators
- [ ] 3.5.6 Add filter for active/completed predictions
- [ ] 3.5.7 Write widget tests for stats display

**Validation**: Stats display correctly, history shows all predictions

### 3.6 Content Moderation (Backend)
- [ ] 3.6.1 Implement basic profanity filter for comments
- [ ] 3.6.2 Add spam detection (rate limiting per user)
- [ ] 3.6.3 Create admin flag/report endpoint (POST /api/v1/comments/{id}/report)
- [ ] 3.6.4 Implement comment soft-delete
- [ ] 3.6.5 Write tests for moderation logic

**Validation**: Profanity blocked, spam prevented, reports work

### 3.7 Phase 3 Finalization
- [ ] 3.7.1 Test complete user journey (register → comment → predict → vote)
- [ ] 3.7.2 Verify all social features work end-to-end
- [ ] 3.7.3 Test edge cases (empty states, errors, offline)
- [ ] 3.7.4 Ensure proper error messages and user feedback
- [ ] 3.7.5 Achieve 70% test coverage on social features

**Validation**: Social features fully functional, tested, stable

---

## Phase 4: Real-time Features (WebSocket & Live Updates)

### 4.1 WebSocket Infrastructure (Backend)
- [ ] 4.1.1 Implement WebSocket endpoint (ws://api/v1/ws)
- [ ] 4.1.2 Create connection manager for client tracking
- [ ] 4.1.3 Implement authentication for WebSocket connections
- [ ] 4.1.4 Create message protocol (JSON: type, payload)
- [ ] 4.1.5 Implement subscribe/unsubscribe to symbols
- [ ] 4.1.6 Create background task to broadcast price updates every 5s
- [ ] 4.1.7 Implement heartbeat/ping-pong for connection health
- [ ] 4.1.8 Handle client disconnections gracefully
- [ ] 4.1.9 Write tests for WebSocket handlers

**Validation**: WebSocket connects, authenticates, receives price updates

### 4.2 Real-time Price Updates (Mobile)
- [ ] 4.2.1 Create WebSocket service in Flutter
- [ ] 4.2.2 Establish connection on app launch
- [ ] 4.2.3 Implement reconnection logic with exponential backoff
- [ ] 4.2.4 Subscribe to symbols based on current page
- [ ] 4.2.5 Update UI when price messages received
- [ ] 4.2.6 Implement price change animation (flash green/red)
- [ ] 4.2.7 Update home page cards in real-time
- [ ] 4.2.8 Update quotes page list in real-time
- [ ] 4.2.9 Update detail page price in real-time
- [ ] 4.2.10 Handle connection errors and show status indicator
- [ ] 4.2.11 Write tests for WebSocket service

**Validation**: Prices update live without refresh, animations work, reconnects on failure

### 4.3 Prediction Verification System
- [ ] 4.3.1 Create scheduled job to check prediction deadlines every minute
- [ ] 4.3.2 Fetch current price at verification time
- [ ] 4.3.3 Calculate price change percentage
- [ ] 4.3.4 Determine correct answer based on verification rules
- [ ] 4.3.5 Update all vote records with is_correct flag
- [ ] 4.3.6 Update user prediction statistics (accuracy, streak)
- [ ] 4.3.7 Broadcast verification result via WebSocket
- [ ] 4.3.8 Write tests for verification logic

**Validation**: Predictions verify automatically, accuracy updates, results broadcast

### 4.4 Push Notifications (Mobile)
- [ ] 4.4.1 Set up Firebase Cloud Messaging (FCM)
- [ ] 4.4.2 Configure iOS and Android for push notifications
- [ ] 4.4.3 Implement device token registration
- [ ] 4.4.4 Create notification service (backend)
- [ ] 4.4.5 Send notification when prediction verified
- [ ] 4.4.6 Send notification when comment receives reply
- [ ] 4.4.7 Send notification when comment receives like (optional)
- [ ] 4.4.8 Implement notification tap handling (deep linking)
- [ ] 4.4.9 Add notification preferences in profile
- [ ] 4.4.10 Write tests for notification service

**Validation**: Notifications received, tap opens correct page, preferences work

### 4.5 Real-time Comment Updates
- [ ] 4.5.1 Broadcast new comments via WebSocket
- [ ] 4.5.2 Update comment list in real-time when new comment posted
- [ ] 4.5.3 Update like count in real-time
- [ ] 4.5.4 Show "new comments" indicator
- [ ] 4.5.5 Implement optimistic UI updates
- [ ] 4.5.6 Write tests for real-time comment updates

**Validation**: Comments appear instantly, likes update live

### 4.6 Real-time Prediction Updates
- [ ] 4.6.1 Broadcast vote updates via WebSocket
- [ ] 4.6.2 Update vote percentages in real-time
- [ ] 4.6.3 Update participant count in real-time
- [ ] 4.6.4 Show countdown timer with live updates
- [ ] 4.6.5 Broadcast verification results to all participants
- [ ] 4.6.6 Write tests for real-time prediction updates

**Validation**: Vote percentages update live, countdown accurate, results instant

### 4.7 Performance Optimization
- [ ] 4.7.1 Implement Redis Pub/Sub for WebSocket scaling (if needed)
- [ ] 4.7.2 Add database query optimization (indexes, query analysis)
- [ ] 4.7.3 Implement API response caching where appropriate
- [ ] 4.7.4 Optimize mobile app bundle size
- [ ] 4.7.5 Implement lazy loading for images and lists
- [ ] 4.7.6 Add performance monitoring (backend and mobile)
- [ ] 4.7.7 Load test WebSocket with 100+ concurrent connections

**Validation**: API p95 <200ms, WebSocket handles 100+ clients, app loads fast

### 4.8 Phase 4 Finalization
- [ ] 4.8.1 Test all real-time features end-to-end
- [ ] 4.8.2 Verify WebSocket reconnection works reliably
- [ ] 4.8.3 Test notification delivery on iOS and Android
- [ ] 4.8.4 Ensure no memory leaks in WebSocket connections
- [ ] 4.8.5 Verify prediction verification runs on schedule
- [ ] 4.8.6 Test with multiple concurrent users

**Validation**: All real-time features stable, performant, reliable

---

## Final MVP Validation & Launch Preparation

### 5.1 End-to-End Testing
- [ ] 5.1.1 Complete user journey testing (registration → all features)
- [ ] 5.1.2 Test on multiple devices (iOS/Android, different screen sizes)
- [ ] 5.1.3 Test offline behavior and error recovery
- [ ] 5.1.4 Test with poor network conditions
- [ ] 5.1.5 Verify all edge cases handled gracefully

### 5.2 Security & Compliance
- [ ] 5.2.1 Run security audit on backend (OWASP top 10)
- [ ] 5.2.2 Verify JWT implementation secure
- [ ] 5.2.3 Test SQL injection prevention
- [ ] 5.2.4 Verify XSS prevention in comments
- [ ] 5.2.5 Add rate limiting to all public endpoints
- [ ] 5.2.6 Add legal disclaimers (no investment advice)
- [ ] 5.2.7 Create privacy policy and terms of service
- [ ] 5.2.8 Implement GDPR compliance (data export, deletion)

### 5.3 Documentation
- [ ] 5.3.1 Complete API documentation (Swagger/OpenAPI)
- [ ] 5.3.2 Write deployment guide (Docker, environment setup)
- [ ] 5.3.3 Create user guide/FAQ
- [ ] 5.3.4 Document architecture and design decisions
- [ ] 5.3.5 Create troubleshooting guide

### 5.4 Deployment Preparation
- [ ] 5.4.1 Set up production database (PostgreSQL)
- [ ] 5.4.2 Set up production Redis
- [ ] 5.4.3 Configure production environment variables
- [ ] 5.4.4 Set up SSL/TLS certificates
- [ ] 5.4.5 Configure CDN for static assets (if needed)
- [ ] 5.4.6 Set up monitoring and alerting (Sentry, DataDog, etc.)
- [ ] 5.4.7 Set up logging aggregation
- [ ] 5.4.8 Create backup and disaster recovery plan
- [ ] 5.4.9 Deploy backend to production
- [ ] 5.4.10 Submit mobile app to App Store and Google Play

### 5.5 Launch Checklist
- [ ] 5.5.1 All critical bugs fixed
- [ ] 5.5.2 Performance benchmarks met (API <200ms, WebSocket <5s)
- [ ] 5.5.3 Test coverage ≥70% on backend
- [ ] 5.5.4 Security audit passed
- [ ] 5.5.5 Legal disclaimers in place
- [ ] 5.5.6 Monitoring and alerts configured
- [ ] 5.5.7 Support channels ready (email, feedback form)
- [ ] 5.5.8 Marketing materials prepared
- [ ] 5.5.9 Beta testing completed with real users
- [ ] 5.5.10 Go/no-go decision made

**Final Validation**: MVP ready for public launch

---

## Notes

### Parallelizable Work
- Phase 1 tasks can be split between backend developers
- Phase 2 UI screens can be built in parallel once navigation is done
- Phase 3 comments and predictions can be developed simultaneously
- Phase 4 WebSocket and notifications can be parallel tracks

### Dependencies
- Phase 2 depends on Phase 1 API completion
- Phase 3 depends on Phase 2 UI foundation
- Phase 4 depends on Phase 3 social features
- Each phase should be fully tested before moving to next

### Risk Mitigation
- Start market data API integration early (Phase 1.4)
- Build WebSocket infrastructure early to identify scaling issues
- Implement basic content moderation before public launch
- Have rollback plan for each deployment
- Monitor error rates and performance metrics closely

