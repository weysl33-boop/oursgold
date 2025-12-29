# Spec: Visual Refinements

## ADDED Requirements

### Requirement: MUST display enhanced market cards
The app MUST display market cards with depth, shadows, and visual polish using design tokens and consistent styling.

#### Scenario: User views market overview on home page
- **Given** the home page displays 6 market cards
- **When** the cards render
- **Then** each card has subtle shadow for depth (elevation 2)
- **And** cards use consistent border radius (12dp)
- **And** price colors follow red-up/green-down convention
- **And** cards have smooth entrance animation (fade + slide)

**Acceptance Criteria**:
- Cards use `AppDesignTokens.radiusMd` for border radius
- Cards use elevation 2 with 8% opacity black shadow
- Price change displays with arrow icon + percentage
- Mini trend indicator shows visual direction
- Entrance animation: 300ms fade + slide from bottom
- Symbol badge uses gold theme color with 10% opacity background

---

### Requirement: MUST implement glassmorphism for dark mode
The app MUST implement glassmorphism effect for cards in dark mode to create premium visual appearance.

#### Scenario: User switches to dark mode
- **Given** user enables dark mode in profile settings
- **When** they view cards and containers
- **Then** cards display frosted glass effect with backdrop blur
- **And** cards have subtle gradient and semi-transparent border
- **And** the effect creates sense of depth and layering

**Acceptance Criteria**:
- Dark mode cards use `BackdropFilter` with blur (sigmaX: 10, sigmaY: 10)
- Gradient overlay: white 15% opacity to 5% opacity
- Border: white 10% opacity, 1px width
- Light mode uses standard solid cards (no glassmorphism)
- Border radius consistent with design tokens (12dp)

---

### Requirement: MUST implement clear typography hierarchy
The app MUST implement clear typography hierarchy with appropriate font sizes, weights, and line heights.

#### Scenario: User scans news article content
- **Given** user opens a news detail page
- **When** they scan the content
- **Then** the headline is clearly largest and boldest
- **And** body text is comfortable to read (16px, line height 1.5)
- **And** captions and metadata are visually de-emphasized
- **And** the hierarchy guides their eye through the content

**Acceptance Criteria**:
- Headings use semibold (600) or bold (700) weights
- Body text uses regular (400) weight, 14-16px size
- Line heights: 1.2 (headings), 1.5 (body), 1.4 (captions)
- Color hierarchy: primary text (neutral900), secondary (neutral600)
- All text uses typography tokens (no inline sizes/weights)

---

### Requirement: MUST use extended color palette
The app MUST use extended color palette with appropriate tints, shades, and semantic colors throughout the UI.

#### Scenario: User interacts with buttons and states
- **Given** user hovers or presses interactive elements
- **When** the state changes (normal → hover → pressed)
- **Then** the color transitions smoothly through palette shades
- **And** hover state uses darker shade (e.g., gold500 → gold600)
- **And** pressed state uses even darker shade (gold600 → gold700)

**Acceptance Criteria**:
- Normal state: gold500 (primary color)
- Hover state: gold600 (one shade darker)
- Pressed state: gold700 (two shades darker)
- Disabled state: neutral300 (light gray)
- Semantic colors used for status (success green, error red, etc.)

---

### Requirement: MUST implement custom pull-to-refresh
The app MUST implement custom pull-to-refresh indicator matching the gold theme instead of default platform indicator.

#### Scenario: User pulls down to refresh quotes page
- **Given** user is on quotes page with stale data
- **When** they pull down to trigger refresh
- **Then** a gold-colored circular indicator appears
- **And** the indicator animates smoothly during loading
- **And** the indicator matches the app's visual identity

**Acceptance Criteria**:
- Indicator color: gold500 (primary color)
- Indicator background: white (light mode), dark surface (dark mode)
- Stroke width: 3.0
- Displacement: 40.0 from top
- Smooth animation during pull and refresh
- Consistent across all pages with pull-to-refresh

---

### Requirement: MUST display friendly empty states
The app MUST display friendly empty states with illustrations when no content is available.

#### Scenario: User searches for non-existent symbol
- **Given** user searches for a symbol with no results
- **When** the search returns empty
- **Then** an empty state illustration appears
- **And** a helpful message guides the user (e.g., "未找到相关品种")
- **And** a call-to-action button offers next steps

**Acceptance Criteria**:
- Empty states for: search results, news list (no articles), favorites (none added)
- Illustrations use Lottie animations (free assets from LottieFiles)
- Message text is descriptive and helpful
- CTA button provides logical next action (e.g., "浏览热门品种")
- Empty states respect theme (light/dark)

---

### Requirement: MUST enhance input field styling
The app MUST style input fields with clear focus states, borders, and accessibility features.

#### Scenario: User types in search field
- **Given** user taps search field
- **When** the field receives focus
- **Then** the border changes to gold color
- **And** the border width increases slightly (1px → 2px)
- **And** the field has subtle shadow for depth

**Acceptance Criteria**:
- Unfocused: neutral300 border, 1px width
- Focused: gold500 border, 2px width
- Error state: error red border, 2px width
- Border radius: 8dp (radiusSm)
- Fill color: neutral100 (light mode), neutral800 (dark mode)
- Label color: neutral600 → gold500 on focus

---

### Requirement: MUST use consistent icon system
The app MUST use consistent icon sizes, colors, and styling across all screens.

#### Scenario: Developer adds new icon button
- **Given** developer is adding an icon to app bar
- **When** they use Material Icons
- **Then** the icon size matches other app bar icons (24dp)
- **And** the icon color matches theme foreground color
- **And** the touch target is 48dp × 48dp minimum

**Acceptance Criteria**:
- Icon sizes: 16dp (inline), 20dp (small), 24dp (standard), 32dp (large)
- Icon colors: inherit from theme or explicit semantic color
- All icons have 48dp touch targets (with padding if needed)
- Icons use outlined style by default (e.g., `Icons.search_outlined`)
- Active/selected icons use filled style (e.g., `Icons.search`)
