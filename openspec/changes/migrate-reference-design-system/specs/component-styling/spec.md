# Spec: Component Styling

## Capability
Provide styled Flutter widgets that match the visual appearance of components in the reference Next.js project, including market/stock cards, bottom navigation, headers, and list items, while maintaining Flutter best practices and mobile UX patterns.

## ADDED Requirements

### Requirement: Market Card Component Styling
The MarketCard widget SHALL be styled to match the reference project's StockCard component, including layout, colors, typography, spacing, and visual effects.

#### Scenario: Market Card Visual Structure
**Given** a market quote is displayed in a MarketCard
**When** the card is rendered
**Then** the card SHALL have rounded corners (radiusMd = 12dp matching rounded-2xl)
**And** the card SHALL use bg-gray-50 equivalent color (AppColors.neutral50) in light mode
**And** padding SHALL be 16dp (matching p-4 from reference)
**And** the card SHALL contain logo, symbol name, price, and change information

#### Scenario: Market Card Logo Presentation
**Given** a MarketCard displays a symbol logo
**When** the logo container is rendered
**Then** the container SHALL be 40x40 dp (matching w-10 h-10)
**And** the container SHALL have white background
**And** the container SHALL have rounded corners (radiusMd = 12dp matching rounded-xl)
**And** the container SHALL have subtle shadow (matching shadow-sm)
**And** the logo text SHALL be bold and appropriately sized

#### Scenario: Market Card Price Display
**Given** a MarketCard shows price information
**When** the price changes
**Then** the price SHALL be displayed prominently with price typography style
**And** positive changes SHALL use priceUpRed color (Chinese convention)
**And** negative changes SHALL use priceDownGreen color (Chinese convention)
**And** change percentage SHALL be shown with arrow icon (up/down)
**And** a trend indicator SHALL be displayed with appropriate color

#### Scenario: Market Card Dark Mode
**Given** the app is in dark mode
**When** a MarketCard is rendered
**Then** the card MAY use glassmorphic background effect
**And** the card SHALL maintain visual hierarchy
**And** all text SHALL remain legible (meeting WCAG AA contrast)
**And** the logo container SHALL still have white background for contrast

### Requirement: Bottom Navigation Styling
The BottomNavShell widget SHALL be styled to match the reference project's BottomNav component, including layout, colors, spacing, and safe area handling.

#### Scenario: Bottom Navigation Visual Structure
**Given** the bottom navigation is displayed
**When** navigation is rendered
**Then** the background SHALL be white in light mode
**And** a top border SHALL be present (border-gray-100 equivalent)
**And** horizontal padding SHALL be 24dp (matching px-6)
**And** vertical padding SHALL be 12dp (matching py-3)
**And** safe area bottom padding SHALL be applied

#### Scenario: Navigation Item Styling
**Given** the bottom navigation has 5 items (Home, Portfolio, Exchange, Markets, Profile)
**When** navigation items are displayed
**Then** each item SHALL display an icon and label vertically
**And** active items SHALL use blue-600 equivalent color for icon and text
**And** inactive items SHALL use gray-400 equivalent color
**And** spacing between icon and label SHALL be 4dp (gap-1)
**And** minimum touch target SHALL be 48dp

#### Scenario: Home Indicator Bar
**Given** the bottom navigation is rendered on a device with gesture navigation
**When** the navigation bar is displayed
**Then** a home indicator bar SHALL be shown centered
**And** the bar SHALL be approximately 128dp wide (w-32)
**And** the bar SHALL be 4dp high (h-1)
**And** the bar SHALL have rounded ends (rounded-full)
**And** the bar SHALL use black color (adjustable for theme)

### Requirement: Header and Balance Card Styling
The application SHALL implement a header component with balance card matching the reference project's HomeView header pattern.

#### Scenario: Header Background and Layout
**Given** the home screen displays a header
**When** the header is rendered
**Then** the header SHALL use blue-600 equivalent background (#2563EB)
**And** the header SHALL have white text
**And** the header top padding SHALL account for safe area
**And** the header SHALL have rounded bottom corners (rounded-b-3xl = 24dp radius)
**And** the header SHALL contain greeting, balance card, and action buttons

#### Scenario: Balance Card Glassmorphism
**Given** the header contains a balance card
**When** the balance card is rendered
**Then** the card SHALL use white/10 background with backdrop blur
**And** the card SHALL have rounded corners (radiusLg = 16dp matching rounded-2xl)
**And** the card SHALL display total assets amount
**And** the card SHALL have show/hide toggle for balance
**And** the card SHALL show 24h change percentage with color coding

#### Scenario: Quick Stock Pills
**Given** the balance card displays quick stock information
**When** quick stock pills are rendered
**Then** each pill SHALL use white/10 background (matching reference)
**And** pills SHALL have rounded corners (radiusMd = 12dp matching rounded-xl)
**And** pills SHALL display logo, stock name, and change percentage
**And** pills SHALL be horizontally scrollable if needed

#### Scenario: Action Buttons
**Given** the header contains action buttons (Deposit/Withdraw or equivalent)
**When** action buttons are rendered
**Then** the primary button SHALL use green-500 background
**And** the secondary button SHALL use white background with blue-600 text
**And** buttons SHALL be full-width with equal sizing (flex-1)
**And** buttons SHALL have rounded corners (rounded-full)
**And** buttons SHALL have appropriate padding and touch targets

### Requirement: Watchlist/List Item Styling
List item widgets SHALL be styled to match the reference project's WatchlistItem component patterns.

#### Scenario: List Item Layout
**Given** a list displays market items
**When** a list item is rendered
**Then** the item SHALL have consistent padding matching reference
**And** the item SHALL display symbol, name, price, and change
**And** symbol and name SHALL be left-aligned
**And** price and change SHALL be right-aligned
**And** a subtle separator MAY be shown between items

#### Scenario: List Item Price Change Styling
**Given** a list item shows price change information
**When** the change is rendered
**Then** positive changes SHALL use priceUpRed color
**And** negative changes SHALL use priceDownGreen color
**And** change percentage SHALL be shown with appropriate sign
**And** typography SHALL match reference text sizes

## MODIFIED Requirements

### Requirement: Widget Touch Feedback
Existing tappable widgets SHALL be updated to provide touch feedback consistent with the reference project's interaction patterns.

#### Scenario: Card Tap Feedback
**Given** a user taps on a MarketCard
**When** the tap occurs
**Then** haptic feedback SHALL be triggered (HapticFeedback.lightImpact)
**And** visual ripple effect SHALL be shown
**And** ripple SHALL respect card border radius
**And** navigation SHALL occur after feedback completes

#### Scenario: Navigation Item Tap
**Given** a user taps a bottom navigation item
**When** the tap occurs
**Then** the active state SHALL change immediately
**And** haptic feedback MAY be provided
**And** icon and label color SHALL transition smoothly
**And** the selected page SHALL be displayed

## Success Criteria

1. **Visual Consistency**: Components match reference design within acceptable tolerances
2. **Touch Targets**: All interactive elements meet 48dp minimum size requirement
3. **Haptic Feedback**: Important interactions provide appropriate tactile feedback
4. **Responsive Layout**: Components adapt gracefully to different screen sizes
5. **Accessibility**: All components work with screen readers and meet contrast requirements
6. **Performance**: Smooth rendering at 60fps with no jank

## Related Capabilities
- `design-system-theming` - Provides colors, typography, and tokens used by components
- Future: animation-patterns - Will add motion to these components
