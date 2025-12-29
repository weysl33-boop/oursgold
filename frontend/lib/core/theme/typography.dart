import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';
import 'colors.dart';

/// Typography system with predefined text styles using Inter font
///
/// This file provides a systematic approach to typography with:
/// - **Font Family**: Inter (from reference project) via Google Fonts
/// - Heading styles (H1, H2, H3) with appropriate weights and line heights
/// - Body text styles (large, base, small) for content
/// - Caption and label styles for secondary information
///
/// All styles use design tokens for consistency and match the reference
/// Next.js project's typography scale.
///
/// Usage:
/// - Use AppTypography.h1 for main page titles
/// - Use AppTypography.bodyBase for standard body text
/// - Use AppTypography.caption for metadata and helper text
///
/// Font weights used (matching reference):
/// - Regular (400): Body text, captions
/// - Medium (500): Labels, emphasized text
/// - Semi-bold (600): Headings, symbol names
/// - Bold (700): Large headings, prices

class AppTypography {
  // Private constructor to prevent instantiation
  AppTypography._();

  // ============================================================================
  // FONT FAMILY (from reference project)
  // ============================================================================

  /// Base text style with Inter font family
  /// Matches reference project: --font-sans: "Inter", "Inter Fallback", system-ui, sans-serif
  static TextStyle _baseTextStyle() => GoogleFonts.inter();

  // ============================================================================
  // HEADING STYLES
  // ============================================================================

  /// Heading 1: Large display heading
  /// Usage: Main screen titles, hero headings
  /// Font size: 32dp, Weight: Bold (700), Line height: 1.2
  static TextStyle h1({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSize4xl,
        fontWeight: FontWeight.w700,
        height: AppDesignTokens.lineHeightTight,
        color: color,
        letterSpacing: -0.5,
      );

  /// Heading 2: Section heading
  /// Usage: Major section titles, card headers
  /// Font size: 24dp, Weight: Semi-bold (600), Line height: 1.3
  static TextStyle h2({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSize3xl,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
        letterSpacing: -0.25,
      );

  /// Heading 3: Subsection heading
  /// Usage: Card titles, list section headers
  /// Font size: 20dp, Weight: Semi-bold (600), Line height: 1.4
  static TextStyle h3({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSize2xl,
        fontWeight: FontWeight.w600,
        height: AppDesignTokens.lineHeightCaption,
        color: color,
      );

  /// Heading 4: Small heading
  /// Usage: Widget titles, emphasized labels
  /// Font size: 18dp, Weight: Semi-bold (600), Line height: 1.4
  static TextStyle h4({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeXl,
        fontWeight: FontWeight.w600,
        height: AppDesignTokens.lineHeightCaption,
        color: color,
      );

  // ============================================================================
  // BODY TEXT STYLES
  // ============================================================================

  /// Body large: Emphasized body text
  /// Usage: Important paragraphs, emphasized content
  /// Font size: 16dp, Weight: Regular (400), Line height: 1.5
  static TextStyle bodyLarge({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeLg,
        fontWeight: FontWeight.w400,
        height: AppDesignTokens.lineHeightNormal,
        color: color,
      );

  /// Body base: Standard body text
  /// Usage: Default paragraph text, content
  /// Font size: 14dp, Weight: Regular (400), Line height: 1.5
  static TextStyle bodyBase({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeBase,
        fontWeight: FontWeight.w400,
        height: AppDesignTokens.lineHeightNormal,
        color: color,
      );

  /// Body small: Compact body text
  /// Usage: Compact lists, secondary content
  /// Font size: 12dp, Weight: Regular (400), Line height: 1.5
  static TextStyle bodySmall({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeSm,
        fontWeight: FontWeight.w400,
        height: AppDesignTokens.lineHeightNormal,
        color: color,
      );

  /// Body medium: Medium weight body text
  /// Usage: Emphasized list items, labels
  /// Font size: 14dp, Weight: Medium (500), Line height: 1.5
  static TextStyle bodyMedium({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeBase,
        fontWeight: FontWeight.w500,
        height: AppDesignTokens.lineHeightNormal,
        color: color,
      );

  // ============================================================================
  // CAPTION & LABEL STYLES
  // ============================================================================

  /// Caption: Small secondary text
  /// Usage: Timestamps, metadata, helper text
  /// Font size: 12dp, Weight: Regular (400), Line height: 1.4
  static TextStyle caption({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeSm,
        fontWeight: FontWeight.w400,
        height: AppDesignTokens.lineHeightCaption,
        color: color ?? AppColors.neutral600,
      );

  /// Caption medium: Emphasized caption
  /// Usage: Important metadata, emphasized labels
  /// Font size: 12dp, Weight: Medium (500), Line height: 1.4
  static TextStyle captionMedium({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeSm,
        fontWeight: FontWeight.w500,
        height: AppDesignTokens.lineHeightCaption,
        color: color ?? AppColors.neutral700,
      );

  /// Label large: Large button and tab labels
  /// Usage: Button text, tab labels
  /// Font size: 16dp, Weight: Medium (500), Line height: 1.0
  static TextStyle labelLarge({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeLg,
        fontWeight: FontWeight.w500,
        height: AppDesignTokens.lineHeightButton,
        color: color,
      );

  /// Label base: Standard labels
  /// Usage: Form labels, standard buttons
  /// Font size: 14dp, Weight: Medium (500), Line height: 1.0
  static TextStyle labelBase({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeBase,
        fontWeight: FontWeight.w500,
        height: AppDesignTokens.lineHeightButton,
        color: color,
      );

  /// Label small: Small labels
  /// Usage: Badges, chips, tiny buttons
  /// Font size: 12dp, Weight: Medium (500), Line height: 1.0
  static TextStyle labelSmall({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeSm,
        fontWeight: FontWeight.w500,
        height: AppDesignTokens.lineHeightButton,
        color: color,
      );

  /// Label extra small: Tiny labels
  /// Usage: Icon badges, micro labels
  /// Font size: 10dp, Weight: Medium (500), Line height: 1.0
  static TextStyle labelXSmall({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeXs,
        fontWeight: FontWeight.w500,
        height: AppDesignTokens.lineHeightButton,
        color: color,
      );

  // ============================================================================
  // SPECIALIZED STYLES
  // ============================================================================

  /// Price text: Large, bold price display
  /// Usage: Market prices, quote displays
  /// Font size: 20dp, Weight: Bold (700), Line height: 1.2
  static TextStyle price({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSize2xl,
        fontWeight: FontWeight.w700,
        height: AppDesignTokens.lineHeightTight,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Price large: Extra large price display
  /// Usage: Detail page prices, featured quotes
  /// Font size: 32dp, Weight: Bold (700), Line height: 1.2
  static TextStyle priceLarge({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSize4xl,
        fontWeight: FontWeight.w700,
        height: AppDesignTokens.lineHeightTight,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Price change: Price change percentage
  /// Usage: +1.08%, -0.52%
  /// Font size: 12dp, Weight: Medium (500), Line height: 1.0
  static TextStyle priceChange({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeSm,
        fontWeight: FontWeight.w500,
        height: AppDesignTokens.lineHeightButton,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Symbol code: Symbol ticker code
  /// Usage: XAUUSD, EURUSD badges
  /// Font size: 10dp, Weight: Semi-bold (600), Line height: 1.0
  static TextStyle symbolCode({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeXs,
        fontWeight: FontWeight.w600,
        height: AppDesignTokens.lineHeightButton,
        color: color,
        letterSpacing: 0.5,
      );

  /// Symbol name: Full symbol name
  /// Usage: 伦敦金, 欧元/美元
  /// Font size: 14dp, Weight: Semi-bold (600), Line height: 1.2
  static TextStyle symbolName({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeBase,
        fontWeight: FontWeight.w600,
        height: AppDesignTokens.lineHeightTight,
        color: color,
      );

  /// Data label: Data grid labels
  /// Usage: Open, High, Low, Close labels
  /// Font size: 12dp, Weight: Regular (400), Line height: 1.4
  static TextStyle dataLabel({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeSm,
        fontWeight: FontWeight.w400,
        height: AppDesignTokens.lineHeightCaption,
        color: color ?? AppColors.neutral600,
      );

  /// Data value: Data grid values
  /// Usage: Numeric data in grids
  /// Font size: 14dp, Weight: Medium (500), Line height: 1.4
  static TextStyle dataValue({Color? color}) => _baseTextStyle().copyWith(
        fontSize: AppDesignTokens.fontSizeBase,
        fontWeight: FontWeight.w500,
        height: AppDesignTokens.lineHeightCaption,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  // ============================================================================
  // FLUTTER TEXTTHEME INTEGRATION
  // ============================================================================

  /// Get TextTheme for Material theme integration
  /// This maps our custom styles to Flutter's TextTheme
  static TextTheme getTextTheme({Color? defaultColor}) {
    return TextTheme(
      // Display styles (large headings)
      displayLarge: h1(color: defaultColor),
      displayMedium: h2(color: defaultColor),
      displaySmall: h3(color: defaultColor),

      // Headline styles
      headlineLarge: h1(color: defaultColor),
      headlineMedium: h2(color: defaultColor),
      headlineSmall: h3(color: defaultColor),

      // Title styles
      titleLarge: h3(color: defaultColor),
      titleMedium: h4(color: defaultColor),
      titleSmall: bodyLarge(color: defaultColor),

      // Body styles
      bodyLarge: bodyLarge(color: defaultColor),
      bodyMedium: bodyBase(color: defaultColor),
      bodySmall: bodySmall(color: defaultColor),

      // Label styles
      labelLarge: labelLarge(color: defaultColor),
      labelMedium: labelBase(color: defaultColor),
      labelSmall: labelSmall(color: defaultColor),
    );
  }
}
