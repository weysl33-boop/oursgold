# User Authentication Capability

## ADDED Requirements

### Requirement: User Registration
The system SHALL allow new users to create accounts with email and password.

#### Scenario: Successful registration
- **WHEN** user submits valid registration form with unique email, username, and strong password
- **THEN** system creates new user account
- **AND** password is hashed using bcrypt with salt rounds >= 12
- **AND** system returns JWT access token
- **AND** user is automatically logged in

#### Scenario: Duplicate email rejection
- **WHEN** user attempts to register with email that already exists
- **THEN** system returns 400 Bad Request error
- **AND** error message indicates email is already registered

#### Scenario: Duplicate username rejection
- **WHEN** user attempts to register with username that already exists
- **THEN** system returns 400 Bad Request error
- **AND** error message indicates username is already taken

#### Scenario: Weak password rejection
- **WHEN** user submits password shorter than 8 characters
- **THEN** system returns 400 Bad Request error
- **AND** error message indicates password requirements

### Requirement: User Login
The system SHALL authenticate users with email and password, issuing JWT tokens upon successful login.

#### Scenario: Successful login
- **WHEN** user submits correct email and password
- **THEN** system validates credentials
- **AND** returns JWT access token with 24-hour expiration
- **AND** token includes user_id and username in payload

#### Scenario: Invalid credentials
- **WHEN** user submits incorrect email or password
- **THEN** system returns 401 Unauthorized error
- **AND** error message does not reveal whether email or password was incorrect (security)

#### Scenario: Inactive account login attempt
- **WHEN** user with is_active=false attempts to login
- **THEN** system returns 403 Forbidden error
- **AND** error message indicates account is disabled

### Requirement: JWT Token Management
The system SHALL use JWT tokens for stateless authentication with appropriate security measures.

#### Scenario: Token generation
- **WHEN** user successfully logs in or registers
- **THEN** system generates JWT token with HS256 algorithm
- **AND** token payload includes user_id, username, and expiration (24 hours)
- **AND** token is signed with secret key from environment variable

#### Scenario: Token validation
- **WHEN** client makes request to protected endpoint with valid token
- **THEN** system validates token signature
- **AND** checks token expiration
- **AND** extracts user_id from payload
- **AND** allows request to proceed

#### Scenario: Expired token rejection
- **WHEN** client makes request with expired token
- **THEN** system returns 401 Unauthorized error
- **AND** error message indicates token has expired

#### Scenario: Invalid token rejection
- **WHEN** client makes request with malformed or invalid token
- **THEN** system returns 401 Unauthorized error
- **AND** error message indicates invalid token

### Requirement: User Profile Management
The system SHALL allow authenticated users to view and update their profile information.

#### Scenario: Get current user profile
- **WHEN** authenticated user requests their profile (GET /api/v1/auth/me)
- **THEN** system returns user data (id, username, email, avatar_url, created_at)
- **AND** does not return password_hash

#### Scenario: Update profile
- **WHEN** authenticated user updates their username or avatar_url
- **THEN** system validates new values
- **AND** updates user record in database
- **AND** returns updated user profile

#### Scenario: Email update restriction
- **WHEN** user attempts to update email address
- **THEN** system requires email verification (future enhancement)
- **OR** rejects email update in MVP (email is immutable)

### Requirement: Password Security
The system SHALL enforce strong password policies and secure password storage.

#### Scenario: Password hashing on registration
- **WHEN** user registers with password "SecurePass123!"
- **THEN** system hashes password using bcrypt
- **AND** stores only password_hash in database
- **AND** never stores plaintext password

#### Scenario: Password verification on login
- **WHEN** user logs in with password
- **THEN** system retrieves password_hash from database
- **AND** uses bcrypt to compare submitted password with hash
- **AND** grants access only if passwords match

#### Scenario: Password reset (future)
- **WHEN** user requests password reset
- **THEN** system sends reset link to registered email
- **AND** link expires after 1 hour
- **AND** allows user to set new password
- **NOTE**: This is planned for post-MVP

### Requirement: Session Management
The system SHALL manage user sessions securely without server-side session storage (stateless JWT).

#### Scenario: Stateless authentication
- **WHEN** user makes authenticated request
- **THEN** system validates JWT token
- **AND** does not query session store
- **AND** extracts user context from token payload

#### Scenario: Logout (client-side)
- **WHEN** user logs out
- **THEN** mobile app discards JWT token from secure storage
- **AND** user is redirected to login screen
- **NOTE**: Server-side token blacklist is not implemented in MVP

### Requirement: Authorization
The system SHALL enforce authorization rules for protected resources.

#### Scenario: Protect write endpoints
- **WHEN** unauthenticated user attempts to post comment
- **THEN** system returns 401 Unauthorized error
- **AND** does not process request

#### Scenario: User-specific resource access
- **WHEN** user attempts to update another user's profile
- **THEN** system returns 403 Forbidden error
- **AND** does not allow modification

#### Scenario: Public read access
- **WHEN** unauthenticated user requests public data (quotes, comments)
- **THEN** system allows read access
- **AND** does not require authentication for GET endpoints (except /auth/me)

### Requirement: User Preferences
The system SHALL allow users to customize app behavior through preferences.

#### Scenario: Get user preferences
- **WHEN** authenticated user requests preferences (GET /api/v1/users/me/preferences)
- **THEN** system returns user's current preferences
- **AND** includes all configurable settings with current values

#### Scenario: Update user preferences
- **WHEN** authenticated user updates preferences (PUT /api/v1/users/me/preferences)
- **THEN** system validates and saves new preference values
- **AND** returns updated preferences

#### Scenario: Price color preference
- **WHEN** user sets price_color_scheme to "red_up_green_down" (红涨绿跌 - China style)
- **THEN** price increases display in red, decreases in green
- **WHEN** user sets price_color_scheme to "green_up_red_down" (绿涨红跌 - International style)
- **THEN** price increases display in green, decreases in red
- **AND** default is "green_up_red_down"

#### Scenario: Language preference
- **WHEN** user sets language to "zh_CN" or "en_US"
- **THEN** app displays content in selected language
- **AND** default is "zh_CN"

#### Scenario: Notification preferences
- **WHEN** user configures notification settings
- **THEN** user can enable/disable:
  - prediction_results: Notify when predictions are verified
  - comment_replies: Notify when someone replies to comments
  - comment_likes: Notify when comments receive likes (optional)
  - price_alerts: Notify on significant price movements (future)
- **AND** each setting can be individually toggled

#### Scenario: Preferences API response
- **Endpoint**: `GET /api/v1/users/me/preferences`
- **Response**:
```json
{
  "price_color_scheme": "green_up_red_down",
  "language": "zh_CN",
  "notifications": {
    "prediction_results": true,
    "comment_replies": true,
    "comment_likes": false,
    "price_alerts": true
  },
  "updated_at": "2025-12-27T10:00:00Z"
}
```

#### Scenario: Preferences database schema
```sql
CREATE TABLE user_preferences (
    user_id UUID PRIMARY KEY REFERENCES users(id),
    price_color_scheme VARCHAR(20) DEFAULT 'green_up_red_down',
    language VARCHAR(10) DEFAULT 'zh_CN',
    notify_prediction_results BOOLEAN DEFAULT TRUE,
    notify_comment_replies BOOLEAN DEFAULT TRUE,
    notify_comment_likes BOOLEAN DEFAULT FALSE,
    notify_price_alerts BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

