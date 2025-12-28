# Mobile Application Capability

## ADDED Requirements

### Requirement: Bottom Tab Navigation
The system SHALL provide bottom tab navigation with 5 main sections.

#### Scenario: Display bottom navigation bar
- **WHEN** app launches
- **THEN** bottom navigation bar is visible with 5 tabs
- **AND** tabs are labeled: 首页 (Home), 行情 (Quotes), 外汇 (FX), 社区 (Community), 我的 (Profile)
- **AND** each tab has corresponding icon (Remix Icon set)

#### Scenario: Tab selection
- **WHEN** user taps on tab
- **THEN** app navigates to corresponding page
- **AND** selected tab is highlighted with accent color
- **AND** unselected tabs are displayed in gray

#### Scenario: Tab persistence
- **WHEN** user navigates between tabs
- **THEN** each tab maintains its scroll position and state
- **AND** returning to previous tab shows same content position

### Requirement: Home Page
The system SHALL display market overview with 6 default instruments in card grid.

#### Scenario: Display market cards
- **WHEN** user views home page
- **THEN** 6 market cards are displayed in 2-column grid
- **AND** default symbols are: XAUUSD, XAGUSD, EURUSD, GBPUSD, USDJPY, USDCNY

#### Scenario: Market card content
- **WHEN** displaying market card
- **THEN** card shows symbol name (Chinese and English)
- **AND** shows current price with appropriate decimal places
- **AND** shows price change amount and percentage with color coding (green up, red down)
- **AND** shows mini trend chart (sparkline) for last 24 hours

#### Scenario: Pull to refresh
- **WHEN** user pulls down on home page
- **THEN** app fetches latest prices from API
- **AND** updates all market cards
- **AND** shows loading indicator during refresh

#### Scenario: Navigate to detail page
- **WHEN** user taps on market card
- **THEN** app navigates to detail page for that symbol
- **AND** passes symbol_code as parameter

### Requirement: Quotes Page
The system SHALL display categorized list of all supported instruments.

#### Scenario: Display category chips
- **WHEN** user views quotes page
- **THEN** horizontal scrollable chip bar is displayed at top
- **AND** chips are labeled: 自选, 黄金, 白银, 外汇, 加密货币, 股指

#### Scenario: Filter by category
- **WHEN** user taps category chip (e.g., "黄金")
- **THEN** list displays only symbols of that category
- **AND** selected chip is highlighted

#### Scenario: Quote list item
- **WHEN** displaying quote in list
- **THEN** item shows symbol name, market badge (LBMA/COMEX/SGE)
- **AND** shows current price, change amount, change percentage
- **AND** shows mini trend chart
- **AND** shows favorite star icon (if user favorited)

#### Scenario: Navigate to detail
- **WHEN** user taps quote list item
- **THEN** app navigates to detail page for that symbol

### Requirement: Forex Page
The system SHALL provide currency conversion calculator with popular pairs list.

#### Scenario: Display currency calculator
- **WHEN** user views forex page
- **THEN** calculator card is displayed at top
- **AND** shows source currency selector (default: USD)
- **AND** shows target currency selector (default: CNY)
- **AND** shows amount input field (default: 1)

#### Scenario: Currency conversion
- **WHEN** user enters amount "100" in source currency USD
- **THEN** app fetches current USD/CNY exchange rate
- **AND** calculates converted amount (e.g., 100 * 7.2345 = 723.45)
- **AND** displays result in target currency field

#### Scenario: Swap currencies
- **WHEN** user taps swap button (⇅)
- **THEN** source and target currencies are exchanged
- **AND** conversion is recalculated with new direction

#### Scenario: Popular currency pairs
- **WHEN** user scrolls below calculator
- **THEN** list of popular currency pairs is displayed
- **AND** each pair shows current rate, change, and mini chart

### Requirement: Detail Page
The system SHALL display comprehensive symbol information with interactive charts and comments.

#### Scenario: Display symbol header
- **WHEN** user views detail page for symbol
- **THEN** header shows symbol name, market status (trading/closed)
- **AND** shows current price in large font
- **AND** shows change amount and percentage with color coding

#### Scenario: Display data panel
- **WHEN** user views detail page
- **THEN** 3x2 data grid is displayed below header
- **AND** shows: 开盘 (open), 最高 (high), 成交量 (volume), 收盘 (close), 最低 (low), 均量 (avg volume)

#### Scenario: Display TradingView chart
- **WHEN** user views detail page
- **THEN** interactive K-line chart is displayed
- **AND** chart shows candlesticks for selected time period
- **AND** user can pan and zoom chart

#### Scenario: Time period selector
- **WHEN** user views chart
- **THEN** time period chips are displayed: 1日, 5日, 1月, 6月, 1年, 全部
- **AND** default selection is "1日"
- **WHEN** user taps different period
- **THEN** chart updates to show data for that period

#### Scenario: Display comments section
- **WHEN** user scrolls below chart
- **THEN** comments section is displayed
- **AND** shows recent comments with price badges
- **AND** shows comment input button

### Requirement: Community Page
The system SHALL display aggregated community content and leaderboards.

#### Scenario: Display hot topics
- **WHEN** user views community page
- **THEN** hot topics section is displayed at top
- **AND** shows top 5 trending topics with hashtags and discussion counts

#### Scenario: Display trending symbols
- **WHEN** user views community page
- **THEN** trending symbols carousel is displayed
- **AND** shows symbols with highest recent activity

#### Scenario: Display top comments
- **WHEN** user views community page
- **THEN** top comments section is displayed
- **AND** shows most liked/engaged comments from all symbols

#### Scenario: Display prediction leaderboard
- **WHEN** user views community page
- **THEN** leaderboard section is displayed with tabs
- **AND** tabs are: 准确率, 积分, 连胜, 活跃度
- **AND** default tab is "准确率"

#### Scenario: Leaderboard display
- **WHEN** user views leaderboard tab
- **THEN** top 50 users are displayed in ranked list
- **AND** each entry shows rank, user avatar, username, rank title, key stats
- **AND** top 3 users have special badges (🥇🥈🥉)

### Requirement: Profile Page
The system SHALL display user profile with settings and prediction statistics.

#### Scenario: Display user info
- **WHEN** user views profile page
- **THEN** user avatar and username are displayed at top
- **AND** shows user's rank title badge

#### Scenario: Display prediction stats
- **WHEN** user views profile page
- **THEN** prediction statistics card is displayed
- **AND** shows accuracy rate, total participations, current streak
- **AND** shows rank position in leaderboard

#### Scenario: Display settings
- **WHEN** user views profile page
- **THEN** settings sections are displayed
- **AND** sections include: 账号绑定, 偏好设置, 语言切换, 关于

#### Scenario: Logout
- **WHEN** user taps logout button
- **THEN** app clears JWT token from secure storage
- **AND** navigates to login screen

### Requirement: Authentication Flow
The system SHALL provide login and registration screens.

#### Scenario: Display login screen
- **WHEN** unauthenticated user opens app
- **THEN** login screen is displayed
- **AND** shows email and password input fields
- **AND** shows login button and "注册" link

#### Scenario: User login
- **WHEN** user enters valid credentials and taps login
- **THEN** app sends login request to backend
- **AND** receives JWT token
- **AND** stores token in secure storage
- **AND** navigates to home page

#### Scenario: Display registration screen
- **WHEN** user taps "注册" link
- **THEN** registration screen is displayed
- **AND** shows username, email, password input fields
- **AND** shows register button

#### Scenario: User registration
- **WHEN** user enters valid registration data and taps register
- **THEN** app sends registration request to backend
- **AND** receives JWT token
- **AND** stores token and navigates to home page

### Requirement: Comment Interaction
The system SHALL allow users to post and interact with comments.

#### Scenario: Post comment
- **WHEN** user taps comment input button on detail page
- **THEN** comment input bottom sheet is displayed
- **AND** shows current price badge
- **AND** shows text input field and post button

#### Scenario: Submit comment
- **WHEN** user enters comment text and taps post
- **THEN** app sends comment to backend with symbol_code
- **AND** backend captures current price automatically
- **AND** new comment appears in list with price badge

#### Scenario: Like comment
- **WHEN** user taps like button on comment
- **THEN** app sends like request to backend
- **AND** like count increments
- **AND** like button changes to filled state

#### Scenario: Reply to comment
- **WHEN** user taps reply button on comment
- **THEN** comment input sheet opens with "@username" pre-filled
- **AND** user can enter reply text
- **AND** reply is posted as nested comment

### Requirement: Prediction Interaction
The system SHALL allow users to create and vote on predictions.

#### Scenario: Create prediction
- **WHEN** user taps "创建预测" button
- **THEN** prediction creation bottom sheet is displayed
- **AND** shows question input, option inputs (A, B, C, D), deadline picker

#### Scenario: Submit prediction
- **WHEN** user fills prediction form and taps submit
- **THEN** app sends prediction to backend
- **AND** backend captures current price automatically
- **AND** prediction appears in active predictions list

#### Scenario: Vote on prediction
- **WHEN** user taps option (A, B, C, or D) on active prediction
- **THEN** app sends vote to backend
- **AND** backend captures current price at vote time
- **AND** vote distribution updates in real-time

#### Scenario: View prediction results
- **WHEN** user views completed prediction
- **THEN** correct answer is highlighted
- **AND** shows price change from creation to verification
- **AND** shows user's vote result (correct/incorrect)

### Requirement: Real-time Updates
The system SHALL display real-time price and content updates via WebSocket.

#### Scenario: Establish WebSocket connection
- **WHEN** app launches and user is authenticated
- **THEN** app establishes WebSocket connection with JWT token
- **AND** connection status indicator shows "connected"

#### Scenario: Subscribe to symbol
- **WHEN** user navigates to detail page for symbol
- **THEN** app sends subscribe message for that symbol
- **AND** receives real-time price updates

#### Scenario: Display real-time price
- **WHEN** price update is received via WebSocket
- **THEN** price display updates immediately
- **AND** price change is animated (flash green/red)

#### Scenario: Display real-time comments
- **WHEN** new comment is broadcast via WebSocket
- **THEN** comment appears in list without refresh
- **AND** shows "new comment" indicator

### Requirement: Offline Support
The system SHALL provide graceful degradation when offline.

#### Scenario: Detect offline state
- **WHEN** network connection is lost
- **THEN** app displays offline indicator
- **AND** shows cached data with staleness warning

#### Scenario: Queue actions when offline
- **WHEN** user attempts to post comment while offline
- **THEN** app shows error "No internet connection"
- **AND** does not queue action (requires online for price capture)

#### Scenario: Reconnect and sync
- **WHEN** network connection is restored
- **THEN** app reconnects WebSocket
- **AND** fetches latest data to sync state
- **AND** removes offline indicator

### Requirement: Performance and UX
The system SHALL provide smooth and responsive user experience.

#### Scenario: App launch time
- **WHEN** user launches app
- **THEN** splash screen displays for <2 seconds
- **AND** home page loads within 3 seconds

#### Scenario: Page transition
- **WHEN** user navigates between pages
- **THEN** transition animation completes in <300ms
- **AND** new page content loads immediately

#### Scenario: List scrolling
- **WHEN** user scrolls long list (comments, predictions)
- **THEN** scrolling is smooth at 60fps
- **AND** images load lazily as user scrolls

#### Scenario: Error handling
- **WHEN** API request fails
- **THEN** app displays user-friendly error message
- **AND** provides retry button
- **AND** does not crash or freeze

### Requirement: Search Functionality
The system SHALL provide comprehensive search across markets, topics, and users.

#### Scenario: Display search bar
- **WHEN** user views home page
- **THEN** search bar is displayed below navigation
- **AND** placeholder text shows "搜索市场 or 话题..."
- **AND** search bar has rounded corners with search icon

#### Scenario: Enter search page
- **WHEN** user taps on search bar
- **THEN** app navigates to dedicated search page
- **AND** keyboard automatically opens
- **AND** cursor is focused on search input

#### Scenario: Search suggestions
- **WHEN** user types in search input
- **THEN** system shows real-time suggestions as user types
- **AND** suggestions include: matching symbols, topics (hashtags), users
- **AND** suggestions update with each keystroke (debounced 300ms)

#### Scenario: Search by symbol
- **WHEN** user searches for "黄金" or "XAU"
- **THEN** results include matching trading symbols
- **AND** each result shows symbol name (CN/EN), current price, change%
- **AND** tapping result navigates to symbol detail page

#### Scenario: Search by topic
- **WHEN** user searches for topic hashtag (e.g., "#降息")
- **THEN** results include matching discussion topics
- **AND** each result shows hashtag, discussion count, heat score
- **AND** tapping result navigates to topic discussion page

#### Scenario: Search by user
- **WHEN** user searches for username
- **THEN** results include matching user profiles
- **AND** each result shows avatar, username, rank title
- **AND** tapping result navigates to user profile page

#### Scenario: Search result tabs
- **WHEN** user submits search query
- **THEN** results page shows tabs: 全部, 市场, 话题, 用户
- **AND** "全部" tab shows mixed results from all categories
- **AND** other tabs show filtered results

#### Scenario: Recent searches
- **WHEN** user opens search page without query
- **THEN** recent search history is displayed
- **AND** user can tap to repeat previous search
- **AND** user can clear search history

#### Scenario: Hot searches
- **WHEN** user opens search page
- **THEN** hot search keywords are displayed below recent searches
- **AND** shows top 10 trending search terms
- **AND** tapping hot keyword performs that search

### Requirement: Search API

#### Scenario: Search endpoint
- **Endpoint**: `GET /api/v1/search`
- **Query Parameters**:
  - `q` (string, required) - Search query
  - `type` (string, optional) - Filter by type: all, symbol, topic, user
  - `limit` (int, default: 20) - Max results per category
- **Response**:
```json
{
  "query": "黄金",
  "symbols": [
    {
      "code": "XAUUSD",
      "name_cn": "伦敦金",
      "name_en": "Spot Gold",
      "price": 2658.50,
      "change_percent": 1.08
    }
  ],
  "topics": [
    {
      "hashtag": "#黄金突破2660#",
      "discussion_count": 2300,
      "heat_score": 98
    }
  ],
  "users": [
    {
      "id": "uuid",
      "username": "黄金猎手",
      "avatar_url": "https://...",
      "rank_title": "预测大师"
    }
  ]
}
```

#### Scenario: Search suggestions endpoint
- **Endpoint**: `GET /api/v1/search/suggestions`
- **Query Parameters**:
  - `q` (string, required) - Partial search query
  - `limit` (int, default: 5) - Max suggestions
- **Response**:
```json
{
  "suggestions": [
    { "type": "symbol", "text": "黄金 (XAUUSD)", "value": "XAUUSD" },
    { "type": "topic", "text": "#黄金突破2660#", "value": "#黄金突破2660#" },
    { "type": "user", "text": "@黄金猎手", "value": "user-id" }
  ]
}
```

### Requirement: News Section on Home Page
The system SHALL display news section on home page as specified in PRD.

#### Scenario: Display news section
- **WHEN** user views home page
- **THEN** news section is displayed below market cards grid
- **AND** section header shows "新闻" with "查看全部 >" link
- **AND** displays 3-5 most recent news articles

#### Scenario: News list item
- **WHEN** displaying news item on home page
- **THEN** item shows article title (max 2 lines, truncated)
- **AND** shows category tag (e.g., [股市], [大宗商品])
- **AND** shows relative time (e.g., "2小时前")
- **AND** shows thumbnail image on the right

#### Scenario: Navigate to news
- **WHEN** user taps news item
- **THEN** app navigates to news detail page
- **WHEN** user taps "查看全部"
- **THEN** app navigates to full news list page

### Requirement: Favorites/Watchlist
The system SHALL allow users to save symbols to their personal watchlist.

#### Scenario: Add symbol to favorites
- **WHEN** authenticated user taps favorite/star button on symbol
- **THEN** system adds symbol to user's favorites list
- **AND** favorite button changes to filled state
- **AND** API call: POST /api/v1/symbols/{code}/favorite

#### Scenario: Remove symbol from favorites
- **WHEN** authenticated user taps favorite button on already-favorited symbol
- **THEN** system removes symbol from user's favorites list
- **AND** favorite button changes to unfilled state
- **AND** API call: DELETE /api/v1/symbols/{code}/favorite

#### Scenario: View favorites list
- **WHEN** user selects "自选" category on quotes page
- **THEN** system displays only user's favorited symbols
- **AND** symbols are sorted by the order they were added (most recent first)
- **AND** each symbol shows real-time price data

#### Scenario: Empty favorites state
- **WHEN** user has no favorited symbols
- **THEN** "自选" tab shows empty state message
- **AND** suggests user to add symbols via star button

#### Scenario: Favorites sync across devices
- **WHEN** user favorites a symbol on one device
- **THEN** favorite is saved to backend
- **AND** appears on user's other devices after refresh

#### Scenario: Favorites API endpoints
- **Add favorite**: `POST /api/v1/symbols/{code}/favorite`
- **Remove favorite**: `DELETE /api/v1/symbols/{code}/favorite`
- **Get favorites**: `GET /api/v1/users/me/favorites`
- **Response**:
```json
{
  "favorites": [
    {
      "symbol_code": "XAUUSD",
      "added_at": "2025-12-27T10:00:00Z"
    },
    {
      "symbol_code": "EURUSD",
      "added_at": "2025-12-26T15:30:00Z"
    }
  ]
}
```

#### Scenario: Favorites database schema
```sql
CREATE TABLE user_favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    symbol_code VARCHAR(20) NOT NULL,
    added_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, symbol_code)
);

CREATE INDEX idx_favorites_user ON user_favorites(user_id);
```

