# Design Document: Migrate Reference Design System

## Overview

This document outlines the architectural decisions and technical approach for migrating the design system from the Next.js/React reference project to the Flutter mobile application. The goal is to achieve visual consistency between platforms while respecting Flutter's widget system and mobile UX patterns.

## Architecture

### Design System Layers

```
┌─────────────────────────────────────────────────────────┐
│                  Application Layer                       │
│  (Screens: Home, Quotes, Forex, Community, Profile)    │
└────────────────┬────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────┐
│               Component Layer                            │
│  (MarketCard, BottomNav, Header, WatchlistItem)        │
└────────────────┬────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────┐
│              Design Token Layer                          │
│  (colors.dart, typography.dart, design_tokens.dart)    │
└────────────────┬────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────┐
│               Theme System Layer                         │
│         (app_theme.dart: lightTheme, darkTheme)        │
└─────────────────────────────────────────────────────────┘
```

### Migration Flow

```
Reference Project                Flutter Application
┌──────────────────┐            ┌─────────────────────┐
│  globals.css     │            │   colors.dart       │
│  (OKLCH colors)  │───────────▶│   (Flutter Color)   │
└──────────────────┘            └─────────────────────┘

┌──────────────────┐            ┌─────────────────────┐
│  Inter font      │            │   typography.dart   │
│  (web typography)│───────────▶│   (TextStyle)       │
└──────────────────┘            └─────────────────────┘

┌──────────────────┐            ┌─────────────────────┐
│  stock-card.tsx  │            │   market_card.dart  │
│  (React/TSX)     │───────────▶│   (Flutter Widget)  │
└──────────────────┘            └─────────────────────┘

┌──────────────────┐            ┌─────────────────────┐
│  bottom-nav.tsx  │            │ bottom_nav_shell.dart│
│  (React/TSX)     │───────────▶│   (Flutter Widget)  │
└──────────────────┘            └─────────────────────┘
```

## Key Design Decisions

### 1. Color System Migration

**Challenge**: Reference uses OKLCH color space, Flutter uses sRGB.

**Decision**: Convert OKLCH → sRGB with visual validation
- Use precise conversion formulas (OKLCH → XYZ → sRGB)
- Accept delta-E < 2.0 as acceptable difference
- Document any perceptual differences
- Maintain WCAG contrast ratios post-conversion

**Rationale**:
- OKLCH provides perceptual uniformity and better dark mode
- sRGB is Flutter's native color space
- Visual validation ensures acceptable results
- Contrast preservation is critical for accessibility

**Implementation**:
```dart
// Before (existing)
static const Color gold500 = Color(0xFFD4AF37);

// After (reference-derived with OKLCH conversion)
static const Color primary = Color(0xFF6366F1);  // oklch(0.55 0.2 260)
static const Color background = Color(0xFFF8F8F8); // oklch(0.97 0 0)
```

### 2. Typography System

**Challenge**: Reference uses Inter font with web-specific rem units, Flutter uses logical pixels.

**Decision**: Adopt Inter font with mobile-optimized scale
- Use Google Fonts package for Inter
- Convert rem → dp (0.75rem = 12dp base)
- Adjust line heights for mobile readability
- Preserve relative scale relationships

**Rationale**:
- Inter is designed for digital interfaces
- Mobile screens need adjusted line heights
- Logical pixel scaling works across densities
- Google Fonts ensures consistent rendering

**Implementation**:
```dart
// Typography scale aligned with reference
static TextStyle headingLarge() => GoogleFonts.inter(
  fontSize: 32,      // Matches reference ~2rem
  fontWeight: FontWeight.w700,
  height: 1.2,       // Adjusted for mobile
  letterSpacing: -0.5,
);
```

### 3. Design Tokens Harmonization

**Challenge**: Different token systems (CSS variables vs Dart constants).

**Decision**: Create 1:1 mapping with Flutter-appropriate values
- Spacing: 0.75rem base = 12dp in Flutter
- Radius: Map sm/md/lg/xl to 8/12/16/20 dp
- Elevation: Preserve visual intent, adapt to Material elevation scale
- Safe areas: Use Flutter's SafeArea widget + custom utilities

**Rationale**:
- Maintains visual consistency
- Respects platform conventions
- Enables easy updates from reference
- Clear mapping aids maintenance

**Token Mapping Table**:
| Reference CSS           | Flutter Constant        | Value |
|------------------------|-------------------------|-------|
| `--radius` (0.75rem)   | `radiusMd`             | 12.0  |
| `--radius-sm`          | `radiusSm`             | 8.0   |
| `--radius-lg`          | `radiusLg`             | 16.0  |
| `--radius-xl`          | `radiusXl`             | 20.0  |
| `--color-primary`      | `AppColors.primary`    | #6366F1 |

### 4. Component Style Migration

**Challenge**: React/TSX components → Flutter widgets with different paradigms.

**Decision**: Preserve visual intent, adapt to Flutter idioms
- Extract visual properties (colors, spacing, borders)
- Map className patterns to Widget composition
- Use Flutter's built-in widgets (Card, InkWell) where appropriate
- Create custom widgets only when necessary

**Example Migration** (StockCard → MarketCard):

```tsx
// Reference (stock-card.tsx)
<div className="flex-1 bg-gray-50 rounded-2xl p-4">
  <div className="flex items-center gap-2 mb-4">
    <div className="w-10 h-10 bg-white rounded-xl flex items-center justify-center shadow-sm">
      <span className={`text-lg font-bold ${logoColor}`}>{logo}</span>
    </div>
  </div>
</div>
```

```dart
// Flutter (market_card.dart)
Card(
  color: AppColors.neutral50,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16), // rounded-2xl
  ),
  child: Padding(
    padding: const EdgeInsets.all(16), // p-4
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 40, height: 40, // w-10 h-10
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12), // rounded-xl
                boxShadow: [BoxShadow(...)], // shadow-sm
              ),
              child: Center(
                child: Text(logo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
)
```

### 5. Glassmorphism Implementation

**Challenge**: Reference uses CSS backdrop-filter, Flutter has BackdropFilter widget.

**Decision**: Implement glassmorphism selectively with performance monitoring
- Use BackdropFilter for dark mode cards
- Limit blur radius to maintain performance
- Provide fallback for low-end devices
- Test extensively on physical devices

**Rationale**:
- BackdropFilter can be expensive
- Dark mode benefits most from glassmorphism
- Performance is critical for smooth UX
- Graceful degradation maintains compatibility

**Implementation**:
```dart
class GlassmorphicContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final useGlass = isDark && !isLowEndDevice;

    if (useGlass) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.glassOverlayStart,
                  AppColors.glassOverlayEnd,
                ],
              ),
              border: Border.all(color: AppColors.glassBorder),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      );
    }

    // Fallback for light mode or low-end devices
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
```

### 6. Animation Pattern Alignment

**Challenge**: Reference uses tw-animate-css, Flutter uses flutter_animate.

**Decision**: Map animation patterns semantically, not literally
- Identify animation intent (fade-in, slide-up, etc.)
- Use flutter_animate equivalents
- Match durations and easing curves
- Respect reduce-motion preferences

**Rationale**:
- Different animation systems, same visual result
- Flutter animate is declarative and performant
- Semantic mapping maintains design intent
- Accessibility requires reduce-motion support

**Animation Mapping**:
| Reference Pattern    | Flutter Implementation          | Duration |
|---------------------|--------------------------------|----------|
| `animate-fade-in`   | `.animate().fadeIn()`          | 200ms    |
| `animate-slide-up`  | `.animate().slideY(begin: 0.1)`| 250ms    |
| `hover:scale-105`   | Scale on tap (mobile)          | 150ms    |

### 7. Safe Area Handling

**Challenge**: Reference uses CSS `safe-area-inset-*`, Flutter has SafeArea widget.

**Decision**: Combine SafeArea widget with custom padding utilities
- Use SafeArea for screen-level layouts
- Create `safe-area-pb` equivalent for bottom padding
- Handle notch, status bar, and navigation bar
- Test on devices with various safe area configurations

**Implementation**:
```dart
// Utility for safe area bottom padding (matches reference safe-area-pb)
EdgeInsets safePaddingBottom(BuildContext context) {
  final padding = MediaQuery.of(context).padding;
  return EdgeInsets.only(bottom: max(12.0, padding.bottom));
}

// Usage in bottom navigation
Padding(
  padding: safePaddingBottom(context),
  child: BottomNavigationBar(...),
)
```

## Data Flow

### Theme Application Flow

```
1. App Startup
   ├─▶ Load theme preference (light/dark)
   ├─▶ Initialize ThemeData from app_theme.dart
   └─▶ Apply to MaterialApp

2. Component Rendering
   ├─▶ Read theme via Theme.of(context)
   ├─▶ Access design tokens (AppColors, AppTypography, AppDesignTokens)
   ├─▶ Apply styles to widgets
   └─▶ Render UI

3. Theme Switch
   ├─▶ User toggles light/dark mode
   ├─▶ Update theme provider state
   ├─▶ MaterialApp rebuilds with new theme
   └─▶ All components re-render with new colors
```

### Color Resolution Flow

```
1. Reference Project
   CSS Variable: --primary → oklch(0.55 0.2 260)

2. Conversion
   OKLCH → XYZ → sRGB → Hex (#6366F1)

3. Flutter Definition
   static const Color primary = Color(0xFF6366F1);

4. Theme Integration
   ColorScheme.light(primary: AppColors.primary)

5. Component Usage
   Theme.of(context).colorScheme.primary
```

## Trade-offs

### 1. Color Conversion Accuracy

**Trade-off**: Exact perceptual matching vs implementation simplicity

**Decision**: Accept small perceptual differences (delta-E < 2.0)

**Impact**:
- ✅ Faster implementation (no custom color space libraries)
- ✅ Standard Flutter Color objects
- ❌ Minor color differences between web and mobile
- ⚠️ Requires visual validation for each color

### 2. Glassmorphism Performance

**Trade-off**: Visual fidelity vs performance

**Decision**: Use selectively with fallback for low-end devices

**Impact**:
- ✅ Premium look in dark mode
- ✅ Maintains performance on modern devices
- ❌ Extra complexity (device detection)
- ⚠️ Different appearance on low-end devices

### 3. Inter Font

**Trade-off**: Reference font vs native system fonts

**Decision**: Use Inter for brand consistency

**Impact**:
- ✅ Visual consistency with reference
- ✅ Modern, readable typeface
- ❌ ~300KB app size increase
- ⚠️ Slight rendering differences across platforms

### 4. Component Fidelity

**Trade-off**: Pixel-perfect matching vs Flutter best practices

**Decision**: Preserve visual intent, adapt to Flutter idioms

**Impact**:
- ✅ Native feel on mobile
- ✅ Maintainable Flutter code
- ❌ Not pixel-perfect match
- ⚠️ Requires design judgment for adaptations

## Integration Points

### With Existing Codebase

**Theme System**:
- Extends existing `app_theme.dart`, `colors.dart`, `typography.dart`
- Maintains backward compatibility with deprecated constants
- Gradual migration path for existing components

**Widgets**:
- Updates `market_card.dart`, `bottom_nav_shell.dart` in place
- New widgets for header/balance card
- Minimal changes to page-level components

**State Management**:
- No changes to Riverpod providers
- Theme preference provider remains unchanged
- Component state logic unaffected

### With polish-ui-design Proposal

**Coordination Points**:
1. **Design Tokens**: Share definitions to avoid conflicts
2. **Animation System**: Align animation patterns
3. **Component Ownership**: Clear boundaries (reference migration vs polish)
4. **Timeline**: This proposal informs polish-ui-design

**Shared Artifacts**:
- Design token files (`colors.dart`, `typography.dart`, `design_tokens.dart`)
- Animation utilities
- Glassmorphism components
- Documentation

## Testing Strategy

### Visual Regression Testing

```
1. Capture reference screenshots (web)
2. Implement Flutter components
3. Capture Flutter screenshots (mobile)
4. Side-by-side comparison
5. Measure color differences (delta-E)
6. Document acceptable variances
```

### Performance Testing

```
1. Profile frame rendering times
2. Test on low-end devices
3. Measure glassmorphism impact
4. Monitor app size increase
5. Test animation smoothness (60fps requirement)
```

### Accessibility Testing

```
1. Screen reader testing (TalkBack, VoiceOver)
2. Color contrast verification (WCAG AA)
3. Touch target size validation (48dp minimum)
4. Large text size testing
5. Reduce motion testing
```

## Rollout Plan

### Phase 1: Foundation (Week 1)
- Extract and document design tokens
- Convert colors and validate
- Update theme system
- No user-visible changes

### Phase 2: Core Components (Week 2-3)
- Update MarketCard
- Update BottomNav
- Implement header/balance card
- Feature flag for gradual rollout

### Phase 3: Polish (Week 3-4)
- Glassmorphism effects
- Animation alignment
- Performance optimization
- Full rollout

## Monitoring and Success Metrics

### Visual Quality Metrics
- Color delta-E < 2.0 for all conversions
- Designer approval on visual comparison
- User testing feedback positive

### Performance Metrics
- Frame rate: 60fps maintained
- App size: < 1MB increase
- Animation jank: 0 dropped frames

### Code Quality Metrics
- All widget tests passing
- Code review approval
- Documentation complete
- No accessibility regressions

## Future Considerations

### Design System Evolution
- Plan for updating from reference when it changes
- Versioning strategy for design tokens
- Documentation of reference → Flutter mappings

### Platform Expansion
- If web version needed, can use reference directly
- Tablet layouts may need adaptations
- Desktop considerations (future)

### Component Library
- Potential to extract reusable components
- Storybook or similar for component documentation
- Shared design system package (future)
