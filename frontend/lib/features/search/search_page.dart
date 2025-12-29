import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Search page with real-time suggestions and results
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  List<String> _recentSearches = [];

  final List<String> _tabs = ['全部', '市场', '话题', '用户'];

  // Mock hot searches
  final List<String> _hotSearches = [
    '黄金价格',
    '美联储降息',
    '欧元汇率',
    '白银走势',
    '美元指数',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadRecentSearches();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.sublist(0, 10);
    }
    await prefs.setStringList('recent_searches', _recentSearches);
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_searches');
    setState(() {
      _recentSearches = [];
    });
  }

  void _performSearch(String query) {
    _saveRecentSearch(query);
    setState(() {
      _searchController.text = query;
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '搜索品种、话题或用户',
            border: InputBorder.none,
            hintStyle: TextStyle(fontSize: 16),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
        ],
      ),
      body: _searchQuery.isEmpty
          ? _buildEmptyState()
          : _buildSearchResults(),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hot Searches
        const Text(
          '热门搜索',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _hotSearches.map((search) {
            return InkWell(
              onTap: () => _performSearch(search),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  search,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Recent Searches
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '最近搜索',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _clearRecentSearches,
                child: const Text('清空'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(
            _recentSearches.length,
            (index) => ListTile(
              leading: const Icon(Icons.history, size: 20),
              title: Text(_recentSearches[index]),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  setState(() {
                    _recentSearches.removeAt(index);
                  });
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setStringList('recent_searches', _recentSearches);
                  });
                },
              ),
              onTap: () => _performSearch(_recentSearches[index]),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAllResults(),
              _buildMarketResults(),
              _buildTopicResults(),
              _buildUserResults(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllResults() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          '市场',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        ..._getMockMarketResults().map(_buildMarketItem),
        const SizedBox(height: 16),
        const Text(
          '话题',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        ..._getMockTopicResults().map(_buildTopicItem),
      ],
    );
  }

  Widget _buildMarketResults() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: _getMockMarketResults().map(_buildMarketItem).toList(),
    );
  }

  Widget _buildTopicResults() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: _getMockTopicResults().map(_buildTopicItem).toList(),
    );
  }

  Widget _buildUserResults() {
    return const Center(
      child: Text('用户搜索功能待实现'),
    );
  }

  Widget _buildMarketItem(Map<String, String> item) {
    return ListTile(
      leading: const Icon(Icons.show_chart),
      title: Text(item['name']!),
      subtitle: Text(item['code']!),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.push('/detail/${item['code']}');
      },
    );
  }

  Widget _buildTopicItem(Map<String, String> item) {
    return ListTile(
      leading: const Icon(Icons.tag),
      title: Text(item['title']!),
      subtitle: Text('${item['count']} 讨论'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('话题详情功能待实现')),
        );
      },
    );
  }

  List<Map<String, String>> _getMockMarketResults() {
    final query = _searchQuery.toLowerCase();
    final allMarkets = [
      {'code': 'XAUUSD', 'name': '伦敦金'},
      {'code': 'XAGUSD', 'name': '伦敦银'},
      {'code': 'EURUSD', 'name': '欧元/美元'},
      {'code': 'GBPUSD', 'name': '英镑/美元'},
    ];

    return allMarkets.where((market) {
      return market['code']!.toLowerCase().contains(query) ||
          market['name']!.contains(query);
    }).toList();
  }

  List<Map<String, String>> _getMockTopicResults() {
    return [
      {'title': '#黄金突破2660#', 'count': '2.3k'},
      {'title': '#美联储降息预期#', 'count': '1.8k'},
      {'title': '#欧元汇率走势#', 'count': '1.2k'},
    ];
  }
}
