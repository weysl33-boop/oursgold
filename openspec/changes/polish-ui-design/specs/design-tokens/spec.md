# Spec: Design Tokens

## ADDED Requirements

### Requirement: MUST provide centralized design token system
The app MUST provide a centralized design token system that defines all spacing, typography, color, and layout values used throughout the UI.

#### Scenario: Developer creates a new card component
- **Given** a developer is implementing a new card widget
- **When** they need to set border radius, padding, and colors
- **Then** they must use values from `AppDesignTokens` instead of hardcoded values
- **And** the component automatically inherits the consistent design language

**Acceptance Criteria**:
- All spacing values follow 8pt grid system (4, 8, 12, 16, 24, 32, 48, 64)
- No magic numbers in widget code (all values come from tokens)
- Design tokens are documented with usage guidelines
- Theme switching (light/dark) uses token system

---

### Requirement: MUST implement 8pt grid spacing system
The app MUST implement an 8pt grid spacing system with named constants for all spacing values.

#### Scenario: Developer adds padding to a container
- **Given** a developer needs to add padding to a widget
- **When** they use `AppDesignTokens.space4` (16dp)
- **Then** the padding matches the spacing scale used across the app
- **And** the component aligns with other components on the same grid

**Acceptance Criteria**:
- Spacing scale includes: 0, 4, 8, 12, 16, 20, 24, 32, 48, 64 pixels
- All widgets use spacing tokens (no inline pixel values)
- Consistent vertical rhythm across all screens
- Spacing is responsive and works on all screen sizes

---

### Requirement: MUST implement typography scale system
The app MUST implement a type scale with predefined font sizes, weights, and line heights for all text elements.

#### Scenario: Designer wants consistent heading sizes
- **Given** multiple screens with different heading levels
- **When** developers use `AppTypography.headlineH1`, `headlineH2`, etc.
- **Then** all headings of the same level have identical size, weight, and line height
- **And** the type hierarchy is visually clear and consistent

**Acceptance Criteria**:
- Font sizes: 10, 12, 14, 16, 18, 20, 24, 32 pixels
- Font weights: regular (400), medium (500), semibold (600), bold (700)
- Line heights: 1.2 (headings), 1.5 (body), 1.4 (captions)
- All text uses typography tokens (no inline TextStyle)

---

### Requirement: MUST provide extended color palette
The app MUST provide an extended color palette with tints and shades (50-900 scale) for primary and neutral colors.

#### Scenario: Developer needs a hover state color
- **Given** a developer is implementing a button hover state
- **When** they use `AppColors.gold600` (darker shade)
- **Then** the hover color is visually darker than the default `gold500`
- **And** the color maintains sufficient contrast for accessibility

**Acceptance Criteria**:
- Gold palette: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900
- Neutral palette: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900
- Semantic colors: success, error, warning, info (with variants)
- All colors pass WCAG AA contrast requirements for their usage

---

### Requirement: MUST provide border radius constants
The app MUST provide predefined border radius values for consistent rounded corners across all components.

#### Scenario: Developer creates a rounded card
- **Given** a developer is styling a card component
- **When** they use `AppDesignTokens.radiusMd` (12dp)
- **Then** the card border radius matches other cards in the app
- **And** the visual consistency creates a cohesive design language

**Acceptance Criteria**:
- Radius scale: xs (4), sm (8), md (12), lg (16), xl (24), full (9999)
- All Cards use `radiusMd` by default
- All Buttons use `radiusSm` by default
- All InputFields use `radiusSm` by default

---

### Requirement: MUST define elevation scale
The app MUST define a consistent elevation scale for shadows and depth across all elevated components.

#### Scenario: User interacts with stacked UI elements
- **Given** multiple overlapping UI elements (cards, modals, FAB)
- **When** elements are rendered with elevation tokens
- **Then** the visual hierarchy clearly indicates layering
- **And** shadows are subtle and consistent across platforms

**Acceptance Criteria**:
- Elevation scale: 0, 1, 2, 4, 8, 16
- Cards use elevation 2 by default
- Modals and bottom sheets use elevation 8
- FAB (if added) uses elevation 4
- Elevation respects theme (subtle in dark mode)
