import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote.freezed.dart';
part 'quote.g.dart';

@freezed
class Quote with _$Quote {
  const factory Quote({
    required String symbolCode,
    required String nameCn,
    required String nameEn,
    required double price,
    required double change,
    required double changePercent,
    required double high,
    required double low,
    required double open,
    required double prevClose,
    int? volume,
    required DateTime timestamp,
    String? marketStatus,
  }) = _Quote;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}

@freezed
class Symbol with _$Symbol {
  const factory Symbol({
    required String code,
    required String nameCn,
    required String nameEn,
    required String market,
    required String symbolType,
    String? baseCurrency,
    String? quoteCurrency,
    int? decimalPlaces,
    String? unit,
    String? description,
    bool? isActive,
  }) = _Symbol;

  factory Symbol.fromJson(Map<String, dynamic> json) => _$SymbolFromJson(json);
}

@freezed
class OHLCV with _$OHLCV {
  const factory OHLCV({
    required DateTime timestamp,
    required double open,
    required double high,
    required double low,
    required double close,
    int? volume,
  }) = _OHLCV;

  factory OHLCV.fromJson(Map<String, dynamic> json) => _$OHLCVFromJson(json);
}

@freezed
class HistoricalData with _$HistoricalData {
  const factory HistoricalData({
    required String symbolCode,
    required String period,
    required String interval,
    required List<OHLCV> data,
  }) = _HistoricalData;

  factory HistoricalData.fromJson(Map<String, dynamic> json) =>
      _$HistoricalDataFromJson(json);
}
