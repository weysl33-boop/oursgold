import '../models/quote.dart';
import '../services/api_client.dart';

/// Repository for market data operations
class MarketRepository {
  final ApiClient _apiClient;

  MarketRepository(this._apiClient);

  /// Get current quote for a symbol
  Future<Quote> getQuote(String symbolCode) async {
    final response = await _apiClient.get('/api/v1/quotes/$symbolCode');
    return Quote.fromJson(response.data);
  }

  /// Get multiple quotes
  Future<List<Quote>> getQuotes(List<String> symbolCodes) async {
    final symbols = symbolCodes.join(',');
    final response = await _apiClient.get(
      '/api/v1/quotes',
      queryParameters: {'symbols': symbols},
    );

    return (response.data['quotes'] as List)
        .map((json) => Quote.fromJson(json))
        .toList();
  }

  /// Get historical data for a symbol
  Future<HistoricalData> getHistoricalData(
    String symbolCode, {
    required String period,
    String? interval,
  }) async {
    final response = await _apiClient.get(
      '/api/v1/quotes/$symbolCode/history',
      queryParameters: {
        'period': period,
        if (interval != null) 'interval': interval,
      },
    );

    return HistoricalData.fromJson(response.data);
  }

  /// Get all symbols
  Future<List<Symbol>> getSymbols() async {
    final response = await _apiClient.get('/api/v1/symbols');
    return (response.data['symbols'] as List)
        .map((json) => Symbol.fromJson(json))
        .toList();
  }

  /// Get symbols by category
  Future<List<Symbol>> getSymbolsByCategory(String category) async {
    final response = await _apiClient.get(
      '/api/v1/symbols',
      queryParameters: {'category': category},
    );
    return (response.data['symbols'] as List)
        .map((json) => Symbol.fromJson(json))
        .toList();
  }
}
