# Tasks: Polish UI Design

## Phase 1: Design System Foundation

### 1.1 Design Tokens Setup
- [ ] 1.1.1 Create `lib/core/theme/design_tokens.dart` with spacing scale (8pt grid)
- [ ] 1.1.2 Add typography scale constants (font sizes, weights, line heights)
- [ ] 1.1.3 Define border radius scale (xs, sm, md, lg, xl, full)
- [ ] 1.1.4 Add elevation scale constants (0, 1, 2, 4, 8, 16)
- [ ] 1.1.5 Document design tokens usage in code comments

### 1.2 Extended Color Palette
- [ ] 1.2.1 Create `lib/core/theme/colors.dart` with gold palette (50-900)
- [ ] 1.2.2 Add neutral palette (50-900) for text and backgrounds
- [ ] 1.2.3 Refine semantic colors (success, error, warning, info)
- [ ] 1.2.4 Verify WCAG AA contrast ratios for all color combinations
- [ ] 1.2.5 Update `app_theme.dart` to use extended color palette

### 1.3 Typography System
- [ ] 1.3.1 Create `lib/core/theme/typography.dart` with text styles
- [ ] 1.3.2 Define heading styles (H1, H2, H3) with weights and line heights
- [ ] 1.3.3 Define body styles (large, base, small) with line heights
- [ ] 1.3.4 Define caption and label styles
- [ ] 1.3.5 Update `app_theme.dart` TextTheme with custom typography

### 1.4 Dependencies Installation
- [ ] 1.4.1 Add `flutter_animate: ^4.5.0` to pubspec.yaml
- [ ] 1.4.2 Add `shimmer: ^3.0.0` to pubspec.yaml
- [ ] 1.4.3 Add `lottie: ^3.1.0` to pubspec.yaml (optional for empty states)
- [ ] 1.4.4 Add `flutter_svg: ^2.0.0` to pubspec.yaml (optional for icons)
- [ ] 1.4.5 Run `flutter pub get` to install dependencies

## Phase 2: Visual Refinements

### 2.1 Enhanced Market Card
- [ ] 2.1.1 Refactor `MarketCard` to use design tokens (spacing, radius, colors)
- [ ] 2.1.2 Add subtle shadow with proper elevation (elevation 2)
- [ ] 2.1.3 Create `MarketCardSkeleton` widget with shimmer effect
- [ ] 2.1.4 Add entrance animation (fade + slide) using flutter_animate
- [ ] 2.1.5 Improve typography hierarchy (symbol name, price, change)
- [ ] 2.1.6 Add semantic labels for accessibility
- [ ] 2.1.7 Ensure 48dp minimum touch target size
- [ ] 2.1.8 Test on light and dark modes

### 2.2 Typography Refinement
- [ ] 2.2.1 Update all `Text` widgets in home_page.dart to use typography tokens
- [ ] 2.2.2 Update quotes_page.dart text styles
- [ ] 2.2.3 Update detail_page.dart text styles
- [ ] 2.2.4 Update news_list_page.dart and news_detail_page.dart text styles
- [ ] 2.2.5 Update search_page.dart text styles
- [ ] 2.2.6 Verify line heights create comfortable reading experience
- [ ] 2.2.7 Test dynamic type scaling (1.0x, 1.5x, 2.0x)

### 2.3 Spacing Consistency
- [ ] 2.3.1 Replace all hardcoded padding values with spacing tokens
- [ ] 2.3.2 Replace all hardcoded margin values with spacing tokens
- [ ] 2.3.3 Ensure vertical rhythm on home page (consistent gaps)
- [ ] 2.3.4 Ensure consistent spacing on quotes page
- [ ] 2.3.5 Verify 8pt grid alignment with visual inspection

### 2.4 Border Radius Consistency
- [ ] 2.4.1 Update all Card widgets to use `radiusMd` (12dp)
- [ ] 2.4.2 Update all Button widgets to use `radiusSm` (8dp)
- [ ] 2.4.3 Update all TextField widgets to use `radiusSm` (8dp)
- [ ] 2.4.4 Update container border radius in news_section.dart
- [ ] 2.4.5 Verify visual consistency across all screens

### 2.5 Glassmorphism Dark Mode
- [ ] 2.5.1 Create `GlassmorphicCard` widget with BackdropFilter
- [ ] 2.5.2 Add gradient overlay (white 15% → 5% opacity)
- [ ] 2.5.3 Add semi-transparent border (white 10% opacity)
- [ ] 2.5.4 Replace Card widgets in dark mode with GlassmorphicCard
- [ ] 2.5.5 Test visual appearance on dark backgrounds
- [ ] 2.5.6 Verify performance (no frame drops)

### 2.6 Enhanced Input Fields
- [ ] 2.6.1 Update TextField focus border color to gold500
- [ ] 2.6.2 Increase focused border width to 2px
- [ ] 2.6.3 Add error state with red border
- [ ] 2.6.4 Update fill colors using neutral palette
- [ ] 2.6.5 Test in search_page.dart and forex_page.dart

## Phase 3: Motion Design

### 3.1 Page Transitions
- [ ] 3.1.1 Create custom PageRouteBuilder for forward navigation (slide + fade)
- [ ] 3.1.2 Implement route transition for Home → Detail (slide from right)
- [ ] 3.1.3 Implement route transition for Home → News List
- [ ] 3.1.4 Implement route transition for Home → Search
- [ ] 3.1.5 Add modal presentation transition (slide from bottom)
- [ ] 3.1.6 Test all navigation flows with smooth transitions

### 3.2 List Animations
- [ ] 3.2.1 Add staggered fade-in to MarketCard grid on home_page
- [ ] 3.2.2 Add staggered animations to quotes list
- [ ] 3.2.3 Add staggered animations to news list
- [ ] 3.2.4 Add staggered animations to search results
- [ ] 3.2.5 Cap stagger delay at 500ms (max 10 items)
- [ ] 3.2.6 Test scroll performance with many items

### 3.3 Micro-Interactions
- [ ] 3.3.1 Add scale animation to button presses (scale to 0.95, 100ms)
- [ ] 3.3.2 Add scale animation to card taps (scale to 0.98, 150ms)
- [ ] 3.3.3 Add smooth toggle switch transitions (200ms)
- [ ] 3.3.4 Add ripple effect enhancement (if needed)
- [ ] 3.3.5 Test micro-interactions feel natural and responsive

### 3.4 Shimmer Skeleton Loaders
- [ ] 3.4.1 Create `MarketCardSkeleton` with shimmer effect
- [ ] 3.4.2 Create `QuoteItemSkeleton` with shimmer effect
- [ ] 3.4.3 Create `NewsItemSkeleton` with shimmer effect
- [ ] 3.4.4 Add loading state management to home_page
- [ ] 3.4.5 Add loading state management to quotes_page
- [ ] 3.4.6 Add loading state management to news_list_page
- [ ] 3.4.7 Implement smooth cross-fade from skeleton to content (300ms)
- [ ] 3.4.8 Test shimmer animation in light and dark modes

### 3.5 Haptic Feedback
- [ ] 3.5.1 Add light haptic to button taps across all pages
- [ ] 3.5.2 Add medium haptic to tab switches in bottom navigation
- [ ] 3.5.3 Add medium haptic to page navigation transitions
- [ ] 3.5.4 Add selection haptic to toggle switches in profile page
- [ ] 3.5.5 Create haptic preference toggle in profile settings
- [ ] 3.5.6 Respect system accessibility settings for haptics

## Phase 4: Accessibility

### 4.1 Semantic Labels
- [ ] 4.1.1 Add semantic labels to all MarketCard widgets
- [ ] 4.1.2 Add semantic labels to navigation icons (search, notifications)
- [ ] 4.1.3 Add semantic labels to bottom navigation items
- [ ] 4.1.4 Add semantic labels to news items
- [ ] 4.1.5 Add semantic labels to quote items
- [ ] 4.1.6 Add semantic labels to all IconButton widgets
- [ ] 4.1.7 Group related elements with Semantics(container: true)
- [ ] 4.1.8 Test with TalkBack (Android) and verify announcements

### 4.2 Touch Target Sizes
- [ ] 4.2.1 Create `AccessibleIconButton` wrapper with 48dp size
- [ ] 4.2.2 Replace small IconButton widgets with AccessibleIconButton
- [ ] 4.2.3 Verify all app bar icons have 48dp touch targets
- [ ] 4.2.4 Verify all list item heights ≥ 48dp
- [ ] 4.2.5 Add programmatic touch target size tests
- [ ] 4.2.6 Test with large fingers on small device

### 4.3 Color Contrast
- [ ] 4.3.1 Create contrast ratio calculator utility
- [ ] 4.3.2 Test all text/background combinations
- [ ] 4.3.3 Fix any contrast ratios below WCAG AA (4.5:1 text, 3:1 UI)
- [ ] 4.3.4 Verify gold on white meets 3:1 for UI components
- [ ] 4.3.5 Test with color blindness simulators
- [ ] 4.3.6 Document contrast ratios for future reference

### 4.4 Dynamic Type Support
- [ ] 4.4.1 Remove any hardcoded `textScaleFactor` overrides
- [ ] 4.4.2 Test app at 1.5x font scale
- [ ] 4.4.3 Test app at 2.0x font scale
- [ ] 4.4.4 Fix any text overflow issues
- [ ] 4.4.5 Ensure layouts adapt gracefully to large text
- [ ] 4.4.6 Test on iOS and Android with system font size changes

### 4.5 Screen Reader Support
- [ ] 4.5.1 Test complete app navigation with TalkBack
- [ ] 4.5.2 Test complete app navigation with VoiceOver (if iOS available)
- [ ] 4.5.3 Verify all interactive elements are announced
- [ ] 4.5.4 Verify navigation order is logical
- [ ] 4.5.5 Add `Semantics(liveRegion: true)` for error messages
- [ ] 4.5.6 Document accessibility testing results

## Phase 5: Premium Components

### 5.1 Custom Pull-to-Refresh
- [ ] 5.1.1 Create `GoldRefreshIndicator` widget
- [ ] 5.1.2 Set color to gold500, background to theme surface
- [ ] 5.1.3 Update home_page.dart to use GoldRefreshIndicator
- [ ] 5.1.4 Update quotes_page.dart to use GoldRefreshIndicator
- [ ] 5.1.5 Update news_list_page.dart to use GoldRefreshIndicator
- [ ] 5.1.6 Test pull-to-refresh animation smoothness

### 5.2 Empty State Components
- [ ] 5.2.1 Download free Lottie animations for empty states (LottieFiles)
- [ ] 5.2.2 Add Lottie files to assets folder
- [ ] 5.2.3 Create `EmptyState` widget with Lottie animation
- [ ] 5.2.4 Add empty state to search_page (no results)
- [ ] 5.2.5 Add empty state to news_list_page (no articles)
- [ ] 5.2.6 Add empty state for future favorites feature
- [ ] 5.2.7 Include helpful message and CTA button

### 5.3 Error State Components
- [ ] 5.3.1 Create `ErrorState` widget with icon and message
- [ ] 5.3.2 Add retry button with haptic feedback
- [ ] 5.3.3 Add error state to network request failures
- [ ] 5.3.4 Test error state appearance in light/dark modes
- [ ] 5.3.5 Verify screen reader announces error messages

### 5.4 Loading State Improvements
- [ ] 5.4.1 Replace CircularProgressIndicator with shimmer skeletons
- [ ] 5.4.2 Add loading state animations to all async operations
- [ ] 5.4.3 Implement smooth transitions between states (loading → content → error)
- [ ] 5.4.4 Test loading states don't block user interaction unnecessarily

## Phase 6: Performance & Testing

### 6.1 Animation Performance
- [ ] 6.1.1 Profile animations with Flutter DevTools Timeline
- [ ] 6.1.2 Add `RepaintBoundary` to complex animated widgets
- [ ] 6.1.3 Verify all animations maintain 60fps
- [ ] 6.1.4 Test on low-end device or emulator
- [ ] 6.1.5 Optimize any animations causing frame drops
- [ ] 6.1.6 Respect `AccessibilityFeatures.disableAnimations`

### 6.2 Bundle Size Verification
- [ ] 6.2.1 Build APK and measure size before polish
- [ ] 6.2.2 Build APK and measure size after polish
- [ ] 6.2.3 Verify size increase < 2MB
- [ ] 6.2.4 Use `flutter build apk --analyze-size` to inspect
- [ ] 6.2.5 Optimize assets if size increase is excessive

### 6.3 Widget Tests
- [ ] 6.3.1 Write widget test for EnhancedMarketCard
- [ ] 6.3.2 Write widget test for GlassmorphicCard (dark mode)
- [ ] 6.3.3 Write widget test for shimmer skeletons
- [ ] 6.3.4 Write widget test for empty states
- [ ] 6.3.5 Write widget test for error states
- [ ] 6.3.6 Write semantic tests for accessibility labels
- [ ] 6.3.7 Write tests for touch target sizes
- [ ] 6.3.8 Run all tests and ensure 100% pass rate

### 6.4 Golden File Tests
- [ ] 6.4.1 Generate golden files for MarketCard (light/dark)
- [ ] 6.4.2 Generate golden files for NewsItem (light/dark)
- [ ] 6.4.3 Generate golden files for QuoteItem (light/dark)
- [ ] 6.4.4 Set up CI to run golden tests on PRs
- [ ] 6.4.5 Document golden test update process

### 6.5 Accessibility Testing
- [ ] 6.5.1 Complete TalkBack testing checklist
- [ ] 6.5.2 Complete VoiceOver testing checklist (if iOS available)
- [ ] 6.5.3 Test with large font sizes (accessibility settings)
- [ ] 6.5.4 Test with high contrast mode
- [ ] 6.5.5 Test with color inversion
- [ ] 6.5.6 Document accessibility test results and issues

### 6.6 Cross-Platform Testing
- [ ] 6.6.1 Test on Android (emulator and physical device)
- [ ] 6.6.2 Test on iOS (simulator if available)
- [ ] 6.6.3 Test on different screen sizes (small, medium, large, tablet)
- [ ] 6.6.4 Test on different Android versions (API 21+)
- [ ] 6.6.5 Verify no platform-specific regressions

## Phase 7: Documentation & Cleanup

### 7.1 Design System Documentation
- [ ] 7.1.1 Create `docs/design-system.md` with token usage guidelines
- [ ] 7.1.2 Document spacing scale with visual examples
- [ ] 7.1.3 Document typography scale with visual examples
- [ ] 7.1.4 Document color palette with contrast ratios
- [ ] 7.1.5 Add code examples for common patterns

### 7.2 Animation Guidelines
- [ ] 7.2.1 Create `docs/animation-guidelines.md`
- [ ] 7.2.2 Document animation durations and curves
- [ ] 7.2.3 Document when to use each animation type
- [ ] 7.2.4 Provide code examples for common animations
- [ ] 7.2.5 Add performance best practices

### 7.3 Accessibility Guidelines
- [ ] 7.3.1 Create `docs/accessibility.md`
- [ ] 7.3.2 Document semantic label patterns
- [ ] 7.3.3 Document touch target requirements
- [ ] 7.3.4 Document color contrast requirements
- [ ] 7.3.5 Provide testing checklist for future features

### 7.4 Code Cleanup
- [ ] 7.4.1 Remove unused imports flagged by flutter analyze
- [ ] 7.4.2 Remove unused variables and methods
- [ ] 7.4.3 Add TODO comments for future enhancements
- [ ] 7.4.4 Ensure consistent code formatting (flutter format)
- [ ] 7.4.5 Run `flutter analyze` and fix all warnings

### 7.5 Final Verification
- [ ] 7.5.1 Run complete app on device and verify all polish is applied
- [ ] 7.5.2 Test all navigation flows end-to-end
- [ ] 7.5.3 Verify all animations are smooth and performant
- [ ] 7.5.4 Verify accessibility with screen reader
- [ ] 7.5.5 Take screenshots for documentation
- [ ] 7.5.6 Update CHANGELOG.md with polish improvements
- [ ] 7.5.7 Mark all tasks as complete in this file

## Summary

**Total Tasks**: 187
**Estimated Duration**: 4-5 weeks (part-time development)

**Phases**:
1. Design System Foundation: ~1 week (35 tasks)
2. Visual Refinements: ~1 week (30 tasks)
3. Motion Design: ~1 week (30 tasks)
4. Accessibility: ~1 week (30 tasks)
5. Premium Components: ~0.5 week (18 tasks)
6. Performance & Testing: ~1 week (27 tasks)
7. Documentation & Cleanup: ~0.5 week (17 tasks)

**Dependencies**:
- Phases 2-5 depend on Phase 1 (design tokens)
- Phase 6 depends on all previous phases
- Phase 7 is final polish and documentation

**Parallelization Opportunities**:
- After Phase 1, Phases 2, 3, 4 can be worked in parallel by different developers
- Phase 5 can start after Phase 2 is mostly complete
- Widget tests (6.3) can be written alongside implementation
