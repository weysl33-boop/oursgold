import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Community page - Hot topics, trending symbols, leaderboards
class CommunityPage extends ConsumerWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('社区'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('热门话题', [
            {'title': '#黄金突破2660#', 'count': '2.3k讨论'},
            {'title': '#美联储降息预期#', 'count': '1.8k讨论'},
          ]),
          const SizedBox(height: 24),
          _buildSection('热门品种', [
            {'title': '伦敦金 XAUUSD', 'count': '1.2k关注'},
            {'title': '欧元/美元 EURUSD', 'count': '856关注'},
          ]),
          const SizedBox(height: 24),
          _buildSection('预测高手榜', [
            {'title': '预测大师A', 'count': '准确率 82.5%'},
            {'title': '金融分析师B', 'count': '准确率 78.3%'},
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(item['title']!),
            trailing: Text(item['count']!, style: const TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
        )),
      ],
    );
  }
}
