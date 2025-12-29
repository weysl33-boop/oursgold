import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/news.dart';

/// News detail page showing full article content
class NewsDetailPage extends ConsumerWidget {
  final NewsArticle article;

  const NewsDetailPage({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('新闻详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('分享功能待实现')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and time
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(article.category)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      article.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getCategoryColor(article.category),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
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

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                article.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Related Symbols
            if (article.relatedSymbols.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  '相关品种',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: article.relatedSymbols.map((symbol) {
                    return InkWell(
                      onTap: () {
                        context.push('/detail/$symbol');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getSymbolName(symbol),
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right,
                              size: 14,
                              color: theme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                article.content ?? _generateMockContent(article.title),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Disclaimer
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '以上内容仅供参考，不构成投资建议',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
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
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getSymbolName(String code) {
    final names = {
      'XAUUSD': '伦敦金',
      'XAGUSD': '伦敦银',
      'EURUSD': '欧元/美元',
      'GBPUSD': '英镑/美元',
      'USDJPY': '美元/日元',
      'AU9999': '上海金',
    };
    return names[code] ?? code;
  }

  String _generateMockContent(String title) {
    return '''
市场分析师指出，${title.substring(0, title.length > 15 ? 15 : title.length)}...

近期国际市场波动加剧，投资者密切关注各大央行的货币政策走向。分析人士认为，当前的市场环境为贵金属等避险资产提供了良好的支撑。

技术面分析显示，短期内市场可能继续保持震荡走势，但中长期趋势仍然值得关注。投资者需要密切关注以下几个关键因素：

1. 全球经济增长前景
2. 主要央行的利率政策
3. 地缘政治风险事件
4. 美元指数走势
5. 通胀预期变化

专家建议，投资者应当保持理性，根据自身风险承受能力制定合理的投资策略。同时，建议密切关注市场动态，及时调整投资组合。

本文仅为市场观察和分析，不构成任何投资建议。投资者应当独立判断，并承担相应的投资风险。
''';
  }
}
