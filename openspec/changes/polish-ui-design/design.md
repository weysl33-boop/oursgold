# Design Document: Polish UI Design

## Overview

This document captures the architectural and design decisions for implementing comprehensive UI polish across the Flutter mobile app. The focus is on creating a systematic approach to visual refinement, motion design, and accessibility improvements without changing the core functionality.

## Design Principles

### 1. Subtle Excellence
- Animations should enhance, not distract
- Visual effects should serve functional purposes
- Polish should feel natural, not forced
- "Good design is invisible" - focus on usability

### 2. Performance First
- Maintain 60fps during animations
- Lazy-load heavy assets (Lottie, images)
- Use `RepaintBoundary` for complex widgets
- Respect device capabilities and battery life

### 3. Accessibility by Default
- Semantic labels for all interactive elements
- Touch targets ≥ 48dp
- Color contrast WCAG AA compliant
- Support screen readers and dynamic text sizing

### 4. Systematic Consistency
- Use design tokens for all values
- No magic numbers in widget code
- Reusable components with variants
- Document all design decisions

## Architecture Decisions

### AD-1: Design Token System

**Decision**: Create a centralized design token system in `app_theme.dart` instead of using inline values throughout the codebase.

**Rationale**:
- Single source of truth for all design values
- Easy to maintain consistency across screens
- Enables theme switching (light/dark) efficiently
- Facilitates rapid iteration on visual design

**Implementation**:
```dart
class AppDesignTokens {
  // Spacing scale (8pt grid system)
  static const double space0 = 0;
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space12 = 48;
  static const double space16 = 64;

  // Typography scale
  static const double fontSizeXs = 10;
  static const double fontSizeSm = 12;
  static const double fontSizeBase = 14;
  static const double fontSizeLg = 16;
  static const double fontSizeXl = 18;
  static const double fontSize2xl = 20;
  static const double fontSize3xl = 24;
  static const double fontSize4xl = 32;

  // Border radius
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 9999;

  // Elevation
  static const double elevation0 = 0;
  static const double elevation1 = 1;
  static const double elevation2 = 2;
  static const double elevation3 = 4;
  static const double elevation4 = 8;
  static const double elevation5 = 16;
}
```

**Trade-offs**:
- ✅ Consistency and maintainability
- ✅ Easy theming and iteration
- ❌ Slightly more verbose code
- ❌ Learning curve for contributors

### AD-2: Animation Strategy

**Decision**: Use `flutter_animate` package for declarative animations instead of manual `AnimationController` management.

**Rationale**:
- Declarative syntax is more readable and maintainable
- Built-in easing curves and effects
- Easier to chain and sequence animations
- Reduces boilerplate code significantly

**Example**:
```dart
// Before (manual)
class _AnimatedCard extends StatefulWidget {
  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(...),
    );
  }
}

// After (flutter_animate)
Card(...)
  .animate()
  .scale(
    duration: 300.ms,
    curve: Curves.easeOut,
    begin: Offset(0.95, 0.95),
    end: Offset(1.0, 1.0),
  )
```

**Trade-offs**:
- ✅ 70% less boilerplate code
- ✅ Easier to read and modify
- ✅ Built-in performance optimizations
- ❌ Additional dependency (~200KB)
- ❌ Learning new API

### AD-3: Skeleton Loaders

**Decision**: Implement skeleton loaders using `shimmer` package instead of circular progress indicators for content loading.

**Rationale**:
- Better perceived performance (users feel content is loading faster)
- Shows structure of incoming content
- More premium feel than spinners
- Industry standard (used by Facebook, LinkedIn, etc.)

**Implementation Pattern**:
```dart
class MarketCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        child: Column(
          children: [
            Container(height: 16, width: 100, color: Colors.white),
            SizedBox(height: 8),
            Container(height: 24, width: 80, color: Colors.white),
            SizedBox(height: 8),
            Container(height: 12, width: 60, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
```

**Trade-offs**:
- ✅ Better UX and perceived performance
- ✅ Professional appearance
- ✅ Communicates loading state clearly
- ❌ Additional dependency (~50KB)
- ❌ Need to create skeleton for each content type

### AD-4: Accessibility Semantics

**Decision**: Wrap all interactive widgets with `Semantics` widget and provide meaningful labels instead of relying on default semantics.

**Rationale**:
- Explicit semantics are more reliable than inferred ones
- Better control over screen reader announcements
- Supports internationalization (i18n)
- Meets WCAG 2.1 Level AA requirements

**Implementation Pattern**:
```dart
// Before
IconButton(
  icon: Icon(Icons.search),
  onPressed: () => context.push('/search'),
)

// After
Semantics(
  label: '搜索市场品种和用户',
  button: true,
  enabled: true,
  child: IconButton(
    icon: Icon(Icons.search),
    onPressed: () => context.push('/search'),
  ),
)
```

**Trade-offs**:
- ✅ Excellent accessibility support
- ✅ Better screen reader experience
- ✅ Testable with semantic finders
- ❌ More verbose code
- ❌ Need to maintain i18n for labels

### AD-5: Haptic Feedback Strategy

**Decision**: Add haptic feedback using `HapticFeedback` class for important user actions (navigation, confirmation, errors) but not for every tap.

**Rationale**:
- Provides tactile confirmation of actions
- Enhances accessibility for users with visual impairments
- Common in premium apps (iOS especially)
- Helps distinguish different action types

**Usage Guidelines**:
- **Light Impact**: Button taps, list item selection
- **Medium Impact**: Navigation changes, tab switches
- **Heavy Impact**: Important confirmations (delete, submit)
- **Selection Click**: Picker value changes, toggle switches
- **No Feedback**: Scrolling, hover, non-interactive taps

**Implementation**:
```dart
void _onImportantAction() async {
  await HapticFeedback.mediumImpact();
  // Perform action
}
```

**Trade-offs**:
- ✅ Better tactile feedback
- ✅ Accessibility improvement
- ✅ Premium feel
- ❌ Battery consumption (minimal)
- ❌ User preference varies (should be toggleable)

## Component Design Patterns

### Pattern 1: Enhanced Market Card

**Current Issues**:
- Flat design lacks depth
- No hover/press states
- Missing loading skeleton
- No animation on appearance

**Enhanced Design**:
```dart
class EnhancedMarketCard extends ConsumerWidget {
  final String symbolCode;
  final bool isLoading;

  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return MarketCardSkeleton();
    }

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignTokens.radiusMd),
      ),
      child: Semantics(
        label: '$symbolName 价格 $price',
        button: true,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/detail/$symbolCode');
          },
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMd),
          child: Padding(
            padding: EdgeInsets.all(AppDesignTokens.space4),
            child: _buildContent(),
          ),
        ),
      ),
    )
    .animate()
    .fadeIn(duration: 300.ms, curve: Curves.easeOut)
    .slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}
```

**Improvements**:
- Consistent border radius from tokens
- Semantic label for accessibility
- Haptic feedback on tap
- Fade + slide animation on appear
- Skeleton loader for loading state

### Pattern 2: Staggered List Animation

**Current Issues**:
- Lists appear instantly (jarring)
- No visual indication of new items
- Static feel

**Enhanced Design**:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(...)
      .animate()
      .fadeIn(
        delay: (index * 50).ms,
        duration: 300.ms,
        curve: Curves.easeOut,
      )
      .slideX(
        begin: 0.2,
        end: 0,
        delay: (index * 50).ms,
        duration: 300.ms,
        curve: Curves.easeOut,
      );
  },
)
```

**Improvements**:
- Staggered animation (50ms delay between items)
- Smooth fade + slide entrance
- Creates sense of depth and hierarchy

### Pattern 3: Custom Pull-to-Refresh Indicator

**Current Issues**:
- Default iOS/Android indicator doesn't match theme
- No gold branding
- Generic appearance

**Enhanced Design**:
```dart
class GoldRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppTheme.primaryColor,
      backgroundColor: Colors.white,
      strokeWidth: 3.0,
      displacement: 40.0,
      child: child,
    );
  }
}
```

**Future Enhancement** (custom indicator):
- Animated gold coin spinning
- Progress arc in gold color
- Custom loading text

### Pattern 4: Glassmorphism Cards (Dark Mode)

**Current Issues**:
- Dark mode cards are flat solid color
- Lacks visual interest
- No depth or layering

**Enhanced Design**:
```dart
class GlassmorphicCard extends StatelessWidget {
  final Widget child;

  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!isDark) {
      return Card(child: child); // Standard card for light mode
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDesignTokens.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusMd),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

**Improvements**:
- Frosted glass effect in dark mode
- Subtle gradient for depth
- Border for definition
- Premium modern appearance

## Motion Design Specifications

### Page Transitions

**Route Transitions**:
- **Forward navigation** (Home → Detail): Slide from right + fade
- **Back navigation**: Slide to right + fade
- **Modal/Bottom Sheet**: Slide from bottom + fade
- **Tab switches**: Cross-fade (no slide)

**Timing**:
- Duration: 250-300ms
- Curve: `Curves.easeOut` for entrance, `Curves.easeIn` for exit
- Combined transitions: `Curves.easeInOut`

**Implementation**:
```dart
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => DetailPage(),
  transitionDuration: const Duration(milliseconds: 300),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end)
      .chain(CurveTween(curve: Curves.easeOut));
    final offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  },
)
```

### Micro-Interactions

**Button Press**:
- Scale down to 0.95 on press
- Duration: 100ms
- Curve: `Curves.easeInOut`
- Haptic feedback: `lightImpact`

**Card Tap**:
- Scale down to 0.98 on press
- Duration: 150ms
- Curve: `Curves.easeInOut`
- Haptic feedback: `lightImpact`

**Toggle Switch**:
- Smooth position transition
- Duration: 200ms
- Curve: `Curves.easeInOut`
- Haptic feedback: `selectionClick`

**Floating Action Button**:
- Scale up from 0 on appear
- Rotate 180° if state changes (e.g., collapsed ↔ expanded)
- Duration: 300ms
- Curve: `Curves.elasticOut` (slight bounce)

## Color System Enhancements

### Extended Color Palette

**Current**: Basic primary, secondary, accent colors
**Enhanced**: Full tint/shade scale for each color

```dart
class AppColors {
  // Gold palette (primary)
  static const Color gold50 = Color(0xFFFFFBF0);
  static const Color gold100 = Color(0xFFFFF6D9);
  static const Color gold200 = Color(0xFFFFEDB3);
  static const Color gold300 = Color(0xFFFFE38D);
  static const Color gold400 = Color(0xFFFFD966);
  static const Color gold500 = Color(0xFFD4AF37); // Primary
  static const Color gold600 = Color(0xFFB8942B);
  static const Color gold700 = Color(0xFF9C7A1F);
  static const Color gold800 = Color(0xFF806013);
  static const Color gold900 = Color(0xFF664607);

  // Neutral palette
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // Semantic colors (refined)
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}
```

**Usage**:
- Use lighter shades for backgrounds and hover states
- Use darker shades for pressed states and shadows
- Neutral palette for text and borders
- Semantic colors for status and feedback

### Color Contrast Verification

**WCAG AA Requirements**:
- Normal text (< 18pt): Contrast ratio ≥ 4.5:1
- Large text (≥ 18pt): Contrast ratio ≥ 3:1
- UI components: Contrast ratio ≥ 3:1

**Testing Approach**:
```dart
double calculateContrastRatio(Color foreground, Color background) {
  final fgLuminance = foreground.computeLuminance();
  final bgLuminance = background.computeLuminance();
  final lighter = max(fgLuminance, bgLuminance);
  final darker = min(fgLuminance, bgLuminance);
  return (lighter + 0.05) / (darker + 0.05);
}

// Usage
assert(
  calculateContrastRatio(AppColors.gold500, Colors.white) >= 3.0,
  'Gold on white must meet WCAG AA contrast for UI components',
);
```

## Typography Enhancements

### Font Weight Scale

**Current**: Limited use of `FontWeight.bold` and normal
**Enhanced**: Full weight scale for hierarchy

```dart
class AppTypography {
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // Usage guidelines
  static TextStyle get headlineH1 => TextStyle(
    fontSize: AppDesignTokens.fontSize4xl,
    fontWeight: bold,
    height: 1.2,
  );

  static TextStyle get headlineH2 => TextStyle(
    fontSize: AppDesignTokens.fontSize3xl,
    fontWeight: semiBold,
    height: 1.3,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontSize: AppDesignTokens.fontSizeLg,
    fontWeight: regular,
    height: 1.5,
  );

  static TextStyle get bodyBase => TextStyle(
    fontSize: AppDesignTokens.fontSizeBase,
    fontWeight: regular,
    height: 1.5,
  );

  static TextStyle get caption => TextStyle(
    fontSize: AppDesignTokens.fontSizeSm,
    fontWeight: regular,
    height: 1.4,
    color: AppColors.neutral600,
  );
}
```

### Line Height (Leading)

**Guidelines**:
- Headings: 1.2-1.3 (tighter for impact)
- Body text: 1.5 (comfortable reading)
- Captions: 1.4 (balanced)
- Buttons: 1.0 (centered alignment)

## Accessibility Implementation

### Semantic Labels Strategy

**Interactive Elements**:
- All buttons: Action description (e.g., "搜索市场品种")
- All links: Destination description (e.g., "查看黄金详情")
- All images: Content description (e.g., "黄金价格走势图")
- All inputs: Label + hint (e.g., "搜索" + "输入品种代码或名称")

**Grouping**:
- Use `Semantics(container: true)` to group related elements
- Example: Market card = container with label "伦敦金，价格2658.50，上涨1.08%"

### Touch Target Guidelines

**Minimum Sizes**:
- Buttons: 48dp × 48dp
- Icons: 48dp × 48dp (with padding if icon < 24dp)
- List items: Height ≥ 48dp
- Checkboxes/radios: 48dp × 48dp

**Implementation**:
```dart
class AccessibleIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final String semanticLabel;

  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: SizedBox(
        width: 48,
        height: 48,
        child: IconButton(
          icon: icon,
          onPressed: onPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
```

## Performance Considerations

### Animation Performance

**Best Practices**:
1. Use `RepaintBoundary` for expensive widgets that animate
2. Avoid animating `Opacity` (use `AnimatedOpacity` or `FadeTransition`)
3. Use `const` constructors wherever possible
4. Profile with Flutter DevTools Timeline

**Example**:
```dart
RepaintBoundary(
  child: MarketCard()
    .animate()
    .fadeIn(),
)
```

### Image Optimization

**Guidelines**:
- Use vector graphics (SVG) for icons and illustrations
- Cache network images with `CachedNetworkImage`
- Lazy-load images below the fold
- Provide low-res placeholders

### Bundle Size Management

**Monitoring**:
- Track APK/IPA size before and after changes
- Target: < 2MB increase
- Use `flutter build apk --analyze-size` to inspect

## Testing Strategy

### Visual Regression Testing

**Approach**: Golden file tests for critical UI components

```dart
testWidgets('MarketCard golden test', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MarketCard(symbolCode: 'XAUUSD'),
      ),
    ),
  );

  await expectLater(
    find.byType(MarketCard),
    matchesGoldenFile('market_card_light.png'),
  );
});
```

### Accessibility Testing

**Approach**: Automated semantic tests + manual screen reader testing

```dart
testWidgets('MarketCard accessibility', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MarketCard(symbolCode: 'XAUUSD'),
      ),
    ),
  );

  // Find semantic label
  expect(
    find.bySemanticsLabel(RegExp(r'伦敦金.*价格.*上涨.*')),
    findsOneWidget,
  );

  // Verify touch target size
  final size = tester.getSize(find.byType(InkWell));
  expect(size.height, greaterThanOrEqualTo(48));
});
```

### Performance Testing

**Approach**: Frame timing analysis

```dart
testWidgets('Animation maintains 60fps', (tester) async {
  await tester.pumpWidget(MyAnimatedWidget());

  await tester.pumpAndSettle();

  final binding = tester.binding as WidgetsFlutterBinding;
  final frameTimings = await binding.runAsync(() async {
    // Trigger animation
    await tester.tap(find.byType(Button));
    await tester.pumpAndSettle();
  });

  // Verify no dropped frames (< 16ms per frame for 60fps)
  for (final timing in frameTimings) {
    expect(timing.totalSpan.inMilliseconds, lessThan(16));
  }
});
```

## Open Questions for Implementation

1. **Custom Font**: Should we use a custom font (e.g., Inter, SF Pro) or stick with system fonts?
   - **Recommendation**: Use system fonts (Roboto on Android, SF Pro on iOS) to avoid bundle size increase

2. **Animation Duration Standard**: Should all animations be exactly 300ms or can we vary (200-400ms)?
   - **Recommendation**: Use 300ms as default, 200ms for micro-interactions, 400ms for complex transitions

3. **Dark Mode Default**: Should dark mode be the default or light mode?
   - **Recommendation**: Follow system preference by default, save user override

4. **Reduce Motion**: Should we support `prefers-reduced-motion` accessibility setting?
   - **Recommendation**: Yes, respect `AccessibilityFeatures.disableAnimations`

5. **Haptic Feedback Default**: Should haptic feedback be enabled by default or opt-in?
   - **Recommendation**: Enabled by default with toggle in Profile settings

## Next Steps

1. Review and approve this design document
2. Create spec deltas for each capability
3. Break down into granular tasks
4. Validate with `openspec validate`
5. Begin implementation starting with design tokens
