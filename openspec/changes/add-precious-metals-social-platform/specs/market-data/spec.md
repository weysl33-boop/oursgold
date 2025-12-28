# Market Data Capability

## ADDED Requirements

### Requirement: Symbol Management
The system SHALL maintain a catalog of supported trading symbols including precious metals (gold, silver, platinum, palladium) and major forex pairs.

#### Scenario: Retrieve supported symbols
- **WHEN** client requests the list of supported symbols
- **THEN** system returns all active symbols with metadata (code, name_cn, name_en, market, symbol_type, decimal_places)

#### Scenario: Symbol categorization
- **WHEN** client requests symbols filtered by category (e.g., "gold", "silver", "forex")
- **THEN** system returns only symbols matching that category

#### Scenario: Supported symbol list
The system SHALL support the following symbols by market:

**International Gold (LBMA/COMEX)**
| Code | Name (CN) | Name (EN) | Market | Decimal |
|------|-----------|-----------|--------|---------|
| XAUUSD | 伦敦金 | Spot Gold | LBMA | 2 |
| GC | 纽约金 | Gold Futures | COMEX | 2 |

**China Gold (SGE)**
| Code | Name (CN) | Name (EN) | Market | Decimal |
|------|-----------|-----------|--------|---------|
| AU9999 | 黄金9999 | Au99.99 | SGE | 2 |
| AU9995 | 黄金9995 | Au99.95 | SGE | 2 |
| AU100G | 黄金100克 | Au100g | SGE | 2 |
| AUTD | 黄金T+D | Au(T+D) | SGE | 2 |
| MAUTD | 迷你黄金T+D | mAu(T+D) | SGE | 2 |
| SHAU | 上海金 | Shanghai Gold | SGE | 2 |

**International Silver (LBMA/COMEX)**
| Code | Name (CN) | Name (EN) | Market | Decimal |
|------|-----------|-----------|--------|---------|
| XAGUSD | 伦敦银 | Spot Silver | LBMA | 3 |
| SI | 纽约银 | Silver Futures | COMEX | 3 |

**China Silver (SGE)**
| Code | Name (CN) | Name (EN) | Market | Decimal |
|------|-----------|-----------|--------|---------|
| AGTD | 白银T+D | Ag(T+D) | SGE | 3 |
| SHAG | 上海银 | Shanghai Silver | SGE | 3 |

**Other Precious Metals**
| Code | Name (CN) | Name (EN) | Market | Decimal |
|------|-----------|-----------|--------|---------|
| XPTUSD | 铂金 | Spot Platinum | LBMA | 2 |
| XPDUSD | 钯金 | Spot Palladium | LBMA | 2 |

**Major Forex Pairs**
| Code | Name (CN) | Name (EN) | Market | Decimal |
|------|-----------|-----------|--------|---------|
| EURUSD | 欧元/美元 | EUR/USD | Forex | 5 |
| GBPUSD | 英镑/美元 | GBP/USD | Forex | 5 |
| USDJPY | 美元/日元 | USD/JPY | Forex | 3 |
| USDCNY | 美元/人民币 | USD/CNY | Forex | 4 |
| AUDUSD | 澳元/美元 | AUD/USD | Forex | 5 |
| USDCHF | 美元/瑞郎 | USD/CHF | Forex | 5 |

### Requirement: Real-time Quote Retrieval
The system SHALL provide real-time market quotes for all supported symbols with latency not exceeding 5 seconds.

#### Scenario: Get single symbol quote
- **WHEN** client requests current quote for symbol "XAUUSD"
- **THEN** system returns price, change, change_percent, high, low, open, prev_close, volume, and timestamp
- **AND** data is no older than 5 seconds

#### Scenario: Get multiple symbol quotes
- **WHEN** client requests quotes for multiple symbols (e.g., "XAUUSD,XAGUSD,EURUSD")
- **THEN** system returns array of quotes for all requested symbols
- **AND** all quotes have consistent timestamp

#### Scenario: Quote caching
- **WHEN** multiple clients request the same symbol within 5 seconds
- **THEN** system serves cached data from Redis
- **AND** does not make redundant external API calls

### Requirement: Historical Data Retrieval
The system SHALL provide historical OHLCV (Open, High, Low, Close, Volume) data for charting purposes.

#### Scenario: Get historical data for time period
- **WHEN** client requests historical data for symbol "XAUUSD" with period "1D"
- **THEN** system returns array of OHLCV candles for the past 24 hours
- **AND** candles are at appropriate interval (e.g., 5-minute intervals for 1D)

#### Scenario: Support multiple time periods
- **WHEN** client requests data with period "1D", "5D", "1M", "6M", "1Y", or "ALL"
- **THEN** system returns data for the requested period
- **AND** adjusts candle interval appropriately (1min for 1D, 1hour for 1M, 1day for 1Y)

### Requirement: Market Data Integration
The system SHALL integrate with external market data provider API to fetch real-time and historical data.

#### Scenario: Fetch prices from external API
- **WHEN** background job runs every 5 seconds
- **THEN** system fetches latest prices for all active symbols from external API
- **AND** stores results in Redis cache with 5-second TTL
- **AND** optionally stores in PostgreSQL for historical record

#### Scenario: Handle API rate limits
- **WHEN** external API rate limit is reached
- **THEN** system serves cached data from Redis
- **AND** logs warning about rate limit
- **AND** retries after appropriate backoff period

#### Scenario: Handle API failures
- **WHEN** external API request fails
- **THEN** system serves last known good data from cache
- **AND** logs error with details
- **AND** continues serving stale data until API recovers

### Requirement: Market Status Tracking
The system SHALL track and display market trading status (open/closed) for each symbol.

#### Scenario: Display market status
- **WHEN** client requests quote for symbol
- **THEN** response includes market_status field ("trading" or "closed")
- **AND** status is determined based on market trading hours

#### Scenario: Weekend and holiday handling
- **WHEN** market is closed (weekend or holiday)
- **THEN** system returns last available quote
- **AND** market_status is "closed"
- **AND** timestamp indicates when quote was last updated

### Requirement: Data Accuracy and Precision
The system SHALL maintain appropriate decimal precision for different asset types.

#### Scenario: Precious metals precision
- **WHEN** returning quotes for gold or silver
- **THEN** prices are displayed with 2 decimal places (e.g., 2658.50)

#### Scenario: Forex precision
- **WHEN** returning quotes for currency pairs
- **THEN** prices are displayed with 4-5 decimal places (e.g., 1.08325 for EUR/USD)

#### Scenario: Percentage calculations
- **WHEN** calculating change_percent
- **THEN** value is accurate to 2 decimal places (e.g., 1.08%)
- **AND** formula is: (current_price - prev_close) / prev_close * 100

