import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/bottom_nav_shell.dart';
import '../../features/detail/detail_page.dart';
import '../../features/news/news_list_page.dart';
import '../../features/news/news_detail_page.dart';
import '../../features/search/search_page.dart';
import '../../data/models/news.dart';

/// Application router configuration
final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const BottomNavShell(),
    ),
    GoRoute(
      path: '/detail/:symbolCode',
      name: 'detail',
      builder: (context, state) {
        final symbolCode = state.pathParameters['symbolCode']!;
        return DetailPage(symbolCode: symbolCode);
      },
    ),
    GoRoute(
      path: '/news',
      name: 'news-list',
      builder: (context, state) => const NewsListPage(),
    ),
    GoRoute(
      path: '/news/:id',
      name: 'news-detail',
      builder: (context, state) {
        final article = state.extra as NewsArticle;
        return NewsDetailPage(article: article);
      },
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri.path}'),
    ),
  ),
);
