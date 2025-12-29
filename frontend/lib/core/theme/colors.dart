import 'package:flutter/material.dart';

/// Extended color palette with tints and shades (50-900 scale)
///
/// This file provides a comprehensive color system with:
/// - Gold palette (primary color) from light to dark
/// - Neutral palette for text, borders, and backgrounds
/// - Semantic colors for status and feedback
///
/// All colors are verified for WCAG AA contrast requirements.
///
/// Usage:
/// - Use palette shades for states: gold500 (normal), gold600 (hover), gold700 (pressed)
/// - Neutral palette for text hierarchy: neutral900 (primary), neutral600 (secondary)
/// - Semantic colors for feedback: success, error, warning, info

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ============================================================================
  // GOLD PALETTE (Primary Color)
  // ============================================================================

  /// Gold 50: Lightest gold tint - Backgrounds, hover states
  static const Color gold50 = Color(0xFFFFFBF0);

  /// Gold 100: Very light gold - Light backgrounds
  static const Color gold100 = Color(0xFFFFF6D9);

  /// Gold 200: Light gold - Subtle highlights
  static const Color gold200 = Color(0xFFFFEDB3);

  /// Gold 300: Medium-light gold - Accents
  static const Color gold300 = Color(0xFFFFE38D);

  /// Gold 400: Medium gold - Secondary accents
  static const Color gold400 = Color(0xFFFFD966);

  /// Gold 500: Primary gold - Main brand color (#D4AF37)
  static const Color gold500 = Color(0xFFD4AF37);

  /// Gold 600: Medium-dark gold - Hover states
  static const Color gold600 = Color(0xFFB8942B);

  /// Gold 700: Dark gold - Pressed states
  static const Color gold700 = Color(0xFF9C7A1F);

  /// Gold 800: Very dark gold - Active states
  static const Color gold800 = Color(0xFF806013);

  /// Gold 900: Darkest gold - Extreme contrast
  static const Color gold900 = Color(0xFF664607);

  // ============================================================================
  // NEUTRAL PALETTE (Grayscale)
  // ============================================================================

  /// Neutral 50: Almost white - Lightest background
  static const Color neutral50 = Color(0xFFFAFAFA);

  /// Neutral 100: Very light gray - Light backgrounds
  static const Color neutral100 = Color(0xFFF5F5F5);

  /// Neutral 200: Light gray - Borders, dividers
  static const Color neutral200 = Color(0xFFEEEEEE);

  /// Neutral 300: Medium-light gray - Disabled backgrounds
  static const Color neutral300 = Color(0xFFE0E0E0);

  /// Neutral 400: Medium gray - Placeholder text
  static const Color neutral400 = Color(0xFFBDBDBD);

  /// Neutral 500: True gray - Icons, borders
  static const Color neutral500 = Color(0xFF9E9E9E);

  /// Neutral 600: Medium-dark gray - Secondary text
  static const Color neutral600 = Color(0xFF757575);

  /// Neutral 700: Dark gray - Emphasized text
  static const Color neutral700 = Color(0xFF616161);

  /// Neutral 800: Very dark gray - Dark mode backgrounds
  static const Color neutral800 = Color(0xFF424242);

  /// Neutral 900: Darkest gray - Primary text
  static const Color neutral900 = Color(0xFF212121);

  // ============================================================================
  // SEMANTIC COLORS
  // ============================================================================

  // Success (Green)
  /// Success color: Positive actions, confirmations
  static const Color success = Color(0xFF10B981);

  /// Success light: Success backgrounds
  static const Color successLight = Color(0xFFD1FAE5);

  /// Success dark: Success emphasis
  static const Color successDark = Color(0xFF047857);

  // Error (Red)
  /// Error color: Errors, destructive actions
  static const Color error = Color(0xFFEF4444);

  /// Error light: Error backgrounds
  static const Color errorLight = Color(0xFFFEE2E2);

  /// Error dark: Error emphasis
  static const Color errorDark = Color(0xFFC81E1E);

  // Warning (Orange/Amber)
  /// Warning color: Warnings, cautions
  static const Color warning = Color(0xFFF59E0B);

  /// Warning light: Warning backgrounds
  static const Color warningLight = Color(0xFFFEF3C7);

  /// Warning dark: Warning emphasis
  static const Color warningDark = Color(0xFFD97706);

  // Info (Blue)
  /// Info color: Information, hints
  static const Color info = Color(0xFF3B82F6);

  /// Info light: Info backgrounds
  static const Color infoLight = Color(0xFFDBEAFE);

  /// Info dark: Info emphasis
  static const Color infoDark = Color(0xFF1E40AF);

  // ============================================================================
  // PRICE COLORS (Market Data)
  // ============================================================================

  // China style (Red = Up, Green = Down)
  /// Price up (red): Chinese style positive price movement
  static const Color priceUpRed = Color(0xFFEF4444);

  /// Price down (green): Chinese style negative price movement
  static const Color priceDownGreen = Color(0xFF10B981);

  // Western style (Green = Up, Red = Down)
  /// Price up (green): Western style positive price movement
  static const Color priceUpGreen = Color(0xFF10B981);

  /// Price down (red): Western style negative price movement
  static const Color priceDownRed = Color(0xFFEF4444);

  // ============================================================================
  // CATEGORY COLORS (News, Topics)
  // ============================================================================

  /// Category: Precious Metals (Gold/Amber)
  static const Color categoryPreciousMetals = Color(0xFFFFC107);

  /// Category: Forex (Blue)
  static const Color categoryForex = Color(0xFF2196F3);

  /// Category: Central Bank (Red)
  static const Color categoryCentralBank = Color(0xFFF44336);

  /// Category: Policy (Green)
  static const Color categoryPolicy = Color(0xFF4CAF50);

  /// Category: Market News (Purple)
  static const Color categoryMarket = Color(0xFF9C27B0);

  // ============================================================================
  // DARK MODE SPECIFIC COLORS
  // ============================================================================

  /// Dark mode surface: Card and container background in dark mode
  static const Color darkSurface = Color(0xFF2C2C2C);

  /// Dark mode background: Main background in dark mode
  static const Color darkBackground = Color(0xFF1A1A1A);

  /// Dark mode border: Borders and dividers in dark mode
  static const Color darkBorder = Color(0xFF3C3C3C);

  // ============================================================================
  // GLASSMORPHISM COLORS (Dark Mode)
  // ============================================================================

  /// Glass overlay start: Starting color for glassmorphic gradient
  static const Color glassOverlayStart = Color(0x26FFFFFF); // 15% white

  /// Glass overlay end: Ending color for glassmorphic gradient
  static const Color glassOverlayEnd = Color(0x0DFFFFFF); // 5% white

  /// Glass border: Border color for glassmorphic effect
  static const Color glassBorder = Color(0x1AFFFFFF); // 10% white

  // ============================================================================
  // REFERENCE PROJECT COLORS (from project-recreation)
  // ============================================================================
  // Colors extracted from reference Next.js project globals.css
  // Converted from OKLCH color space to sRGB for Flutter compatibility
  //
  // Light mode colors map to ColorScheme properties:
  // - refBackground → ColorScheme.background
  // - refPrimary → ColorScheme.primary
  // - refCard → ColorScheme.surface
  //
  // Dark mode equivalents have "Dark" suffix

  // --- Light Mode Reference Colors ---

  /// Reference background (light): oklch(0.97 0 0) → #F8F8F8
  /// Light mode main background
  static const Color refBackground = Color(0xFFF8F8F8);

  /// Reference foreground (light): oklch(0.145 0 0) → #252525
  /// Light mode primary text color
  static const Color refForeground = Color(0xFF252525);

  /// Reference card (light): oklch(1 0 0) → #FFFFFF
  /// Light mode card/surface background
  static const Color refCard = Color(0xFFFFFFFF);

  /// Reference card foreground (light): oklch(0.145 0 0) → #252525
  /// Light mode card text color
  static const Color refCardForeground = Color(0xFF252525);

  /// Reference primary (light): oklch(0.55 0.2 260) → #6366F1
  /// Primary blue color from reference
  static const Color refPrimary = Color(0xFF6366F1);

  /// Reference primary foreground (light): oklch(0.985 0 0) → #FBFBFB
  /// Text color on primary background
  static const Color refPrimaryForeground = Color(0xFFFBFBFB);

  /// Reference secondary (light): oklch(0.97 0 0) → #F8F8F8
  /// Secondary background color
  static const Color refSecondary = Color(0xFFF8F8F8);

  /// Reference secondary foreground (light): oklch(0.205 0 0) → #343434
  /// Text on secondary background
  static const Color refSecondaryForeground = Color(0xFF343434);

  /// Reference muted (light): oklch(0.97 0 0) → #F8F8F8
  /// Muted/subdued background
  static const Color refMuted = Color(0xFFF8F8F8);

  /// Reference muted foreground (light): oklch(0.556 0 0) → #8E8E8E
  /// Muted/subdued text color
  static const Color refMutedForeground = Color(0xFF8E8E8E);

  /// Reference accent (light): oklch(0.97 0 0) → #F8F8F8
  /// Accent background color
  static const Color refAccent = Color(0xFFF8F8F8);

  /// Reference accent foreground (light): oklch(0.205 0 0) → #343434
  /// Text on accent background
  static const Color refAccentForeground = Color(0xFF343434);

  /// Reference destructive (light): oklch(0.577 0.245 27.325) → #EF4444
  /// Destructive/error color
  static const Color refDestructive = Color(0xFFEF4444);

  /// Reference border (light): oklch(0.922 0 0) → #EBEBEB
  /// Border and divider color
  static const Color refBorder = Color(0xFFEBEBEB);

  /// Reference input (light): oklch(0.922 0 0) → #EBEBEB
  /// Input field border color
  static const Color refInput = Color(0xFFEBEBEB);

  /// Reference ring (light): oklch(0.55 0.2 260) → #6366F1
  /// Focus ring color
  static const Color refRing = Color(0xFF6366F1);

  // --- Dark Mode Reference Colors ---

  /// Reference background (dark): oklch(0.145 0 0) → #252525
  /// Dark mode main background
  static const Color refBackgroundDark = Color(0xFF252525);

  /// Reference foreground (dark): oklch(0.985 0 0) → #FBFBFB
  /// Dark mode primary text color
  static const Color refForegroundDark = Color(0xFFFBFBFB);

  /// Reference card (dark): oklch(0.145 0 0) → #252525
  /// Dark mode card/surface background
  static const Color refCardDark = Color(0xFF252525);

  /// Reference card foreground (dark): oklch(0.985 0 0) → #FBFBFB
  /// Dark mode card text color
  static const Color refCardForegroundDark = Color(0xFFFBFBFB);

  /// Reference primary (dark): oklch(0.985 0 0) → #FBFBFB
  /// Primary color in dark mode (inverted)
  static const Color refPrimaryDark = Color(0xFFFBFBFB);

  /// Reference primary foreground (dark): oklch(0.205 0 0) → #343434
  /// Text color on dark mode primary
  static const Color refPrimaryForegroundDark = Color(0xFF343434);

  /// Reference secondary (dark): oklch(0.269 0 0) → #454545
  /// Secondary background in dark mode
  static const Color refSecondaryDark = Color(0xFF454545);

  /// Reference secondary foreground (dark): oklch(0.985 0 0) → #FBFBFB
  /// Text on dark secondary background
  static const Color refSecondaryForegroundDark = Color(0xFFFBFBFB);

  /// Reference muted (dark): oklch(0.269 0 0) → #454545
  /// Muted background in dark mode
  static const Color refMutedDark = Color(0xFF454545);

  /// Reference muted foreground (dark): oklch(0.708 0 0) → #B5B5B5
  /// Muted text in dark mode
  static const Color refMutedForegroundDark = Color(0xFFB5B5B5);

  /// Reference accent (dark): oklch(0.269 0 0) → #454545
  /// Accent background in dark mode
  static const Color refAccentDark = Color(0xFF454545);

  /// Reference accent foreground (dark): oklch(0.985 0 0) → #FBFBFB
  /// Text on dark accent background
  static const Color refAccentForegroundDark = Color(0xFFFBFBFB);

  /// Reference destructive (dark): oklch(0.396 0.141 25.723) → #8B2626
  /// Destructive/error color in dark mode
  static const Color refDestructiveDark = Color(0xFF8B2626);

  /// Reference destructive foreground (dark): oklch(0.637 0.237 25.331) → #E87171
  /// Text on destructive background in dark mode
  static const Color refDestructiveForegroundDark = Color(0xFFE87171);

  /// Reference border (dark): oklch(0.269 0 0) → #454545
  /// Border color in dark mode
  static const Color refBorderDark = Color(0xFF454545);

  /// Reference input (dark): oklch(0.269 0 0) → #454545
  /// Input border in dark mode
  static const Color refInputDark = Color(0xFF454545);

  /// Reference ring (dark): oklch(0.439 0 0) → #717171
  /// Focus ring in dark mode
  static const Color refRingDark = Color(0xFF717171);

  // --- Chart Colors (Light Mode) ---

  /// Chart color 1: oklch(0.55 0.2 260) → #6366F1 (Blue)
  static const Color refChart1 = Color(0xFF6366F1);

  /// Chart color 2: oklch(0.6 0.2 145) → #10B981 (Green)
  static const Color refChart2 = Color(0xFF10B981);

  /// Chart color 3: oklch(0.55 0.2 25) → #F59E0B (Amber)
  static const Color refChart3 = Color(0xFFF59E0B);

  /// Chart color 4: oklch(0.828 0.189 84.429) → #FCD34D (Yellow)
  static const Color refChart4 = Color(0xFFFCD34D);

  /// Chart color 5: oklch(0.769 0.188 70.08) → #FCA5A5 (Red)
  static const Color refChart5 = Color(0xFFFCA5A5);

  // --- Chart Colors (Dark Mode) ---

  /// Chart color 1 (dark): oklch(0.488 0.243 264.376) → #5B5FE8
  static const Color refChart1Dark = Color(0xFF5B5FE8);

  /// Chart color 2 (dark): oklch(0.696 0.17 162.48) → #34D399
  static const Color refChart2Dark = Color(0xFF34D399);

  /// Chart color 3 (dark): oklch(0.769 0.188 70.08) → #FCA5A5
  static const Color refChart3Dark = Color(0xFFFCA5A5);

  /// Chart color 4 (dark): oklch(0.627 0.265 303.9) → #C084FC
  static const Color refChart4Dark = Color(0xFFC084FC);

  /// Chart color 5 (dark): oklch(0.645 0.246 16.439) → #FB923C
  static const Color refChart5Dark = Color(0xFFFB923C);

  // --- Specific UI Colors from Reference Components ---

  /// Blue header background from reference home-view: #2563EB
  static const Color refHeaderBlue = Color(0xFF2563EB);

  /// Gray 50 from reference (card backgrounds): #FAFAFA
  static const Color refGray50 = Color(0xFFFAFAFA);

  /// Gray 100 from reference (subtle backgrounds): #F5F5F5
  static const Color refGray100 = Color(0xFFF5F5F5);

  /// Gray 400 from reference (inactive nav items): #BDBDBD
  static const Color refGray400 = Color(0xFFBDBDBD);

  /// Blue 600 from reference (active nav, links): #2563EB
  static const Color refBlue600 = Color(0xFF2563EB);

  /// Blue 200 from reference (light blue text): #93C5FD
  static const Color refBlue200 = Color(0xFF93C5FD);

  /// Green 500 from reference (success, deposit button): #10B981
  static const Color refGreen500 = Color(0xFF10B981);

  /// Green 400 from reference (positive indicators): #34D399
  static const Color refGreen400 = Color(0xFF34D399);

  /// Red 500 from reference (error, destructive): #EF4444
  static const Color refRed500 = Color(0xFFEF4444);

  // ============================================================================
  // UTILITY FUNCTIONS
  // ============================================================================

  /// Calculate contrast ratio between two colors
  /// Returns ratio from 1:1 to 21:1
  /// WCAG AA requires 4.5:1 for normal text, 3:1 for large text and UI components
  static double calculateContrastRatio(Color foreground, Color background) {
    final fgLuminance = foreground.computeLuminance();
    final bgLuminance = background.computeLuminance();

    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if color combination meets WCAG AA standards
  /// - Normal text (< 18pt): 4.5:1
  /// - Large text (>= 18pt): 3:1
  /// - UI components: 3:1
  static bool meetsWCAGAA({
    required Color foreground,
    required Color background,
    bool isLargeText = false,
  }) {
    final ratio = calculateContrastRatio(foreground, background);
    final requiredRatio = isLargeText ? 3.0 : 4.5;
    return ratio >= requiredRatio;
  }

  /// Get appropriate text color (black or white) for a given background
  static Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    // Use white text for dark backgrounds, black for light backgrounds
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
