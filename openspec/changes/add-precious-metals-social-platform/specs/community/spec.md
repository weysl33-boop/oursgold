# Community Features Capability

## ADDED Requirements

### Requirement: Hot Topics Ranking
The system SHALL aggregate and rank trending discussion topics based on engagement metrics.

#### Scenario: Calculate hot topics
- **WHEN** system calculates hot topics ranking
- **THEN** topics are ranked by heat_score = (discussion_count * 0.6) + (recent_activity * 0.4)
- **AND** discussion_count is number of comments with topic hashtag in last 24 hours
- **AND** recent_activity is weighted by recency (comments in last hour weighted higher)

#### Scenario: Get hot topics list
- **WHEN** client requests hot topics
- **THEN** system returns top 10 topics sorted by heat_score descending
- **AND** each topic includes hashtag, discussion_count, heat_score, trending_rank

#### Scenario: Topic extraction from comments
- **WHEN** user posts comment containing "#黄金突破2660#"
- **THEN** system extracts hashtag and associates comment with topic
- **AND** increments discussion_count for that topic

### Requirement: Trending Symbols
The system SHALL identify and display symbols with highest user engagement.

#### Scenario: Calculate trending symbols
- **WHEN** system calculates trending symbols
- **THEN** symbols are ranked by engagement_score = comment_count + (prediction_count * 2) + (vote_count * 0.5)
- **AND** metrics are calculated for last 24 hours
- **AND** only active symbols with engagement_score > 10 are included

#### Scenario: Get trending symbols
- **WHEN** client requests trending symbols
- **THEN** system returns top 5 symbols sorted by engagement_score descending
- **AND** each symbol includes current price, change_percent, mini chart data, engagement metrics

### Requirement: Top Comments
The system SHALL surface high-quality comments based on likes and engagement.

#### Scenario: Calculate top comments
- **WHEN** system calculates top comments
- **THEN** comments are ranked by engagement_score = likes_count + (replies_count * 2)
- **AND** only comments from last 7 days are considered
- **AND** deleted comments are excluded

#### Scenario: Get top comments
- **WHEN** client requests top comments
- **THEN** system returns top 20 comments sorted by engagement_score descending
- **AND** each comment includes full user info, content, price_at_comment, likes_count, replies_count
- **AND** comments span multiple symbols (not filtered by symbol)

### Requirement: Prediction Leaderboards
The system SHALL maintain multiple leaderboards ranking users by prediction performance.

#### Scenario: Accuracy leaderboard
- **WHEN** client requests leaderboard with type="accuracy"
- **THEN** system returns top 50 users sorted by accuracy_rate descending
- **AND** only users with total_participations >= 10 are included
- **AND** each entry includes rank, user info, accuracy_rate, total_participations, rank_title

#### Scenario: Points leaderboard
- **WHEN** client requests leaderboard with type="score"
- **THEN** system returns top 50 users sorted by prediction_score descending
- **AND** each entry includes rank, user info, prediction_score, total_predictions, total_participations

#### Scenario: Streak leaderboard
- **WHEN** client requests leaderboard with type="streak"
- **THEN** system returns top 50 users sorted by current_streak descending
- **AND** only users with current_streak >= 3 are included
- **AND** each entry includes rank, user info, current_streak, max_streak

#### Scenario: Activity leaderboard
- **WHEN** client requests leaderboard with type="active"
- **THEN** system returns top 50 users sorted by total_participations descending
- **AND** metrics are from last 30 days
- **AND** each entry includes rank, user info, total_participations, predictions_created

#### Scenario: Leaderboard caching
- **WHEN** system calculates leaderboards
- **THEN** results are cached in Redis with 5-minute TTL
- **AND** subsequent requests within 5 minutes serve cached data
- **AND** cache is invalidated when prediction is verified

### Requirement: User Profile Stats
The system SHALL provide comprehensive prediction statistics for each user.

#### Scenario: Get user prediction stats
- **WHEN** client requests prediction stats for user
- **THEN** system returns user_prediction_stats record
- **AND** includes total_predictions, total_participations, correct_count, accuracy_rate
- **AND** includes current_streak, max_streak, prediction_score, rank_title

#### Scenario: Get user prediction history
- **WHEN** client requests user's prediction history
- **THEN** system returns paginated list of predictions user created
- **AND** includes prediction status, participants_count, correct_option (if completed)

#### Scenario: Get user voting history
- **WHEN** client requests user's voting history
- **THEN** system returns paginated list of predictions user voted on
- **AND** includes user's selected_option, is_correct status, prediction question

#### Scenario: Recent prediction display
- **WHEN** displaying user in leaderboard
- **THEN** includes most recent prediction with result
- **AND** shows whether prediction was correct or incorrect
- **AND** shows prediction question preview

### Requirement: Community Engagement Metrics
The system SHALL track and display overall community engagement statistics.

#### Scenario: Get community stats
- **WHEN** client requests community statistics
- **THEN** system returns total_users, total_comments, total_predictions, total_votes
- **AND** includes metrics for last 24 hours (new_comments, new_predictions, new_votes)

#### Scenario: Active users count
- **WHEN** calculating active users
- **THEN** system counts users who posted comment, created prediction, or voted in last 24 hours
- **AND** returns active_users_24h count

### Requirement: User Following (Future Enhancement)
The system SHALL support user following to enable personalized feeds.

#### Scenario: Follow user
- **WHEN** authenticated user follows another user
- **THEN** system creates follow relationship record
- **AND** increments followers_count on followed user
- **AND** increments following_count on current user
- **NOTE**: This is planned for post-MVP

#### Scenario: Get followed users' predictions
- **WHEN** user requests personalized feed
- **THEN** system returns predictions and comments from followed users
- **AND** sorted by recency
- **NOTE**: This is planned for post-MVP

### Requirement: Community Guidelines Enforcement
The system SHALL enforce community guidelines and content policies.

#### Scenario: Report inappropriate content
- **WHEN** user reports comment or prediction as inappropriate
- **THEN** system creates report record with reason
- **AND** flags content for moderator review
- **NOTE**: Moderation interface is post-MVP

#### Scenario: User reputation score
- **WHEN** calculating user reputation
- **THEN** system considers prediction accuracy, helpful comments (likes), reports against user
- **AND** users with low reputation may have limited privileges
- **NOTE**: This is planned for post-MVP

