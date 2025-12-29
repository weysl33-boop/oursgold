# Spec: Motion Design

## ADDED Requirements

### Requirement: MUST use declarative animation system
The app MUST use a declarative animation system (flutter_animate) for all UI animations instead of manual AnimationController management.

#### Scenario: Developer adds entrance animation to a widget
- **Given** a new widget is being added to the screen
- **When** the developer uses `.animate().fadeIn()` on the widget
- **Then** the widget fades in smoothly over 300ms
- **And** no manual AnimationController or dispose logic is required

**Acceptance Criteria**:
- flutter_animate package integrated (^4.5.0)
- All animations use declarative `.animate()` syntax
- No manual AnimationController management for simple animations
- Animation code is readable and maintainable

---

### Requirement: MUST implement smooth page transitions
The app MUST implement smooth page transitions for navigation between screens with appropriate animation direction and timing.

#### Scenario: User navigates from Home to Detail page
- **Given** user taps a market card on the home screen
- **When** the detail page opens
- **Then** the page slides in from the right with fade effect
- **And** the transition completes in 300ms with easeOut curve
- **And** the back navigation reverses the animation

**Acceptance Criteria**:
- Forward navigation: Slide from right + fade (300ms, easeOut)
- Back navigation: Slide to right + fade (300ms, easeIn)
- Modal presentation: Slide from bottom + fade (300ms, easeOut)
- Tab switches: Cross-fade only (250ms, easeInOut)

---

### Requirement: MUST animate lists with staggered timing
The app MUST animate list items with staggered timing to create a cascading entrance effect.

#### Scenario: User views a list of quotes
- **Given** the quotes page is loading
- **When** quote items appear
- **Then** each item fades and slides in with 50ms delay between items
- **And** the staggered effect creates a smooth cascading appearance

**Acceptance Criteria**:
- List items fade + slide with staggered delay (50ms per item)
- Maximum stagger delay: 500ms (cap at 10 items)
- Animation curve: easeOut
- Animation duration: 300ms per item

---

### Requirement: MUST provide micro-interaction feedback
The app MUST provide tactile feedback through subtle animations for all interactive elements (buttons, cards, toggles).

#### Scenario: User taps a button
- **Given** user presses a button
- **When** the button is pressed down
- **Then** the button scales down to 0.95 with 100ms duration
- **And** the button returns to scale 1.0 on release
- **And** haptic feedback is triggered (light impact)

**Acceptance Criteria**:
- Button press: Scale to 0.95 (100ms, easeInOut) + light haptic
- Card tap: Scale to 0.98 (150ms, easeInOut) + light haptic
- Toggle switch: Smooth transition (200ms, easeInOut) + selection haptic
- All micro-interactions complete in < 200ms

---

### Requirement: MUST display shimmer skeleton loaders
The app MUST display shimmer skeleton loaders for content loading states instead of circular progress indicators.

#### Scenario: User opens quotes page while data is loading
- **Given** quote data is being fetched from API
- **When** the quotes page renders
- **Then** skeleton placeholders with shimmer effect appear
- **And** the shimmer animates continuously until data loads
- **And** content fades in smoothly when data arrives

**Acceptance Criteria**:
- Shimmer package integrated (^3.0.0)
- Skeleton loaders created for MarketCard, QuoteItem, NewsItem
- Shimmer colors match theme (light/dark)
- Smooth cross-fade from skeleton to real content (300ms)

---

### Requirement: MUST provide haptic feedback
The app MUST provide haptic feedback for important user actions to enhance tactile experience.

#### Scenario: User switches tabs in bottom navigation
- **Given** user taps a different tab
- **When** the tab switches
- **Then** medium impact haptic feedback is triggered
- **And** the tactile feedback confirms the navigation change

**Acceptance Criteria**:
- Light impact: Button taps, list item taps
- Medium impact: Tab switches, page navigation
- Heavy impact: Important actions (future: delete, submit)
- Selection click: Toggle switches, picker changes
- Haptic feedback is toggleable in Profile settings

---

### Requirement: MUST maintain 60fps animation performance
The app MUST maintain 60fps during all animations without dropped frames or jank.

#### Scenario: Developer implements complex animation
- **Given** a complex animation with multiple effects
- **When** the animation is running on a mid-range device
- **Then** the frame rate stays at 60fps (16ms per frame)
- **And** no frames are dropped during the animation

**Acceptance Criteria**:
- All animations maintain 60fps on target devices
- `RepaintBoundary` used for complex animated widgets
- Avoid animating Opacity directly (use AnimatedOpacity/FadeTransition)
- Animation performance verified with Flutter DevTools Timeline
- Respect `AccessibilityFeatures.disableAnimations` setting
