import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration class
class EnvConfig {
  static const String development = '.env.development';
  static const String staging = '.env.staging';
  static const String production = '.env.production';

  /// Initialize environment configuration
  static Future<void> init({String env = development}) async {
    await dotenv.load(fileName: env);
  }

  /// Get current environment
  static String get env => dotenv.env['ENV'] ?? 'development';

  /// Get API base URL
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';

  /// Get WebSocket base URL
  static String get wsBaseUrl => dotenv.env['WS_BASE_URL'] ?? 'ws://localhost:8000';

  /// Get market data provider
  static String get marketDataProvider => dotenv.env['MARKET_DATA_PROVIDER'] ?? 'twelve_data';

  /// Get market data API key
  static String get marketDataApiKey => dotenv.env['MARKET_DATA_API_KEY'] ?? '';

  /// Check if debug logging is enabled
  static bool get enableDebugLogging => dotenv.env['ENABLE_DEBUG_LOGGING']?.toLowerCase() == 'true';

  /// Check if analytics is enabled
  static bool get enableAnalytics => dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';
}
