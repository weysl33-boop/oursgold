// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuoteImpl _$$QuoteImplFromJson(Map<String, dynamic> json) => _$QuoteImpl(
      symbolCode: json['symbolCode'] as String,
      nameCn: json['nameCn'] as String,
      nameEn: json['nameEn'] as String,
      price: (json['price'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      open: (json['open'] as num).toDouble(),
      prevClose: (json['prevClose'] as num).toDouble(),
      volume: (json['volume'] as num?)?.toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      marketStatus: json['marketStatus'] as String?,
    );

Map<String, dynamic> _$$QuoteImplToJson(_$QuoteImpl instance) =>
    <String, dynamic>{
      'symbolCode': instance.symbolCode,
      'nameCn': instance.nameCn,
      'nameEn': instance.nameEn,
      'price': instance.price,
      'change': instance.change,
      'changePercent': instance.changePercent,
      'high': instance.high,
      'low': instance.low,
      'open': instance.open,
      'prevClose': instance.prevClose,
      'volume': instance.volume,
      'timestamp': instance.timestamp.toIso8601String(),
      'marketStatus': instance.marketStatus,
    };

_$SymbolImpl _$$SymbolImplFromJson(Map<String, dynamic> json) => _$SymbolImpl(
      code: json['code'] as String,
      nameCn: json['nameCn'] as String,
      nameEn: json['nameEn'] as String,
      market: json['market'] as String,
      symbolType: json['symbolType'] as String,
      baseCurrency: json['baseCurrency'] as String?,
      quoteCurrency: json['quoteCurrency'] as String?,
      decimalPlaces: (json['decimalPlaces'] as num?)?.toInt(),
      unit: json['unit'] as String?,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$$SymbolImplToJson(_$SymbolImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'nameCn': instance.nameCn,
      'nameEn': instance.nameEn,
      'market': instance.market,
      'symbolType': instance.symbolType,
      'baseCurrency': instance.baseCurrency,
      'quoteCurrency': instance.quoteCurrency,
      'decimalPlaces': instance.decimalPlaces,
      'unit': instance.unit,
      'description': instance.description,
      'isActive': instance.isActive,
    };

_$OHLCVImpl _$$OHLCVImplFromJson(Map<String, dynamic> json) => _$OHLCVImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: (json['volume'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$OHLCVImplToJson(_$OHLCVImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
      'close': instance.close,
      'volume': instance.volume,
    };

_$HistoricalDataImpl _$$HistoricalDataImplFromJson(Map<String, dynamic> json) =>
    _$HistoricalDataImpl(
      symbolCode: json['symbolCode'] as String,
      period: json['period'] as String,
      interval: json['interval'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => OHLCV.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$HistoricalDataImplToJson(
        _$HistoricalDataImpl instance) =>
    <String, dynamic>{
      'symbolCode': instance.symbolCode,
      'period': instance.period,
      'interval': instance.interval,
      'data': instance.data,
    };
