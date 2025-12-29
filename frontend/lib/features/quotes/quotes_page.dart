import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Quotes page - Categorized instrument lists
class QuotesPage extends ConsumerStatefulWidget {
  const QuotesPage({super.key});

  @override
  ConsumerState<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends ConsumerState<QuotesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  final List<String> _categories = [
    '自选',
    '黄金',
    '白银',
    '外汇',
    '加密货币',
    '指数',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
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
      appBar: AppBar(
        title: const Text('行情'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories
              .map((category) => Tab(text: category))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: _buildQuotesList(category),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuotesList(String category) {
    final mockQuotes = _getMockQuotes(category);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: mockQuotes.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final quote = mockQuotes[index];
        return _QuoteListItem(quote: quote);
      },
    );
  }

  List<Map<String, dynamic>> _getMockQuotes(String category) {
    if (category == '自选') {
      return [
        {
          'code': 'XAUUSD',
          'name': '伦敦金',
          'market': 'LBMA',
          'price': 2658.50,
          'change': 28.30,
          'changePercent': 1.08,
        },
      ];
    } else if (category == '黄金') {
      return [
        {
          'code': 'XAUUSD',
          'name': '伦敦金',
          'market': 'LBMA',
          'price': 2658.50,
          'change': 28.30,
          'changePercent': 1.08,
        },
        {
          'code': 'AU9999',
          'name': '上海金',
          'market': 'SGE',
          'price': 595.20,
          'change': 4.80,
          'changePercent': 0.81,
        },
      ];
    }
    return [];
  }
}

class _QuoteListItem extends StatelessWidget {
  final Map<String, dynamic> quote;

  const _QuoteListItem({required this.quote});

  @override
  Widget build(BuildContext context) {
    final isPositive = quote['change'] >= 0;
    final priceColor = isPositive ? Colors.red : Colors.green;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        context.push('/detail/${quote['code']}');
      },
      title: Row(
        children: [
          Text(
            quote['name'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              quote['market'],
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        quote['code'],
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            quote['price'].toStringAsFixed(2),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: priceColor,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: priceColor,
                size: 16,
              ),
              Text(
                '${quote['changePercent'].abs().toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: priceColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
