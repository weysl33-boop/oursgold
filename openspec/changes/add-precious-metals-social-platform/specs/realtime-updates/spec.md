# Real-time Updates Capability

## ADDED Requirements

### Requirement: WebSocket Connection Management
The system SHALL establish and maintain WebSocket connections for real-time bidirectional communication.

#### Scenario: Establish WebSocket connection
- **WHEN** mobile client connects to WebSocket endpoint with JWT token
- **THEN** system validates token and establishes connection
- **AND** assigns unique connection ID
- **AND** adds connection to active connections pool

#### Scenario: Authentication via JWT
- **WHEN** client connects with valid JWT token in query parameter or header
- **THEN** system validates token signature and expiration
- **AND** extracts user_id from token payload
- **AND** associates connection with user_id

#### Scenario: Reject unauthenticated connection
- **WHEN** client attempts to connect without valid JWT token
- **THEN** system rejects connection with 401 Unauthorized
- **AND** closes WebSocket immediately

#### Scenario: Connection heartbeat
- **WHEN** WebSocket connection is established
- **THEN** server sends ping message every 30 seconds
- **AND** expects pong response within 10 seconds
- **AND** closes connection if pong not received (connection dead)

#### Scenario: Graceful disconnection
- **WHEN** client closes WebSocket connection
- **THEN** system removes connection from active pool
- **AND** unsubscribes from all symbol channels
- **AND** logs disconnection event

### Requirement: Symbol Subscription
The system SHALL allow clients to subscribe to specific symbols for targeted price updates.

#### Scenario: Subscribe to symbols
- **WHEN** client sends subscribe message with symbols ["XAUUSD", "XAGUSD", "EURUSD"]
- **THEN** system adds connection to subscription list for each symbol
- **AND** sends confirmation message
- **AND** immediately sends current prices for subscribed symbols

#### Scenario: Unsubscribe from symbols
- **WHEN** client sends unsubscribe message with symbols ["EURUSD"]
- **THEN** system removes connection from subscription list for that symbol
- **AND** sends confirmation message
- **AND** stops sending price updates for unsubscribed symbol

#### Scenario: Auto-subscribe on page navigation
- **WHEN** mobile app navigates to detail page for symbol "XAUUSD"
- **THEN** app sends subscribe message for "XAUUSD"
- **AND** receives real-time price updates for that symbol

#### Scenario: Auto-unsubscribe on page exit
- **WHEN** mobile app navigates away from detail page
- **THEN** app sends unsubscribe message for previous symbol
- **AND** stops receiving updates for that symbol

### Requirement: Real-time Price Broadcasting
The system SHALL broadcast price updates to subscribed clients every 5 seconds.

#### Scenario: Broadcast price updates
- **WHEN** background task fetches new prices every 5 seconds
- **THEN** system broadcasts price_update message to all clients subscribed to each symbol
- **AND** message includes symbol_code, price, change, change_percent, timestamp

#### Scenario: Selective broadcasting
- **WHEN** price update is available for "XAUUSD"
- **THEN** system sends update only to clients subscribed to "XAUUSD"
- **AND** does not send to clients subscribed only to other symbols

#### Scenario: Batch price updates
- **WHEN** client is subscribed to multiple symbols
- **THEN** system may batch price updates into single message
- **OR** sends separate message for each symbol
- **AND** client receives all updates within 5-second window

### Requirement: Real-time Comment Notifications
The system SHALL broadcast new comments to clients viewing the same symbol.

#### Scenario: Broadcast new comment
- **WHEN** user posts comment on symbol "XAUUSD"
- **THEN** system broadcasts new_comment message to all clients subscribed to "XAUUSD"
- **AND** message includes full comment object (user, content, price_at_comment, timestamp)

#### Scenario: Broadcast comment like
- **WHEN** user likes a comment
- **THEN** system broadcasts comment_liked message to subscribed clients
- **AND** message includes comment_id and updated likes_count

#### Scenario: Broadcast comment reply
- **WHEN** user replies to comment
- **THEN** system broadcasts new_reply message to subscribed clients
- **AND** message includes parent_comment_id and reply object

### Requirement: Real-time Prediction Updates
The system SHALL broadcast prediction events to participants and subscribers.

#### Scenario: Broadcast new vote
- **WHEN** user votes on prediction
- **THEN** system broadcasts vote_update message to all clients viewing that prediction
- **AND** message includes updated vote distribution percentages

#### Scenario: Broadcast prediction verification
- **WHEN** prediction is verified by background task
- **THEN** system broadcasts prediction_verified message to all participants
- **AND** message includes prediction_id, correct_option, price_at_verify, user's result (correct/incorrect)

#### Scenario: Countdown timer sync
- **WHEN** client displays active prediction
- **THEN** client calculates countdown locally based on verify_time
- **AND** optionally receives periodic sync messages from server to prevent drift

### Requirement: Push Notifications
The system SHALL send push notifications for important events via Firebase Cloud Messaging.

#### Scenario: Register device token
- **WHEN** mobile app obtains FCM device token
- **THEN** app sends token to backend
- **AND** backend stores token associated with user_id

#### Scenario: Send prediction result notification
- **WHEN** prediction is verified
- **THEN** system sends push notification to all participants
- **AND** notification title is "预测结果揭晓"
- **AND** notification body includes prediction question and user's result
- **AND** notification deep-links to prediction detail page

#### Scenario: Send comment reply notification
- **WHEN** user receives reply to their comment
- **THEN** system sends push notification to comment author
- **AND** notification title is "有人回复了你的评论"
- **AND** notification body includes reply preview
- **AND** notification deep-links to comment thread

#### Scenario: Notification preferences
- **WHEN** user disables prediction notifications in settings
- **THEN** system does not send prediction result notifications to that user
- **AND** still sends other notification types (if enabled)

#### Scenario: Foreground notification handling
- **WHEN** app is in foreground and notification arrives
- **THEN** app displays in-app notification banner
- **AND** does not show system notification

#### Scenario: Background notification handling
- **WHEN** app is in background and notification arrives
- **THEN** system displays notification in notification tray
- **AND** user can tap to open app at relevant page

### Requirement: WebSocket Reconnection
The system SHALL handle connection failures and automatic reconnection.

#### Scenario: Detect connection loss
- **WHEN** WebSocket connection is lost (network failure, server restart)
- **THEN** mobile app detects disconnection event
- **AND** displays connection status indicator (offline)

#### Scenario: Automatic reconnection
- **WHEN** connection is lost
- **THEN** app attempts to reconnect after 1 second
- **AND** uses exponential backoff (1s, 2s, 4s, 8s, max 30s)
- **AND** continues retrying until connection restored

#### Scenario: Resubscribe after reconnection
- **WHEN** WebSocket reconnects after disconnection
- **THEN** app automatically resubscribes to previously subscribed symbols
- **AND** requests latest prices to sync state

#### Scenario: Fallback to polling
- **WHEN** WebSocket connection fails repeatedly
- **THEN** app falls back to HTTP polling every 10 seconds
- **AND** continues attempting WebSocket reconnection in background

### Requirement: WebSocket Scaling
The system SHALL support horizontal scaling of WebSocket servers using Redis Pub/Sub.

#### Scenario: Multi-instance broadcasting
- **WHEN** multiple backend instances are running
- **AND** price update needs to be broadcast
- **THEN** instance publishes message to Redis channel
- **AND** all instances subscribe to channel and broadcast to their connected clients

#### Scenario: Connection distribution
- **WHEN** load balancer distributes WebSocket connections across instances
- **THEN** each instance maintains its own connection pool
- **AND** Redis Pub/Sub ensures all instances receive broadcast messages

#### Scenario: Instance failure handling
- **WHEN** backend instance crashes
- **THEN** clients connected to that instance detect disconnection
- **AND** reconnect to another instance via load balancer
- **NOTE**: This is planned for post-MVP scaling

### Requirement: Real-time Performance
The system SHALL deliver real-time updates with minimal latency.

#### Scenario: Price update latency
- **WHEN** new price is fetched from external API
- **THEN** price update is broadcast to clients within 100ms
- **AND** total latency from API fetch to client receipt is <5 seconds

#### Scenario: Comment broadcast latency
- **WHEN** user posts comment
- **THEN** comment is broadcast to subscribed clients within 200ms
- **AND** other users see new comment in real-time

#### Scenario: Concurrent connections
- **WHEN** 1000+ clients are connected simultaneously
- **THEN** system maintains stable performance
- **AND** all clients receive updates within latency targets
- **NOTE**: MVP target is 100-500 concurrent connections

