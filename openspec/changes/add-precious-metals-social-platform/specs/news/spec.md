# News Feed Capability

## ADDED Requirements

### Requirement: News Article Retrieval
The system SHALL provide paginated news articles related to financial markets.

#### Scenario: Get news list
- **WHEN** client requests news list with limit=20
- **THEN** system returns up to 20 most recent news articles
- **AND** each article includes id, title, summary, category, source, published_at, thumbnail_url
- **AND** articles are sorted by published_at descending (newest first)

#### Scenario: News pagination
- **WHEN** client requests news with page=2 and limit=20
- **THEN** system returns articles 21-40
- **AND** response includes pagination metadata (page, limit, total, has_more)

#### Scenario: Filter news by category
- **WHEN** client requests news with category="股市"
- **THEN** system returns only articles matching that category
- **AND** supported categories are: 股市, 大宗商品, 外汇, 宏观, 加密货币

### Requirement: News Categories
The system SHALL categorize news articles for easy filtering.

#### Scenario: News category list
- **WHEN** client requests available news categories
- **THEN** system returns list of categories with counts:
  - 股市 (Stock Market)
  - 大宗商品 (Commodities)
  - 外汇 (Forex)
  - 宏观 (Macro Economics)
  - 加密货币 (Cryptocurrency)

#### Scenario: Category assignment
- **WHEN** news article is ingested
- **THEN** system assigns one or more categories based on content analysis
- **AND** primary category is determined for sorting/filtering

### Requirement: News Detail
The system SHALL provide full article content for individual news items.

#### Scenario: Get news detail
- **WHEN** client requests news article by ID
- **THEN** system returns full article with:
  - title
  - full_content (HTML or markdown)
  - category
  - source (publisher name)
  - source_url (original article link)
  - author (if available)
  - published_at
  - thumbnail_url
  - related_symbols (e.g., ["XAUUSD", "EURUSD"])

#### Scenario: Related symbols extraction
- **WHEN** displaying news detail
- **THEN** system shows related trading symbols mentioned in article
- **AND** each symbol links to its detail page

### Requirement: News on Home Page
The system SHALL display news section on the home page below market cards.

#### Scenario: Home page news section
- **WHEN** user views home page
- **THEN** news section is displayed below market cards grid
- **AND** shows section header "新闻" with "查看全部 >" link
- **AND** displays 3-5 most recent news articles

#### Scenario: News list item display
- **WHEN** displaying news in list
- **THEN** each item shows:
  - Article title (max 2 lines, truncated with ellipsis)
  - Category tag (e.g., [股市], [大宗商品])
  - Relative time (e.g., "2小时前")
  - Thumbnail image on the right side

#### Scenario: Navigate to news detail
- **WHEN** user taps on news item
- **THEN** app navigates to news detail page
- **AND** displays full article content

#### Scenario: Navigate to full news list
- **WHEN** user taps "查看全部" link
- **THEN** app navigates to full news list page
- **AND** displays all news with category filter tabs

### Requirement: News Data Source
The system SHALL integrate with external news API or RSS feeds for content.

#### Scenario: Fetch news from external source
- **WHEN** background task runs every 15 minutes
- **THEN** system fetches latest news from configured news API
- **AND** deduplicates articles by URL or external ID
- **AND** stores new articles in database

#### Scenario: News caching
- **WHEN** news list is requested
- **THEN** system serves cached response from Redis (TTL: 5 minutes)
- **AND** reduces load on database for repeated requests

#### Scenario: Handle news source failures
- **WHEN** external news API is unavailable
- **THEN** system serves existing cached/stored news
- **AND** logs error for monitoring
- **AND** retries fetch on next scheduled interval

### Requirement: News API Endpoints

#### Scenario: News list endpoint
- **Endpoint**: `GET /api/v1/news`
- **Query Parameters**:
  - `page` (int, default: 1) - Page number
  - `limit` (int, default: 20, max: 50) - Items per page
  - `category` (string, optional) - Filter by category
- **Response**:
```json
{
  "news": [
    {
      "id": "uuid",
      "title": "美股收高，投资者权衡通胀数据及美联储前景",
      "summary": "道琼斯工业平均指数周五收高...",
      "category": "股市",
      "source": "财联社",
      "published_at": "2025-12-27T08:30:00Z",
      "thumbnail_url": "https://..."
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

#### Scenario: News detail endpoint
- **Endpoint**: `GET /api/v1/news/{id}`
- **Response**:
```json
{
  "id": "uuid",
  "title": "美股收高，投资者权衡通胀数据及美联储前景",
  "full_content": "<p>道琼斯工业平均指数周五收高...</p>",
  "category": "股市",
  "source": "财联社",
  "source_url": "https://original-article-url.com",
  "author": "记者A",
  "published_at": "2025-12-27T08:30:00Z",
  "thumbnail_url": "https://...",
  "related_symbols": ["SPX", "XAUUSD"]
}
```

### Requirement: News Database Schema

#### Scenario: News table structure
```sql
CREATE TABLE news (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    external_id VARCHAR(255) UNIQUE,  -- ID from external source
    title VARCHAR(500) NOT NULL,
    summary TEXT,
    full_content TEXT,
    category VARCHAR(50) NOT NULL,
    source VARCHAR(100),
    source_url VARCHAR(500),
    author VARCHAR(100),
    thumbnail_url VARCHAR(500),
    related_symbols JSONB DEFAULT '[]',
    published_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_news_category ON news(category);
CREATE INDEX idx_news_published ON news(published_at DESC);
CREATE INDEX idx_news_external_id ON news(external_id);
```

