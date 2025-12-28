# Price-Anchored Comments Capability

## ADDED Requirements

### Requirement: Price-Anchored Comment Creation
The system SHALL automatically capture and store the current market price when a user posts a comment.

#### Scenario: Post comment with automatic price capture
- **WHEN** authenticated user posts comment on symbol "XAUUSD" with content "感觉要突破2660了"
- **THEN** system fetches current price for "XAUUSD" from Redis cache
- **AND** stores comment with price_at_comment field set to current price (e.g., 2658.50)
- **AND** stores timestamp of comment creation
- **AND** returns created comment with all fields including price_at_comment

#### Scenario: Price capture from cache
- **WHEN** user posts comment
- **THEN** system retrieves price from Redis cache (not external API)
- **AND** uses cached price with timestamp within last 5 seconds
- **AND** comment creation completes in <100ms

#### Scenario: Price unavailable handling
- **WHEN** user posts comment but price data is temporarily unavailable
- **THEN** system returns 503 Service Unavailable error
- **AND** error message indicates market data is temporarily unavailable
- **AND** suggests user retry in a few seconds

### Requirement: Comment Retrieval
The system SHALL provide paginated comment lists for each symbol with price anchors displayed.

#### Scenario: Get comments for symbol
- **WHEN** client requests comments for symbol "XAUUSD" with limit=20
- **THEN** system returns up to 20 most recent comments
- **AND** each comment includes user info, content, price_at_comment, timestamp, likes_count, replies_count
- **AND** comments are sorted by timestamp descending (newest first)

#### Scenario: Pagination
- **WHEN** client requests comments with page=2 and limit=20
- **THEN** system returns comments 21-40
- **AND** response includes pagination metadata (page, limit, total, has_more)

#### Scenario: Empty comment list
- **WHEN** client requests comments for symbol with no comments
- **THEN** system returns empty array
- **AND** pagination metadata shows total=0

### Requirement: Comment Threading (Replies)
The system SHALL support nested comment replies to enable discussions.

#### Scenario: Reply to comment
- **WHEN** authenticated user replies to existing comment
- **THEN** system creates new comment with parent_id set to original comment ID
- **AND** captures current price at time of reply
- **AND** increments replies_count on parent comment
- **AND** returns created reply

#### Scenario: Get comment thread
- **WHEN** client requests comment thread for parent comment
- **THEN** system returns parent comment
- **AND** includes nested replies (up to 3 levels deep)
- **AND** replies are sorted by timestamp ascending (oldest first)

#### Scenario: Collapsed replies display
- **WHEN** client requests comment list
- **THEN** each comment includes first 2-3 replies inline
- **AND** indicates total reply count
- **AND** provides link to view all replies if replies_count > 3

### Requirement: Comment Likes
The system SHALL allow users to like comments and track like counts.

#### Scenario: Like comment
- **WHEN** authenticated user likes a comment
- **THEN** system creates like record (comment_id, user_id)
- **AND** increments likes_count on comment
- **AND** returns updated likes_count

#### Scenario: Unlike comment
- **WHEN** authenticated user unlikes a previously liked comment
- **THEN** system deletes like record
- **AND** decrements likes_count on comment
- **AND** returns updated likes_count

#### Scenario: Duplicate like prevention
- **WHEN** user attempts to like same comment twice
- **THEN** system returns 400 Bad Request error
- **AND** does not create duplicate like record
- **AND** likes_count remains unchanged

#### Scenario: Like status in comment list
- **WHEN** authenticated user requests comment list
- **THEN** each comment includes user_liked boolean field
- **AND** user_liked is true if current user has liked that comment

### Requirement: Content Moderation
The system SHALL filter inappropriate content from comments.

#### Scenario: Profanity filter
- **WHEN** user submits comment containing profanity or offensive words
- **THEN** system rejects comment with 400 Bad Request error
- **AND** error message indicates content violates community guidelines

#### Scenario: Spam prevention
- **WHEN** user posts more than 10 comments within 1 minute
- **THEN** system rate-limits user
- **AND** returns 429 Too Many Requests error
- **AND** error message indicates rate limit exceeded

#### Scenario: Content length validation
- **WHEN** user submits comment longer than 2000 characters
- **THEN** system returns 400 Bad Request error
- **AND** error message indicates maximum length exceeded

### Requirement: Comment Deletion
The system SHALL allow users to delete their own comments (soft delete).

#### Scenario: Delete own comment
- **WHEN** authenticated user deletes their own comment
- **THEN** system sets is_deleted flag to true
- **AND** does not physically delete comment from database
- **AND** comment no longer appears in public comment lists

#### Scenario: Delete comment with replies
- **WHEN** user deletes comment that has replies
- **THEN** system soft-deletes parent comment
- **AND** replies remain visible
- **AND** parent comment shows as "[deleted]" with price_at_comment still visible

#### Scenario: Prevent deleting others' comments
- **WHEN** user attempts to delete another user's comment
- **THEN** system returns 403 Forbidden error
- **AND** comment is not deleted

### Requirement: Price Context Display
The system SHALL prominently display the price at comment time to provide historical context.

#### Scenario: Price badge display
- **WHEN** client renders comment in UI
- **THEN** price_at_comment is displayed in prominent badge
- **AND** badge shows "评论时价格: $2658.50" format
- **AND** badge is visually distinct from comment content

#### Scenario: Price comparison
- **WHEN** client displays comment with price_at_comment
- **THEN** client can compare price_at_comment with current price
- **AND** show price change since comment (e.g., "+$10.20 (+0.38%)")
- **AND** use color coding (green for increase, red for decrease)

### Requirement: Comment Notifications
The system SHALL notify users when their comments receive replies or likes.

#### Scenario: Reply notification
- **WHEN** user A replies to user B's comment
- **THEN** system creates notification for user B
- **AND** notification includes reply content and link to comment thread
- **NOTE**: Notification delivery is handled by realtime-updates capability

#### Scenario: Like notification (optional)
- **WHEN** user A likes user B's comment
- **THEN** system optionally creates notification for user B
- **AND** notification includes liker's username and comment preview
- **NOTE**: This may be disabled to reduce notification noise

