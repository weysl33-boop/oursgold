// ignore_for_file: dangling_library_doc_comments

/// Design tokens for consistent spacing, typography, and layout values
///
/// This file provides a centralized design token system aligned with the
/// reference Next.js project design system (project-recreation).
///
/// **Reference Alignment**:
/// - Base spacing: 0.75rem = 12px (--radius in globals.css)
/// - Radius scale: sm(8), md(10), lg(12), xl(16) maps to reference radius variants
/// - Typography: Uses Inter font (see typography.dart)
/// - Spacing follows reference 8pt grid system
///
/// **Usage**:
/// - Always use these tokens instead of hardcoded pixel values
/// - Spacing follows 8pt grid: 4, 8, 12, 16, 20, 24, 32, 48, 64
/// - Border radius options: xs(4), sm(8), md(12), lg(16), xl(24), full(9999)
/// - Elevation scale: 0, 1, 2, 4, 8, 16
///
/// **Reference Mappings** (from project-recreation globals.css):
/// - --radius (0.75rem) → radiusMd (12dp)
/// - --radius-sm (calc(--radius - 4px)) → radiusSm (8dp)
/// - --radius-md (calc(--radius - 2px)) → 10dp (see radiusRefMd)
/// - --radius-lg (--radius) → radiusLg (12dp)
/// - --radius-xl (calc(--radius + 4px)) → radiusXl (16dp)
/// - rounded-xl (12px) → radiusMd
/// - rounded-2xl (16px) → radiusLg
/// - rounded-3xl (24px) → radiusXl
/// - rounded-full (9999px) → radiusFull
library;

class AppDesignTokens {
  // Private constructor to prevent instantiation
  AppDesignTokens._();

  // ============================================================================
  // SPACING SCALE (8pt Grid System)
  // ============================================================================

  /// Spacing 0: 0dp - No spacing
  static const double space0 = 0;

  /// Spacing 1: 4dp - Extra small spacing (icon padding, badge gap)
  static const double space1 = 4;

  /// Spacing 2: 8dp - Small spacing (chip padding, tight elements)
  static const double space2 = 8;

  /// Spacing 3: 12dp - Medium-small spacing (card inner padding)
  static const double space3 = 12;

  /// Spacing 4: 16dp - Base spacing (default padding, standard gaps)
  static const double space4 = 16;

  /// Spacing 5: 20dp - Medium-large spacing (section gaps)
  static const double space5 = 20;

  /// Spacing 6: 24dp - Large spacing (card padding, major sections)
  static const double space6 = 24;

  /// Spacing 8: 32dp - Extra large spacing (screen padding, major sections)
  static const double space8 = 32;

  /// Spacing 12: 48dp - 2X large spacing (major section dividers)
  static const double space12 = 48;

  /// Spacing 16: 64dp - 3X large spacing (screen top/bottom padding)
  static const double space16 = 64;

  // ============================================================================
  // TYPOGRAPHY SCALE
  // ============================================================================

  /// Font size extra small: 10dp - Tiny labels, badges
  static const double fontSizeXs = 10;

  /// Font size small: 12dp - Captions, helper text
  static const double fontSizeSm = 12;

  /// Font size base: 14dp - Body text, default size
  static const double fontSizeBase = 14;

  /// Font size large: 16dp - Emphasized body text, large labels
  static const double fontSizeLg = 16;

  /// Font size extra large: 18dp - Small headings, section titles
  static const double fontSizeXl = 18;

  /// Font size 2X large: 20dp - Medium headings (H3)
  static const double fontSize2xl = 20;

  /// Font size 3X large: 24dp - Large headings (H2)
  static const double fontSize3xl = 24;

  /// Font size 4X large: 32dp - Display headings (H1)
  static const double fontSize4xl = 32;

  // Font weights
  /// Thin weight: 100
  static const int fontWeightThin = 100;

  /// Extra light weight: 200
  static const int fontWeightExtraLight = 200;

  /// Light weight: 300
  static const int fontWeightLight = 300;

  /// Regular weight: 400 - Default for body text
  static const int fontWeightRegular = 400;

  /// Medium weight: 500 - Emphasis, labels
  static const int fontWeightMedium = 500;

  /// Semi-bold weight: 600 - Headings, important text
  static const int fontWeightSemiBold = 600;

  /// Bold weight: 700 - Strong headings, emphasis
  static const int fontWeightBold = 700;

  /// Extra bold weight: 800
  static const int fontWeightExtraBold = 800;

  /// Black weight: 900
  static const int fontWeightBlack = 900;

  // Line heights
  /// Line height tight: 1.2 - For headings
  static const double lineHeightTight = 1.2;

  /// Line height normal: 1.5 - For body text
  static const double lineHeightNormal = 1.5;

  /// Line height relaxed: 1.6 - For long-form content
  static const double lineHeightRelaxed = 1.6;

  /// Line height caption: 1.4 - For captions and labels
  static const double lineHeightCaption = 1.4;

  /// Line height button: 1.0 - For buttons (vertically centered)
  static const double lineHeightButton = 1.0;

  // ============================================================================
  // BORDER RADIUS SCALE (aligned with reference project)
  // ============================================================================

  /// Border radius extra small: 4dp - Small chips, badges
  static const double radiusXs = 4;

  /// Border radius small: 8dp - Buttons, input fields
  /// Reference: --radius-sm (calc(0.75rem - 4px)) = 8px
  static const double radiusSm = 8;

  /// Border radius reference medium: 10dp - Reference specific variant
  /// Reference: --radius-md (calc(0.75rem - 2px)) = 10px
  /// Used in some reference components
  static const double radiusRefMd = 10;

  /// Border radius medium: 12dp - Cards, containers (default)
  /// Reference: --radius-lg (0.75rem) = 12px, rounded-xl
  static const double radiusMd = 12;

  /// Border radius large: 16dp - Large cards, modals
  /// Reference: --radius-xl (calc(0.75rem + 4px)) = 16px, rounded-2xl
  static const double radiusLg = 16;

  /// Border radius extra large: 24dp - Bottom sheets, large modals
  /// Reference: rounded-3xl = 24px
  static const double radiusXl = 24;

  /// Border radius full: 9999dp - Pills, circular elements
  /// Reference: rounded-full
  static const double radiusFull = 9999;

  // ============================================================================
  // ELEVATION SCALE
  // ============================================================================

  /// Elevation 0: No shadow - Flat elements
  static const double elevation0 = 0;

  /// Elevation 1: Subtle shadow - Slightly raised elements
  static const double elevation1 = 1;

  /// Elevation 2: Default shadow - Standard cards
  static const double elevation2 = 2;

  /// Elevation 3: Medium shadow - Raised cards, dropdowns
  static const double elevation3 = 4;

  /// Elevation 4: High shadow - Floating action buttons, prominent cards
  static const double elevation4 = 8;

  /// Elevation 5: Maximum shadow - Modals, dialogs, bottom sheets
  static const double elevation5 = 16;

  // ============================================================================
  // OPACITY SCALE
  // ============================================================================

  /// Opacity 5%: Very subtle tint
  static const double opacity5 = 0.05;

  /// Opacity 10%: Subtle background tint
  static const double opacity10 = 0.10;

  /// Opacity 15%: Light background overlay
  static const double opacity15 = 0.15;

  /// Opacity 20%: Disabled state
  static const double opacity20 = 0.20;

  /// Opacity 30%: Muted state
  static const double opacity30 = 0.30;

  /// Opacity 40%: Placeholder state
  static const double opacity40 = 0.40;

  /// Opacity 50%: Half opacity
  static const double opacity50 = 0.50;

  /// Opacity 60%: Visible but de-emphasized
  static const double opacity60 = 0.60;

  /// Opacity 70%: Slightly transparent
  static const double opacity70 = 0.70;

  /// Opacity 80%: Mostly opaque
  static const double opacity80 = 0.80;

  /// Opacity 90%: Almost fully opaque
  static const double opacity90 = 0.90;

  // ============================================================================
  // ANIMATION DURATIONS (milliseconds)
  // ============================================================================

  /// Duration instant: 0ms - No animation
  static const int durationInstant = 0;

  /// Duration fast: 100ms - Micro-interactions (button press)
  static const int durationFast = 100;

  /// Duration normal: 200ms - Standard transitions (toggle, hover)
  static const int durationNormal = 200;

  /// Duration medium: 300ms - Page transitions, entrances
  static const int durationMedium = 300;

  /// Duration slow: 400ms - Complex transitions
  static const int durationSlow = 400;

  /// Duration very slow: 500ms - Emphasis animations
  static const int durationVerySlow = 500;

  // ============================================================================
  // TOUCH TARGETS
  // ============================================================================

  /// Minimum touch target size: 48dp - Accessibility requirement
  static const double minTouchTarget = 48;

  /// Comfortable touch target: 56dp - Recommended for primary actions
  static const double comfortableTouchTarget = 56;

  // ============================================================================
  // ICON SIZES
  // ============================================================================

  /// Icon size inline: 16dp - Inline with text
  static const double iconSizeInline = 16;

  /// Icon size small: 20dp - Small buttons, labels
  static const double iconSizeSmall = 20;

  /// Icon size standard: 24dp - Default icon size
  static const double iconSizeStandard = 24;

  /// Icon size large: 32dp - Prominent icons, empty states
  static const double iconSizeLarge = 32;

  /// Icon size extra large: 48dp - Feature icons, illustrations
  static const double iconSizeXLarge = 48;

  // ============================================================================
  // GLASSMORPHISM EFFECTS (from reference project)
  // ============================================================================

  /// Backdrop blur sigma: 10 - Blur radius for BackdropFilter
  /// Reference: backdrop-blur effect in reference project
  static const double backdropBlurSigma = 10;

  /// Glassmorphic blur radius: 10dp - Standard blur for glass effects
  /// Used with BackdropFilter widget for dark mode cards
  static const double glassBlurRadius = 10;

  /// Glass effect minimum blur: 5dp - Subtle blur for light glass effect
  static const double glassBlurMin = 5;

  /// Glass effect maximum blur: 15dp - Strong blur for prominent glass effect
  static const double glassBlurMax = 15;

  // ============================================================================
  // SAFE AREA HANDLING (from reference project)
  // ============================================================================

  /// Safe area bottom padding base: 12dp
  /// Reference: max(0.75rem, env(safe-area-inset-bottom)) from .safe-area-pb
  /// Use with: max(safeAreaBottomBase, MediaQuery.of(context).padding.bottom)
  static const double safeAreaBottomBase = 12;

  // ============================================================================
  // REFERENCE PROJECT COMPONENT SIZES
  // ============================================================================

  /// Stock card logo size: 40dp
  /// Reference: w-10 h-10 from stock-card.tsx
  static const double stockCardLogoSize = 40;

  /// Quick pill logo size: 32dp
  /// Reference: w-8 h-8 from home-view.tsx quick pills
  static const double quickPillLogoSize = 32;

  /// Home indicator width: 128dp
  /// Reference: w-32 from bottom-nav.tsx
  static const double homeIndicatorWidth = 128;

  /// Home indicator height: 4dp
  /// Reference: h-1 from bottom-nav.tsx
  static const double homeIndicatorHeight = 4;

  /// Bottom navigation icon size: 24dp
  /// Reference: w-6 h-6 from bottom-nav.tsx
  static const double bottomNavIconSize = 24;

  /// Minimum gap between nav items: 60dp
  /// Reference: min-w-[60px] from bottom-nav.tsx
  static const double bottomNavMinItemWidth = 60;
}

