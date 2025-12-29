import 'package:flutter/material.dart';

/// News section widget displaying recent financial news
class NewsSection extends StatelessWidget {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock news data
    final mockNews = [
      {
        'title': '黄金价格突破2650美元,创历史新高',
        'category': '贵金属',
        'time': '2小时前',
      },
      {
        'title': '美联储暗示下月可能降息,市场反应积极',
        'category': '央行',
        'time': '3小时前',
      },
      {
        'title': '欧元兑美元汇率攀升至两周高点',
        'category': '外汇',
        'time': '5小时前',
      },
      {
        'title': '中国央行宣布增加黄金储备',
        'category': '政策',
        'time': '8小时前',
      },
    ];

    return Column(
      children: [
        ...mockNews.map((news) => _NewsItem(
          title: news['title']!,
          category: news['category']!,
          time: news['time']!,
        )),
        const SizedBox(height: 80), // Bottom padding for nav bar
      ],
    );
  }
}

class _NewsItem extends StatelessWidget {
  final String title;
  final String category;
  final String time;

  const _NewsItem({
    required this.title,
    required this.category,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        // TODO: Navigate to news detail
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
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
                color: _getCategoryColor(category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 10,
                  color: _getCategoryColor(category),
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
                    title,
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
                    time,
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
}
