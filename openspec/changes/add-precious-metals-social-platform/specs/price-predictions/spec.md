# Price Prediction Voting Capability

## ADDED Requirements

### Requirement: Prediction Creation
The system SHALL allow users to create price predictions with ABCD multiple-choice options and automatic price capture.

#### Scenario: Create prediction with 4 options
- **WHEN** authenticated user creates prediction for symbol "XAUUSD" with question "今晚8点前黄金价格走势如何？"
- **AND** provides 4 options: A="涨超1%", B="小幅上涨", C="横盘整理", D="下跌"
- **AND** sets verify_time to "2025-12-27T20:00:00Z"
- **THEN** system fetches current price for "XAUUSD" and stores as price_at_create
- **AND** creates prediction record with status="active"
- **AND** returns created prediction with all fields

#### Scenario: Create prediction with 2 options
- **WHEN** user creates prediction with only 2 options (A and B)
- **THEN** system accepts prediction
- **AND** stores options as JSONB array with 2 elements

#### Scenario: Reject prediction with 1 option
- **WHEN** user attempts to create prediction with only 1 option
- **THEN** system returns 400 Bad Request error
- **AND** error message indicates "Predictions must have 2-4 options"

#### Scenario: Reject prediction with >4 options
- **WHEN** user attempts to create prediction with 5 or more options
- **THEN** system returns 400 Bad Request error
- **AND** error message indicates "Predictions cannot have more than 4 options"

#### Scenario: Verify time validation
- **WHEN** user sets verify_time in the past
- **THEN** system returns 400 Bad Request error
- **AND** error message indicates "Verify time must be in the future"

### Requirement: Prediction Voting
The system SHALL allow users to vote on active predictions with automatic price capture.

#### Scenario: Vote on prediction
- **WHEN** authenticated user votes on active prediction by selecting option "A"
- **THEN** system fetches current price and stores as price_at_vote
- **AND** creates vote record (prediction_id, user_id, selected_option, price_at_vote)
- **AND** increments participants_count on prediction
- **AND** returns vote confirmation with current vote distribution

#### Scenario: Prevent duplicate voting
- **WHEN** user attempts to vote on same prediction twice
- **THEN** system returns 400 Bad Request error
- **AND** error message indicates "You have already voted on this prediction"
- **AND** does not create duplicate vote

#### Scenario: Vote on ended prediction
- **WHEN** user attempts to vote on prediction with status="completed"
- **THEN** system returns 400 Bad Request error
- **AND** error message indicates "This prediction has ended"

#### Scenario: Vote distribution calculation
- **WHEN** user votes on prediction
- **THEN** system calculates vote distribution for all options
- **AND** returns percentages (e.g., A=35%, B=15%, C=30%, D=20%)
- **AND** percentages sum to 100%

### Requirement: Automatic Prediction Verification
The system SHALL automatically verify predictions at deadline by capturing price and determining correct answer.

#### Scenario: Automatic verification at deadline
- **WHEN** background task runs and finds prediction with verify_time <= current time
- **AND** prediction status is "active"
- **THEN** system fetches current price for prediction's symbol
- **AND** stores price as price_at_verify
- **AND** calculates price_change_percent = (price_at_verify - price_at_create) / price_at_create * 100
- **AND** evaluates verification rules to determine correct_option
- **AND** updates prediction status to "completed"

#### Scenario: Mark correct votes
- **WHEN** prediction is verified with correct_option="A"
- **THEN** system updates all votes where selected_option="A" with is_correct=true
- **AND** updates all other votes with is_correct=false

#### Scenario: Update user stats after verification
- **WHEN** prediction is verified
- **THEN** system recalculates prediction stats for all participants
- **AND** increments correct_count for users who voted correctly
- **AND** updates accuracy_rate = correct_count / total_participations * 100
- **AND** updates current_streak (increments if correct, resets to 0 if incorrect)

#### Scenario: Verification rule evaluation
- **WHEN** prediction has auto_verify_conditions: {"A": "price_change_percent >= 1.0", "B": "0 < price_change_percent < 1.0"}
- **AND** price_change_percent is 0.46%
- **THEN** system determines correct_option="B"

### Requirement: Prediction Retrieval
The system SHALL provide filtered and paginated prediction lists.

#### Scenario: Get active predictions
- **WHEN** client requests predictions with status="active"
- **THEN** system returns all predictions where status="active" and verify_time > current time
- **AND** predictions are sorted by verify_time ascending (soonest deadline first)

#### Scenario: Get completed predictions
- **WHEN** client requests predictions with status="completed"
- **THEN** system returns all predictions where status="completed"
- **AND** predictions are sorted by verify_time descending (most recently completed first)
- **AND** each prediction includes correct_option and price_at_verify

#### Scenario: Get predictions for symbol
- **WHEN** client requests predictions filtered by symbol_code="XAUUSD"
- **THEN** system returns only predictions for that symbol
- **AND** includes both active and completed predictions

#### Scenario: Get user's predictions
- **WHEN** client requests predictions created by specific user
- **THEN** system returns all predictions where user_id matches
- **AND** includes prediction status and results

#### Scenario: Get user's votes
- **WHEN** authenticated user requests their voting history
- **THEN** system returns all predictions user has voted on
- **AND** includes user's selected_option and is_correct status
- **AND** sorted by voted_at descending

### Requirement: Prediction Details
The system SHALL provide detailed prediction information including vote distribution and time remaining.

#### Scenario: Get prediction details
- **WHEN** client requests specific prediction by ID
- **THEN** system returns full prediction data
- **AND** includes vote distribution with counts and percentages
- **AND** includes participants_count
- **AND** includes time_remaining in seconds (if active)

#### Scenario: User vote indication
- **WHEN** authenticated user requests prediction details
- **THEN** response includes user_voted boolean
- **AND** if user_voted is true, includes user's selected_option

#### Scenario: Countdown timer
- **WHEN** client displays active prediction
- **THEN** client calculates time_remaining = verify_time - current_time
- **AND** displays countdown in format "2:35:20" (hours:minutes:seconds)
- **AND** updates countdown every second

### Requirement: Prediction Accuracy Scoring
The system SHALL calculate and track user prediction accuracy and performance metrics.

#### Scenario: Calculate accuracy rate
- **WHEN** user has participated in 50 predictions and voted correctly on 35
- **THEN** accuracy_rate = 35 / 50 * 100 = 70.00%

#### Scenario: Track winning streak
- **WHEN** user votes correctly on 5 consecutive predictions
- **THEN** current_streak = 5
- **AND** if current_streak > max_streak, update max_streak = 5

#### Scenario: Reset streak on incorrect vote
- **WHEN** user votes incorrectly after streak of 5
- **THEN** current_streak resets to 0
- **AND** max_streak remains 5

#### Scenario: Prediction score calculation
- **WHEN** user creates prediction: +5 points
- **AND** user votes on prediction: +1 point
- **AND** user votes correctly: +10 points
- **AND** user has streak of 2: +5 bonus points
- **AND** user has streak of 3+: +10 bonus points per correct vote
- **AND** user creates prediction that reaches 100 participants: +20 bonus points
- **THEN** prediction_score accumulates all points

**Score Rules Summary:**
| 行为 | 积分 |
|------|------|
| 发起预测 | +5 |
| 参与投票 | +1 |
| 预测正确 | +10 |
| 预测错误 | +0 |
| 连续正确2次 | 额外+5 |
| 连续正确3次及以上 | 每次额外+10 |
| 发起的预测被100人参与 | 额外+20 |

#### Scenario: Rank title assignment
The system SHALL assign rank titles based on participation count and accuracy rate with 6 tiers:

- **WHEN** user has total_participations >= 200 and accuracy_rate >= 80%
- **THEN** rank_title = "预测宗师"

- **WHEN** user has total_participations >= 100 and accuracy_rate >= 75%
- **THEN** rank_title = "预测大师"

- **WHEN** user has total_participations >= 50 and accuracy_rate >= 70%
- **THEN** rank_title = "预测专家"

- **WHEN** user has total_participations >= 30 and accuracy_rate >= 60%
- **THEN** rank_title = "预测达人"

- **WHEN** user has total_participations >= 10 and accuracy_rate < 50%
- **THEN** rank_title = "预测爱好者"

- **WHEN** user has total_participations < 10
- **THEN** rank_title = "预测新手"

**Rank Title Summary Table:**
| 称号 | 参与次数要求 | 准确率要求 |
|------|-------------|-----------|
| 预测新手 | < 10 | - |
| 预测爱好者 | ≥ 10 | < 50% |
| 预测达人 | ≥ 30 | ≥ 60% |
| 预测专家 | ≥ 50 | ≥ 70% |
| 预测大师 | ≥ 100 | ≥ 75% |
| 预测宗师 | ≥ 200 | ≥ 80% |

### Requirement: Prediction Discussion
The system SHALL allow users to discuss predictions through comments.

#### Scenario: Comment on prediction
- **WHEN** user posts comment on prediction
- **THEN** system creates comment linked to prediction_id
- **AND** increments comments_count on prediction
- **AND** comment includes user's selected_option (if voted)
- **NOTE**: Comments use price-comments capability

#### Scenario: Show voter's choice in comments
- **WHEN** displaying comment on prediction
- **AND** commenter has voted on prediction
- **THEN** comment shows badge "选择了A" indicating their vote

### Requirement: Prediction Result Display
The system SHALL display prediction results with price change visualization after verification.

#### Scenario: Display verification result
- **WHEN** client displays completed prediction
- **THEN** shows price_at_create and price_at_verify
- **AND** shows price change amount and percentage
- **AND** shows visual chart of price movement from create to verify time
- **AND** highlights correct_option with checkmark

#### Scenario: Show correct voters
- **WHEN** client displays completed prediction
- **THEN** shows list of users who voted correctly
- **AND** shows percentage of users who voted correctly
- **AND** shows user's own result (correct/incorrect)

#### Scenario: Share prediction result
- **WHEN** user shares completed prediction
- **THEN** system generates shareable image with:
  - Prediction question
  - Price change visualization
  - Correct answer
  - User's vote result
  - User's accuracy stats

