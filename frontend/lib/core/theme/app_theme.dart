import 'package:flutter/material.dart';
import 'colors.dart';
import 'design_tokens.dart';
import 'typography.dart';

/// Application theme configuration with design tokens integration
class AppTheme {
  // Keep backward compatibility with old color constants
  @Deprecated('Use AppColors.gold500 instead')
  static const Color primaryColor = AppColors.gold500;

  @Deprecated('Use AppColors.neutral800 instead')
  static const Color secondaryColor = AppColors.neutral800;

  @Deprecated('Use AppColors.warning instead')
  static const Color accentColor = AppColors.warning;

  @Deprecated('Use AppColors.success instead')
  static const Color successColor = AppColors.success;

  @Deprecated('Use AppColors.error instead')
  static const Color errorColor = AppColors.error;

  @Deprecated('Use AppColors.warning instead')
  static const Color warningColor = AppColors.warning;

  @Deprecated('Use AppColors.info instead')
  static const Color infoColor = AppColors.info;

  @Deprecated('Use AppColors.priceUpRed instead')
  static const Color priceUpRed = AppColors.priceUpRed;

  @Deprecated('Use AppColors.priceDownGreen instead')
  static const Color priceDownGreen = AppColors.priceDownGreen;

  @Deprecated('Use AppColors.priceUpGreen instead')
  static const Color priceUpGreen = AppColors.priceUpGreen;

  @Deprecated('Use AppColors.priceDownRed instead')
  static const Color priceDownRed = AppColors.priceDownRed;

  @Deprecated('Use AppColors.neutral900 instead')
  static const Color textPrimary = AppColors.neutral900;

  @Deprecated('Use AppColors.neutral600 instead')
  static const Color textSecondary = AppColors.neutral600;

  @Deprecated('Use AppColors.neutral300 instead')
  static const Color textDisabled = AppColors.neutral300;

  @Deprecated('Use AppColors.neutral50 instead')
  static const Color backgroundLight = AppColors.neutral50;

  @Deprecated('Use AppColors.darkBackground instead')
  static const Color backgroundDark = AppColors.darkBackground;

  /// Light theme with design tokens
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.gold500,
      scaffoldBackgroundColor: AppColors.neutral50,
      colorScheme: const ColorScheme.light(
        primary: AppColors.gold500,
        primaryContainer: AppColors.gold100,
        secondary: AppColors.neutral800,
        secondaryContainer: AppColors.neutral100,
        tertiary: AppColors.warning,
        error: AppColors.error,
        errorContainer: AppColors.errorLight,
        surface: Colors.white,
        surfaceTint: AppColors.gold50,
        onPrimary: Colors.white,
        onPrimaryContainer: AppColors.gold900,
        onSecondary: Colors.white,
        onSecondaryContainer: AppColors.neutral900,
        onSurface: AppColors.neutral900,
        onError: Colors.white,
        outline: AppColors.neutral300,
        outlineVariant: AppColors.neutral200,
      ),
      textTheme: AppTypography.getTextTheme(defaultColor: AppColors.neutral900),
      appBarTheme: const AppBarTheme(
        elevation: AppDesignTokens.elevation0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.neutral900,
        iconTheme: IconThemeData(
          color: AppColors.neutral900,
          size: AppDesignTokens.iconSizeStandard,
        ),
      ),
      cardTheme: CardTheme(
        elevation: AppDesignTokens.elevation2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMd),
        ),
        color: Colors.white,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
          borderSide: const BorderSide(color: AppColors.neutral300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
          borderSide: const BorderSide(color: AppColors.gold500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.space4,
          vertical: AppDesignTokens.space3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold500,
          foregroundColor: Colors.white,
          elevation: AppDesignTokens.elevation0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.space6,
            vertical: AppDesignTokens.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
          ),
          minimumSize: const Size(
            AppDesignTokens.minTouchTarget,
            AppDesignTokens.minTouchTarget,
          ),
          textStyle: AppTypography.labelLarge(),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.neutral700,
        size: AppDesignTokens.iconSizeStandard,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.neutral200,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Dark theme with design tokens
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.gold500,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold500,
        primaryContainer: AppColors.gold900,
        secondary: AppColors.neutral600,
        secondaryContainer: AppColors.neutral800,
        tertiary: AppColors.warning,
        error: AppColors.error,
        errorContainer: AppColors.errorDark,
        surface: AppColors.darkSurface,
        surfaceTint: AppColors.gold900,
        onPrimary: Colors.black,
        onPrimaryContainer: AppColors.gold100,
        onSecondary: Colors.white,
        onSecondaryContainer: AppColors.neutral100,
        onSurface: Colors.white,
        onError: Colors.white,
        outline: AppColors.neutral700,
        outlineVariant: AppColors.neutral800,
      ),
      textTheme: AppTypography.getTextTheme(defaultColor: Colors.white),
      appBarTheme: const AppBarTheme(
        elevation: AppDesignTokens.elevation0,
        centerTitle: true,
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: AppDesignTokens.iconSizeStandard,
        ),
      ),
      cardTheme: CardTheme(
        elevation: AppDesignTokens.elevation1,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMd),
        ),
        color: AppColors.darkSurface,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
          borderSide: const BorderSide(color: AppColors.neutral700, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
          borderSide: const BorderSide(color: AppColors.gold500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.space4,
          vertical: AppDesignTokens.space3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold500,
          foregroundColor: Colors.black,
          elevation: AppDesignTokens.elevation0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.space6,
            vertical: AppDesignTokens.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
          ),
          minimumSize: const Size(
            AppDesignTokens.minTouchTarget,
            AppDesignTokens.minTouchTarget,
          ),
          textStyle: AppTypography.labelLarge(),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.neutral300,
        size: AppDesignTokens.iconSizeStandard,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.neutral800,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

/// Theme mode preference
enum PriceColorMode {
  redUpGreenDown, // China style
  greenUpRedDown, // Western style
}
