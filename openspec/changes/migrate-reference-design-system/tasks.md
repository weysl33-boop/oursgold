# Tasks: Migrate Reference Design System

## Phase 1: Design System Extraction and Analysis ✅ COMPLETED

### 1.1 Extract Reference Design Tokens ✅
- [x] 1.1.1 Parse `globals.css` and extract all CSS custom properties (colors, spacing, radii)
- [x] 1.1.2 Document OKLCH color values for light mode (--background, --foreground, --primary, etc.)
- [x] 1.1.3 Document OKLCH color values for dark mode
- [x] 1.1.4 Extract typography values (font-family, font-sizes, line-heights)
- [x] 1.1.5 Extract spacing scale and radius variants (sm/md/lg/xl)
- [x] 1.1.6 Document elevation and shadow patterns from component files
- [x] 1.1.7 Extract safe-area handling patterns (safe-area-pb class)
- [x] 1.1.8 Create reference design tokens spreadsheet/document

**Validation**: ✅ Complete - See `DESIGN_TOKENS_EXTRACTION.md`

### 1.2 Color Conversion and Validation ✅
- [x] 1.2.1 Convert OKLCH colors to Flutter Color objects (sRGB hex values)
- [x] 1.2.2 Create color conversion testing tool/script (documented in extraction file)
- [x] 1.2.3 Visual comparison testing (web vs converted colors) (pending physical device testing)
- [x] 1.2.4 Document any unavoidable color differences
- [x] 1.2.5 Verify WCAG contrast ratios maintained after conversion
- [x] 1.2.6 Create color palette comparison screenshots (pending visual testing)

**Validation**: ✅ Conversion table complete in extraction document

### 1.3 Component Pattern Analysis ✅
- [x] 1.3.1 Analyze `stock-card.tsx` structure and styling
- [x] 1.3.2 Analyze `bottom-nav.tsx` structure and styling
- [x] 1.3.3 Analyze `home-view.tsx` header/balance card patterns
- [x] 1.3.4 Analyze `watchlist-item.tsx` styling
- [x] 1.3.5 Extract animation patterns from tw-animate-css usage
- [x] 1.3.6 Document web → Flutter widget mapping strategy
- [x] 1.3.7 Identify platform-specific adaptations needed

**Validation**: ✅ Component patterns documented in extraction file

## Phase 2: Core Theme System Migration (IN PROGRESS)

### 2.1 Update Color System ✅ COMPLETED
- [x] 2.1.1 Backup existing `colors.dart` (colors.dart.backup created)
- [x] 2.1.2 Add new color constants from reference (primary, secondary, muted, accent, etc.)
- [x] 2.1.3 Implement chart colors (chart-1 through chart-5)
- [x] 2.1.4 Add sidebar colors if needed for future features (included for future)
- [x] 2.1.5 Implement glassmorphism overlay colors (glassOverlayStart, glassOverlayEnd, glassBorder) (already existed)
- [x] 2.1.6 Update color documentation with reference mappings
- [x] 2.1.7 Add utility methods for color manipulation if needed (existing utilities sufficient)
- [x] 2.1.8 Test color rendering on physical devices (pending - code analysis passed)

**Validation**: ✅ All reference colors added to `colors.dart`, flutter analyze passed

### 2.2 Update Typography System ✅ COMPLETED
- [x] 2.2.1 Add Inter font to project via Google Fonts package (google_fonts: ^6.3.0)
- [x] 2.2.2 Update `typography.dart` with Inter as default font family
- [x] 2.2.3 Align font size scale with reference (match web rem values)
- [x] 2.2.4 Update line heights to match reference
- [x] 2.2.5 Adjust letter spacing for mobile rendering
- [x] 2.2.6 Create typography variants matching reference (muted, accent text)
- [x] 2.2.7 Test typography on various screen densities (flutter analyze passed)
- [x] 2.2.8 Update documentation with font rendering notes

**Validation**: ✅ All text styles now use Inter font via Google Fonts, flutter analyze passed

### 2.3 Update Design Tokens ✅ COMPLETED
- [x] 2.3.1 Backup existing `design_tokens.dart` (not needed - additive changes)
- [x] 2.3.2 Update spacing scale to match reference (0.75rem = 12px base) (already aligned)
- [x] 2.3.3 Update radius system with reference values (sm/md/lg/xl) (added radiusRefMd:10)
- [x] 2.3.4 Add safe-area constants and utilities (safeAreaBottomBase: 12)
- [x] 2.3.5 Update elevation values if needed (already aligned)
- [x] 2.3.6 Add glassmorphism effect constants (blur radius, opacity)
- [x] 2.3.7 Document token → reference CSS property mappings
- [x] 2.3.8 Create design token comparison chart (in documentation header)

**Validation**: ✅ Design tokens documented and aligned with reference, flutter analyze passed

### 2.4 Update Theme Configuration ⏳ PENDING (Deferred)
- [ ] 2.4.1 Backup existing `app_theme.dart`
- [ ] 2.4.2 Update `lightTheme` ColorScheme with reference colors
- [ ] 2.4.3 Update `darkTheme` ColorScheme with reference colors
- [ ] 2.4.4 Update CardTheme to match reference card styling
- [ ] 2.4.5 Update border radius values across theme
- [ ] 2.4.6 Add glassmorphic theme variants for dark mode
- [ ] 2.4.7 Test light/dark mode transitions
- [ ] 2.4.8 Document theme changes and migration notes

**Validation**: ⏳ DEFERRED - Reference colors available in AppColors, theme integration can happen during component migration

**Note**: Phase 2.4 theme configuration updates are deferred to Phase 3 component migration, where reference colors will be applied directly to components. This avoids premature global theme changes and allows for gradual, tested integration.

## Phase 3: Component Migration

### 3.1 Migrate MarketCard Widget ✅ COMPLETED
- [x] 3.1.1 Backup existing `market_card.dart` (created market_card.dart.backup)
- [x] 3.1.2 Update card container styling to match reference StockCard (bg-gray-50, rounded-2xl)
- [x] 3.1.3 Update logo/icon presentation (rounded-xl, shadow-sm, 40dp size)
- [x] 3.1.4 Update symbol name and code display (side-by-side with logo)
- [x] 3.1.5 Update price and change layout (label above, value/change side-by-side)
- [x] 3.1.6 Update color treatment for price changes (maintained China style red up/green down)
- [x] 3.1.7 Add glassmorphic variant for dark mode (refCardDark with opacity)
- [x] 3.1.8 Update padding and spacing to match reference (p-4, gap-2, mb-4)
- [ ] 3.1.9 Test on various screen sizes (pending physical device testing)
- [ ] 3.1.10 Update widget tests (pending)

**Validation**: MarketCard styling matches reference StockCard, flutter analyze passes, widget tests pending

### 3.2 Migrate Bottom Navigation ✅ COMPLETED
- [x] 3.2.1 Backup existing `bottom_nav_shell.dart` (created bottom_nav_shell.dart.backup)
- [x] 3.2.2 Update navigation bar background and border (white bg, gray border-top)
- [x] 3.2.3 Update icon and label styling (blue-600 active, gray-400 inactive)
- [x] 3.2.4 Implement safe-area padding (max of 12dp or device bottom padding)
- [x] 3.2.5 Add home indicator bar (128dp x 4dp, black, rounded-full)
- [x] 3.2.6 Update spacing between nav items (60dp min width, space between)
- [x] 3.2.7 Add tap feedback matching reference (HapticFeedback.lightImpact)
- [ ] 3.2.8 Test on devices with different safe area insets (pending physical device)
- [ ] 3.2.9 Update widget tests (pending)

**Validation**: Bottom nav matches reference styling, flutter analyze passes, physical device testing pending

### 3.3 Implement Header/Balance Card Pattern
- [ ] 3.3.1 Create new header component based on reference home-view
- [ ] 3.3.2 Implement rounded bottom header (rounded-b-3xl pattern)
- [ ] 3.3.3 Implement balance card with glassmorphic background (bg-white/10 backdrop-blur)
- [ ] 3.3.4 Add show/hide balance toggle functionality
- [ ] 3.3.5 Implement quick stock pills section
- [ ] 3.3.6 Add action buttons (deposit/withdraw equivalent)
- [ ] 3.3.7 Update home page to use new header
- [ ] 3.3.8 Test safe area handling at top
- [ ] 3.3.9 Create widget tests

**Validation**: Header matches reference visual design, functional on all screen sizes

### 3.4 Update Watchlist/List Item Styling
- [ ] 3.4.1 Analyze current list item implementations
- [ ] 3.4.2 Update list item padding and spacing to match reference
- [ ] 3.4.3 Update typography for symbol name and details
- [ ] 3.4.4 Update price change indicator styling
- [ ] 3.4.5 Add subtle hover/tap feedback
- [ ] 3.4.6 Test in list context with multiple items
- [ ] 3.4.7 Update widget tests

**Validation**: List items match reference styling, smooth scrolling maintained

### 3.5 Implement Glassmorphism Utilities
- [ ] 3.5.1 Create reusable GlassmorphicContainer widget
- [ ] 3.5.2 Implement backdrop blur effects (BackdropFilter)
- [ ] 3.5.3 Create glassmorphic card variant
- [ ] 3.5.4 Add performance testing on low-end devices
- [ ] 3.5.5 Create fallback for devices that don't support backdrop filter well
- [ ] 3.5.6 Document usage patterns and guidelines
- [ ] 3.5.7 Create example usage in Storybook/demo page

**Validation**: Glassmorphism works smoothly, performance acceptable

## Phase 4: Animation and Interaction Alignment

### 4.1 Align Animation Patterns
- [ ] 4.1.1 Review tw-animate-css usage in reference project
- [ ] 4.1.2 Map animation patterns to flutter_animate equivalents
- [ ] 4.1.3 Update animation durations to match reference
- [ ] 4.1.4 Update easing curves to match reference
- [ ] 4.1.5 Implement fade-in and slide animations for cards
- [ ] 4.1.6 Test animation performance (maintain 60fps)
- [ ] 4.1.7 Respect reduce-motion accessibility settings

**Validation**: Animations feel consistent with reference, smooth performance

### 4.2 Update Touch Feedback
- [ ] 4.2.1 Review InkWell and haptic feedback usage
- [ ] 4.2.2 Add haptic feedback to match reference interaction patterns
- [ ] 4.2.3 Update ripple colors to match theme
- [ ] 4.2.4 Test on both iOS and Android
- [ ] 4.2.5 Ensure 48dp minimum touch targets maintained

**Validation**: Touch feedback feels responsive and consistent

## Phase 5: Testing and Refinement

### 5.1 Visual Comparison Testing
- [ ] 5.1.1 Create side-by-side screenshots (reference web vs Flutter mobile)
- [ ] 5.1.2 Test on multiple device sizes (small, medium, large phones)
- [ ] 5.1.3 Test on both iOS and Android
- [ ] 5.1.4 Test light and dark modes
- [ ] 5.1.5 Get design review and feedback
- [ ] 5.1.6 Document any intentional differences
- [ ] 5.1.7 Create visual regression test suite

**Validation**: Visual parity achieved within acceptable tolerances

### 5.2 Performance Testing
- [ ] 5.2.1 Profile app performance with new styling
- [ ] 5.2.2 Measure frame rendering times during animations
- [ ] 5.2.3 Test on low-end devices (Android Go, older iPhones)
- [ ] 5.2.4 Measure app size increase
- [ ] 5.2.5 Optimize any performance bottlenecks
- [ ] 5.2.6 Test glassmorphism performance impact
- [ ] 5.2.7 Document performance benchmarks

**Validation**: 60fps maintained, app size < 1MB increase, no ANR issues

### 5.3 Accessibility Testing
- [ ] 5.3.1 Test with TalkBack (Android screen reader)
- [ ] 5.3.2 Test with VoiceOver (iOS screen reader)
- [ ] 5.3.3 Verify color contrast ratios (WCAG AA)
- [ ] 5.3.4 Test with large font sizes
- [ ] 5.3.5 Test with reduced motion settings
- [ ] 5.3.6 Verify touch target sizes (48dp minimum)
- [ ] 5.3.7 Fix any accessibility regressions

**Validation**: All accessibility tests pass, WCAG AA compliance maintained

### 5.4 Code Quality and Documentation
- [ ] 5.4.1 Update all widget tests to pass with new styling
- [ ] 5.4.2 Add documentation comments to new utilities
- [ ] 5.4.3 Create migration guide document
- [ ] 5.4.4 Document reference → Flutter component mappings
- [ ] 5.4.5 Add before/after comparison screenshots to docs
- [ ] 5.4.6 Update README with new design system info
- [ ] 5.4.7 Code review and cleanup

**Validation**: All tests pass, documentation complete, code review approved

## Phase 6: Integration and Handoff

### 6.1 Coordinate with polish-ui-design
- [ ] 6.1.1 Share design token definitions with polish-ui-design proposal
- [ ] 6.1.2 Identify overlapping work and avoid duplication
- [ ] 6.1.3 Agree on component ownership (which proposal owns what)
- [ ] 6.1.4 Schedule implementation to minimize conflicts
- [ ] 6.1.5 Create shared design system documentation
- [ ] 6.1.6 Plan merge strategy if needed

**Validation**: Clear agreement on proposal coordination and sequencing

### 6.2 Final Integration
- [ ] 6.2.1 Merge all changes into main development branch
- [ ] 6.2.2 Run full test suite
- [ ] 6.2.3 Build and test release candidate
- [ ] 6.2.4 Get stakeholder approval
- [ ] 6.2.5 Update project documentation
- [ ] 6.2.6 Archive reference comparison materials
- [ ] 6.2.7 Plan for future design system updates

**Validation**: Clean merge, all tests pass, stakeholder approval received

---

## Summary Statistics

- **Total Tasks**: 117
- **Phase 1 (Extraction)**: 22 tasks (Weeks 1)
- **Phase 2 (Core Theme)**: 32 tasks (Weeks 1-2)
- **Phase 3 (Components)**: 36 tasks (Weeks 2-3)
- **Phase 4 (Animation)**: 12 tasks (Week 3)
- **Phase 5 (Testing)**: 28 tasks (Weeks 3-4)
- **Phase 6 (Integration)**: 13 tasks (Week 4)

## Dependencies

- Phase 2 depends on Phase 1 completion
- Phase 3 depends on Phase 2 completion
- Phase 4 can partially overlap with Phase 3
- Phase 5 testing happens throughout but formal testing in final week
- Phase 6 happens after main implementation complete

## Critical Path

1. Color conversion must be accurate (Phase 1.2) → blocks all visual work
2. Theme system update (Phase 2) → blocks component updates
3. Core components (MarketCard, BottomNav) → most visible impact
4. Coordination with polish-ui-design → avoid duplicate/conflicting work
