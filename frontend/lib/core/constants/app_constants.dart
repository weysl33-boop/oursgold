/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Precious Metals';
  static const String appVersion = '1.0.0';

  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Cache Durations
  static const Duration pricesCacheDuration = Duration(seconds: 5);
  static const Duration leaderboardCacheDuration = Duration(minutes: 5);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // WebSocket
  static const Duration wsReconnectDelay = Duration(seconds: 2);
  static const int wsMaxReconnectAttempts = 5;

  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUsername = 'username';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyPriceColorMode = 'price_color_mode';

  // Routes (will be defined in router config)
  static const String routeHome = '/';
  static const String routeQuotes = '/quotes';
  static const String routeForex = '/forex';
  static const String routeCommunity = '/community';
  static const String routeProfile = '/profile';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeDetail = '/detail';

  // Default Symbols (6 instruments from PRD)
  static const List<String> defaultSymbols = [
    'XAUUSD',  // Spot Gold
    'XAGUSD',  // Spot Silver
    'EURUSD',  // EUR/USD
    'GBPUSD',  // GBP/USD
    'USDJPY',  // USD/JPY
    'USDCNY',  // USD/CNY
  ];
}
