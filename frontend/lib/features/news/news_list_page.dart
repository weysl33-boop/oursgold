import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/news.dart';

/// News list page with category tabs
class NewsListPage extends ConsumerStatefulWidget {
  const NewsListPage({super.key});

  @override
  ConsumerState<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends ConsumerState<NewsListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  final List<String> _categories = [
    '全部',
    '贵金属',
    '外汇',
    '央行',
    '政策',
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
          content: Text('新闻已刷新'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('财经快讯'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: _buildNewsList(category),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNewsList(String category) {
    final mockNews = _getMockNews(category);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: mockNews.length + 1, // +1 for load more button
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == mockNews.length) {
          return _buildLoadMoreButton();
        }
        final article = mockNews[index];
        return _NewsListItem(article: article);
      },
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('加载更多新闻')),
          );
        },
        child: const Text('加载更多'),
      ),
    );
  }

  List<NewsArticle> _getMockNews(String category) {
    final allNews = [
      NewsArticle(
        id: '1',
        title: '黄金价格突破2660美元，创历史新高',
        category: '贵金属',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        thumbnailUrl: null,
        content: '国际金价今日大幅上涨...',
        relatedSymbols: ['XAUUSD'],
      ),
      NewsArticle(
        id: '2',
        title: '美联储暗示下月可能降息，市场反应积极',
        category: '央行',
        publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        relatedSymbols: ['XAUUSD', 'EURUSD'],
      ),
      NewsArticle(
        id: '3',
        title: '欧元兑美元汇率攀升至两周高点',
        category: '外汇',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        relatedSymbols: ['EURUSD'],
      ),
      NewsArticle(
        id: '4',
        title: '中国央行宣布增加黄金储备',
        category: '政策',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        relatedSymbols: ['XAUUSD', 'AU9999'],
      ),
      NewsArticle(
        id: '5',
        title: '白银价格跟随黄金上涨，涨幅超2%',
        category: '贵金属',
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        relatedSymbols: ['XAGUSD'],
      ),
      NewsArticle(
        id: '6',
        title: '美元指数走弱，非美货币普遍走强',
        category: '外汇',
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        relatedSymbols: ['EURUSD', 'GBPUSD', 'USDJPY'],
      ),
    ];

    if (category == '全部') {
      return allNews;
    }

    return allNews.where((news) => news.category == category).toList();
  }
}

class _NewsListItem extends StatelessWidget {
  final NewsArticle article;

  const _NewsListItem({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        context.push('/news/${article.id}', extra: article);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getCategoryColor(article.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                article.category,
                style: TextStyle(
                  fontSize: 10,
                  color: _getCategoryColor(article.category),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Title and time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(article.publishedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '贵金属':
        return Colors.amber;
      case '外汇':
        return Colors.blue;
      case '央行':
        return Colors.red;
      case '政策':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${dateTime.month}月${dateTime.day}日';
    }
  }
}
