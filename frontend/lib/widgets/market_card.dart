import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/design_tokens.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

/// Enhanced market card widget displaying symbol price with design tokens
class MarketCard extends ConsumerWidget {
  final String symbolCode;

  const MarketCard({
    super.key,
    required this.symbolCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch real quote data from provider
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Mock data for now
    final mockPrice = _getMockPrice(symbolCode);
    final mockChange = _getMockChange(symbolCode);
    final mockChangePercent = _getMockChangePercent(symbolCode);
    final isPositive = mockChange >= 0;

    // Use AppColors for price colors (China style: red up, green down)
    final priceColor = isPositive ? AppColors.priceUpRed : AppColors.priceDownGreen;
    final symbolName = _getSymbolName(symbolCode);
    final symbolLogo = _getSymbolLogo(symbolCode);

    return Semantics(
      label: '$symbolName 价格 ${mockPrice.toStringAsFixed(2)} ${isPositive ? "上涨" : "下跌"} ${mockChangePercent.abs().toStringAsFixed(2)}%',
      button: true,
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          // Reference: bg-gray-50 for light mode, glassmorphic for dark mode
          color: isDark
              ? AppColors.refCardDark.withOpacity(0.5)
              : AppColors.refGray50,
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg), // rounded-2xl
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              context.push('/detail/$symbolCode');
            },
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
            child: Padding(
              padding: const EdgeInsets.all(AppDesignTokens.space4), // p-4
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo and symbol info (reference: flex items-center gap-2 mb-4)
                  Row(
                    children: [
                      // Logo container (reference: w-10 h-10 bg-white rounded-xl shadow-sm)
                      Container(
                        width: AppDesignTokens.stockCardLogoSize,
                        height: AppDesignTokens.stockCardLogoSize,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMd), // rounded-xl
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            symbolLogo,
                            style: AppTypography.h4(
                              color: AppColors.gold500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDesignTokens.space2), // gap-2
                      // Symbol name and code
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Symbol name (reference: font-semibold text-gray-900)
                            Text(
                              symbolName,
                              style: AppTypography.symbolName(
                                color: isDark ? AppColors.refForegroundDark : AppColors.refForeground,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Symbol code (reference: text-xs text-gray-500)
                            Text(
                              symbolCode,
                              style: AppTypography.caption(
                                color: isDark ? AppColors.refGray400 : AppColors.refMutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDesignTokens.space4), // mb-4

                  // Price section (reference: Portfolio label and value with change)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label (reference: text-gray-500 text-sm)
                      Text(
                        '实时价格',
                        style: AppTypography.bodySmall(
                          color: isDark ? AppColors.refGray400 : AppColors.refMutedForeground,
                        ),
                      ),
                      const SizedBox(height: AppDesignTokens.space1),
                      // Price and change row (reference: flex items-center justify-between)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price (reference: text-lg font-bold text-gray-900)
                          Text(
                            mockPrice.toStringAsFixed(2),
                            style: AppTypography.price(
                              color: isDark ? AppColors.refForegroundDark : AppColors.refForeground,
                            ),
                          ),
                          // Change indicator (reference: flex items-center gap-1)
                          if (mockChangePercent != 0)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                                  size: 16,
                                  color: priceColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${mockChangePercent.abs().toStringAsFixed(2)}%',
                                  style: AppTypography.priceChange(
                                    color: priceColor,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: AppDesignTokens.durationMedium.ms,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: AppDesignTokens.durationMedium.ms,
          curve: Curves.easeOut,
        );
  }

  String _getSymbolName(String code) {
    final names = {
      'XAUUSD': '伦敦金',
      'XAGUSD': '伦敦银',
      'EURUSD': '欧元/美元',
      'GBPUSD': '英镑/美元',
      'USDJPY': '美元/日元',
      'USDCNY': '美元/人民币',
    };
    return names[code] ?? code;
  }

  String _getSymbolLogo(String code) {
    final logos = {
      'XAUUSD': '金',
      'XAGUSD': '银',
      'EURUSD': '€',
      'GBPUSD': '£',
      'USDJPY': '¥',
      'USDCNY': '¥',
    };
    return logos[code] ?? code.substring(0, 1);
  }

  double _getMockPrice(String code) {
    final prices = {
      'XAUUSD': 2658.50,
      'XAGUSD': 31.25,
      'EURUSD': 1.0832,
      'GBPUSD': 1.2645,
      'USDJPY': 148.52,
      'USDCNY': 7.2358,
    };
    return prices[code] ?? 0.0;
  }

  double _getMockChange(String code) {
    final changes = {
      'XAUUSD': 28.30,
      'XAGUSD': -0.52,
      'EURUSD': 0.0043,
      'GBPUSD': 0.0112,
      'USDJPY': -1.25,
      'USDCNY': 0.0158,
    };
    return changes[code] ?? 0.0;
  }

  double _getMockChangePercent(String code) {
    final changes = {
      'XAUUSD': 1.08,
      'XAGUSD': -1.64,
      'EURUSD': 0.40,
      'GBPUSD': 0.89,
      'USDJPY': -0.83,
      'USDCNY': 0.22,
    };
    return changes[code] ?? 0.0;
  }
}
