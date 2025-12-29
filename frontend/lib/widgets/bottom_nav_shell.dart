import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/providers.dart';
import '../core/theme/design_tokens.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../features/home/home_page.dart';
import '../features/quotes/quotes_page.dart';
import '../features/forex/forex_page.dart';
import '../features/community/community_page.dart';
import '../features/profile/profile_page.dart';

/// Bottom navigation shell with 5 tabs
class BottomNavShell extends ConsumerWidget {
  const BottomNavShell({super.key});

  static const List<_NavItem> _navItems = [
    _NavItem(
      label: '首页',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      page: HomePage(),
    ),
    _NavItem(
      label: '行情',
      icon: Icons.show_chart_outlined,
      selectedIcon: Icons.show_chart,
      page: QuotesPage(),
    ),
    _NavItem(
      label: '外汇',
      icon: Icons.currency_exchange_outlined,
      selectedIcon: Icons.currency_exchange,
      page: ForexPage(),
    ),
    _NavItem(
      label: '社区',
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups,
      page: CommunityPage(),
    ),
    _NavItem(
      label: '我的',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      page: ProfilePage(),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _navItems.map((item) => item.page).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // Reference: bg-white border-t border-gray-100
          color: isDark ? AppColors.refCardDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.refBorder,
              width: 1,
            ),
          ),
        ),
        // Reference: px-6 py-3 safe-area-pb
        padding: EdgeInsets.only(
          left: AppDesignTokens.space6,  // px-6 = 24dp
          right: AppDesignTokens.space6,
          top: AppDesignTokens.space3,   // py-3 = 12dp
          // Safe area handling: max(12dp, device bottom padding)
          bottom: bottomPadding > AppDesignTokens.safeAreaBottomBase
              ? bottomPadding
              : AppDesignTokens.safeAreaBottomBase,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Navigation items row (reference: flex justify-between items-center)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isActive = currentIndex == index;

                return Expanded(
                  child: _NavButton(
                    label: item.label,
                    icon: isActive ? item.selectedIcon : item.icon,
                    isActive: isActive,
                    isDark: isDark,
                    onTap: () {
                      if (index != currentIndex) {
                        HapticFeedback.lightImpact();
                        ref.read(currentIndexProvider.notifier).state = index;
                      }
                    },
                  ),
                );
              }),
            ),

            // Home indicator (reference: w-32 h-1 bg-black rounded-full)
            const SizedBox(height: AppDesignTokens.space2), // mt-2
            Center(
              child: Container(
                width: AppDesignTokens.homeIndicatorWidth,  // w-32 = 128dp
                height: AppDesignTokens.homeIndicatorHeight, // h-1 = 4dp
                decoration: BoxDecoration(
                  color: isDark ? AppColors.refForegroundDark : Colors.black,
                  borderRadius: BorderRadius.circular(AppDesignTokens.radiusFull),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}

/// Individual navigation button matching reference design
class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Reference: text-blue-600 (active) / text-gray-400 (inactive)
    final color = isActive
        ? AppColors.refBlue600
        : (isDark ? AppColors.refGray400 : AppColors.refGray400);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
      child: Container(
        // Reference: min-w-[60px]
        constraints: const BoxConstraints(
          minWidth: AppDesignTokens.bottomNavMinItemWidth,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppDesignTokens.space1,
        ),
        // Reference: flex flex-col items-center gap-1
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon (reference: w-6 h-6 = 24dp)
            Icon(
              icon,
              size: AppDesignTokens.bottomNavIconSize,
              color: color,
            ),
            const SizedBox(height: 4), // gap-1
            // Label (reference: text-xs)
            Text(
              label,
              style: AppTypography.labelXSmall(color: color).copyWith(
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
