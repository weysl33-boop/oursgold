import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/market_card.dart';
import '../../widgets/news_section.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/theme/typography.dart';

/// Home page - Market overview with 6 cards and news section
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // Default 6 instruments to display
  final List<String> _defaultSymbols = [
    'XAUUSD', // Spot Gold
    'XAGUSD', // Spot Silver
    'EURUSD', // EUR/USD
    'GBPUSD', // GBP/USD
    'USDJPY', // USD/JPY
    'USDCNY', // USD/CNY
  ];

  bool _isLoading = false;

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('数据已刷新'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
          // App Bar with Search
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('贵金属行情'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  context.push('/search');
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Navigate to notifications
                },
              ),
            ],
          ),

          // Market Overview Cards (2x3 grid)
          SliverPadding(
            padding: const EdgeInsets.all(AppDesignTokens.space4),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppDesignTokens.space3,
                crossAxisSpacing: AppDesignTokens.space3,
                childAspectRatio: 1.4,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return MarketCard(
                    symbolCode: _defaultSymbols[index],
                  );
                },
                childCount: _defaultSymbols.length,
              ),
            ),
          ),

          // Section Header - News
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDesignTokens.space4,
                AppDesignTokens.space2,
                AppDesignTokens.space4,
                AppDesignTokens.space3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '财经快讯',
                    style: AppTypography.h3(),
                  ),
                  InkWell(
                    onTap: () {
                      context.push('/news');
                    },
                    child: Text(
                      '更多',
                      style: AppTypography.caption(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // News Section
          const SliverToBoxAdapter(
            child: NewsSection(),
          ),
        ],
      ),
      ),
    );
  }
}
