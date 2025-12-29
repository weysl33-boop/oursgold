# Spec: Accessibility

## ADDED Requirements

### Requirement: MUST provide semantic labels for interactive elements
The app MUST provide descriptive semantic labels for all interactive elements to support screen readers.

#### Scenario: Blind user navigates the app with TalkBack
- **Given** a blind user has TalkBack enabled on Android
- **When** they swipe through the home screen
- **Then** each market card announces its content (e.g., "伦敦金，价格2658.50，上涨1.08%")
- **And** all buttons announce their action (e.g., "搜索市场品种")
- **And** the user can navigate the entire app with audio feedback

**Acceptance Criteria**:
- All interactive widgets wrapped in Semantics with descriptive labels
- Labels describe both content and action (e.g., "查看黄金详情")
- Labels are in Chinese (matching UI language)
- Grouped elements use `Semantics(container: true)` appropriately
- Tested with TalkBack (Android) and VoiceOver (iOS)

---

### Requirement: MUST ensure minimum touch target size
The app MUST ensure all interactive elements have minimum touch target size of 48dp × 48dp for comfortable tapping.

#### Scenario: User with motor impairments taps small icons
- **Given** a user with reduced dexterity
- **When** they attempt to tap icon buttons in the app bar
- **Then** they can successfully tap the button without missing
- **And** no accidental taps occur on adjacent elements

**Acceptance Criteria**:
- All buttons: minimum 48dp × 48dp
- All icons: 48dp × 48dp touch area (icon + padding)
- All checkboxes/radio buttons: 48dp × 48dp
- List items: minimum height 48dp
- Touch targets verified programmatically in widget tests

---

### Requirement: MUST meet WCAG AA color contrast
The app MUST meet WCAG AA color contrast requirements (4.5:1 for text, 3:1 for UI components).

#### Scenario: User with low vision reads text on colored backgrounds
- **Given** a user with reduced color perception
- **When** they view text on gold background
- **Then** the text is clearly readable with sufficient contrast
- **And** all text meets WCAG AA standards (4.5:1 ratio)

**Acceptance Criteria**:
- All text contrasts verified against backgrounds
- Normal text (< 18pt): ≥ 4.5:1 contrast ratio
- Large text (≥ 18pt): ≥ 3:1 contrast ratio
- UI components (buttons, borders): ≥ 3:1 contrast ratio
- Automated contrast testing in test suite
- Verified with color contrast analyzers

---

### Requirement: MUST support dynamic font scaling
The app MUST support dynamic font scaling to respect user's system font size preferences.

#### Scenario: Elderly user increases system font size
- **Given** a user has set large font size in system settings
- **When** they open the app
- **Then** all text scales proportionally to the system setting
- **And** layouts adapt without text clipping or overflow
- **And** the UI remains usable at all font scale factors (0.8x to 2.0x)

**Acceptance Criteria**:
- All text respects `MediaQuery.textScaler`
- Layouts adapt to larger text without overflow
- No hardcoded font sizes (all use typography tokens)
- Tested at font scales: 1.0x, 1.5x, 2.0x
- No `Text` widgets with `textScaleFactor` override (unless necessary)

---

### Requirement: MUST support keyboard navigation
The app MUST support keyboard navigation for all interactive elements when using external keyboard.

#### Scenario: User navigates with Bluetooth keyboard
- **Given** a user with external keyboard connected to tablet
- **When** they press Tab key
- **Then** focus moves to the next interactive element
- **And** focused element has visible focus indicator
- **And** Enter/Space activates the focused element

**Acceptance Criteria**:
- All interactive elements are focusable
- Tab order is logical (top-to-bottom, left-to-right)
- Focused elements have visible indicator (border/highlight)
- Enter/Space keys activate focused buttons/links
- Escape key dismisses modals/bottom sheets

---

### Requirement: MUST provide haptic feedback for accessibility
The app MUST provide haptic feedback to assist users with visual or auditory impairments.

#### Scenario: Deaf user receives tactile confirmation
- **Given** a deaf user who relies on visual and tactile feedback
- **When** they tap a button
- **Then** they receive haptic vibration confirming the action
- **And** they can distinguish different actions by haptic intensity

**Acceptance Criteria**:
- Important actions trigger appropriate haptic feedback
- Light impact: Standard button taps
- Medium impact: Navigation changes
- Heavy impact: Destructive actions (future)
- Haptic feedback respects system accessibility settings
- Toggleable in app settings for user preference

---

### Requirement: MUST provide accessible error messages
The app MUST provide clear, accessible error messages that are announced by screen readers.

#### Scenario: User encounters form validation error
- **Given** a user submits a form with invalid input
- **When** the error message appears
- **Then** the screen reader announces the error immediately
- **And** the error message is visually clear with sufficient contrast
- **And** the user can easily identify and correct the error

**Acceptance Criteria**:
- Error messages wrapped in `Semantics(liveRegion: true)`
- Error text color meets contrast requirements (error red on white)
- Error messages are descriptive and actionable
- Focus moves to first error field automatically
- Error icons have semantic labels
