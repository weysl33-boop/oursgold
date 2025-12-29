// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Quote _$QuoteFromJson(Map<String, dynamic> json) {
  return _Quote.fromJson(json);
}

/// @nodoc
mixin _$Quote {
  String get symbolCode => throw _privateConstructorUsedError;
  String get nameCn => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get change => throw _privateConstructorUsedError;
  double get changePercent => throw _privateConstructorUsedError;
  double get high => throw _privateConstructorUsedError;
  double get low => throw _privateConstructorUsedError;
  double get open => throw _privateConstructorUsedError;
  double get prevClose => throw _privateConstructorUsedError;
  int? get volume => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get marketStatus => throw _privateConstructorUsedError;

  /// Serializes this Quote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Quote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuoteCopyWith<Quote> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteCopyWith<$Res> {
  factory $QuoteCopyWith(Quote value, $Res Function(Quote) then) =
      _$QuoteCopyWithImpl<$Res, Quote>;
  @useResult
  $Res call(
      {String symbolCode,
      String nameCn,
      String nameEn,
      double price,
      double change,
      double changePercent,
      double high,
      double low,
      double open,
      double prevClose,
      int? volume,
      DateTime timestamp,
      String? marketStatus});
}

/// @nodoc
class _$QuoteCopyWithImpl<$Res, $Val extends Quote>
    implements $QuoteCopyWith<$Res> {
  _$QuoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Quote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbolCode = null,
    Object? nameCn = null,
    Object? nameEn = null,
    Object? price = null,
    Object? change = null,
    Object? changePercent = null,
    Object? high = null,
    Object? low = null,
    Object? open = null,
    Object? prevClose = null,
    Object? volume = freezed,
    Object? timestamp = null,
    Object? marketStatus = freezed,
  }) {
    return _then(_value.copyWith(
      symbolCode: null == symbolCode
          ? _value.symbolCode
          : symbolCode // ignore: cast_nullable_to_non_nullable
              as String,
      nameCn: null == nameCn
          ? _value.nameCn
          : nameCn // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      change: null == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double,
      changePercent: null == changePercent
          ? _value.changePercent
          : changePercent // ignore: cast_nullable_to_non_nullable
              as double,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double,
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as double,
      prevClose: null == prevClose
          ? _value.prevClose
          : prevClose // ignore: cast_nullable_to_non_nullable
              as double,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as int?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      marketStatus: freezed == marketStatus
          ? _value.marketStatus
          : marketStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuoteImplCopyWith<$Res> implements $QuoteCopyWith<$Res> {
  factory _$$QuoteImplCopyWith(
          _$QuoteImpl value, $Res Function(_$QuoteImpl) then) =
      __$$QuoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String symbolCode,
      String nameCn,
      String nameEn,
      double price,
      double change,
      double changePercent,
      double high,
      double low,
      double open,
      double prevClose,
      int? volume,
      DateTime timestamp,
      String? marketStatus});
}

/// @nodoc
class __$$QuoteImplCopyWithImpl<$Res>
    extends _$QuoteCopyWithImpl<$Res, _$QuoteImpl>
    implements _$$QuoteImplCopyWith<$Res> {
  __$$QuoteImplCopyWithImpl(
      _$QuoteImpl _value, $Res Function(_$QuoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of Quote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbolCode = null,
    Object? nameCn = null,
    Object? nameEn = null,
    Object? price = null,
    Object? change = null,
    Object? changePercent = null,
    Object? high = null,
    Object? low = null,
    Object? open = null,
    Object? prevClose = null,
    Object? volume = freezed,
    Object? timestamp = null,
    Object? marketStatus = freezed,
  }) {
    return _then(_$QuoteImpl(
      symbolCode: null == symbolCode
          ? _value.symbolCode
          : symbolCode // ignore: cast_nullable_to_non_nullable
              as String,
      nameCn: null == nameCn
          ? _value.nameCn
          : nameCn // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      change: null == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double,
      changePercent: null == changePercent
          ? _value.changePercent
          : changePercent // ignore: cast_nullable_to_non_nullable
              as double,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double,
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as double,
      prevClose: null == prevClose
          ? _value.prevClose
          : prevClose // ignore: cast_nullable_to_non_nullable
              as double,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as int?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      marketStatus: freezed == marketStatus
          ? _value.marketStatus
          : marketStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteImpl implements _Quote {
  const _$QuoteImpl(
      {required this.symbolCode,
      required this.nameCn,
      required this.nameEn,
      required this.price,
      required this.change,
      required this.changePercent,
      required this.high,
      required this.low,
      required this.open,
      required this.prevClose,
      this.volume,
      required this.timestamp,
      this.marketStatus});

  factory _$QuoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteImplFromJson(json);

  @override
  final String symbolCode;
  @override
  final String nameCn;
  @override
  final String nameEn;
  @override
  final double price;
  @override
  final double change;
  @override
  final double changePercent;
  @override
  final double high;
  @override
  final double low;
  @override
  final double open;
  @override
  final double prevClose;
  @override
  final int? volume;
  @override
  final DateTime timestamp;
  @override
  final String? marketStatus;

  @override
  String toString() {
    return 'Quote(symbolCode: $symbolCode, nameCn: $nameCn, nameEn: $nameEn, price: $price, change: $change, changePercent: $changePercent, high: $high, low: $low, open: $open, prevClose: $prevClose, volume: $volume, timestamp: $timestamp, marketStatus: $marketStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteImpl &&
            (identical(other.symbolCode, symbolCode) ||
                other.symbolCode == symbolCode) &&
            (identical(other.nameCn, nameCn) || other.nameCn == nameCn) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.changePercent, changePercent) ||
                other.changePercent == changePercent) &&
            (identical(other.high, high) || other.high == high) &&
            (identical(other.low, low) || other.low == low) &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.prevClose, prevClose) ||
                other.prevClose == prevClose) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.marketStatus, marketStatus) ||
                other.marketStatus == marketStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symbolCode,
      nameCn,
      nameEn,
      price,
      change,
      changePercent,
      high,
      low,
      open,
      prevClose,
      volume,
      timestamp,
      marketStatus);

  /// Create a copy of Quote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteImplCopyWith<_$QuoteImpl> get copyWith =>
      __$$QuoteImplCopyWithImpl<_$QuoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteImplToJson(
      this,
    );
  }
}

abstract class _Quote implements Quote {
  const factory _Quote(
      {required final String symbolCode,
      required final String nameCn,
      required final String nameEn,
      required final double price,
      required final double change,
      required final double changePercent,
      required final double high,
      required final double low,
      required final double open,
      required final double prevClose,
      final int? volume,
      required final DateTime timestamp,
      final String? marketStatus}) = _$QuoteImpl;

  factory _Quote.fromJson(Map<String, dynamic> json) = _$QuoteImpl.fromJson;

  @override
  String get symbolCode;
  @override
  String get nameCn;
  @override
  String get nameEn;
  @override
  double get price;
  @override
  double get change;
  @override
  double get changePercent;
  @override
  double get high;
  @override
  double get low;
  @override
  double get open;
  @override
  double get prevClose;
  @override
  int? get volume;
  @override
  DateTime get timestamp;
  @override
  String? get marketStatus;

  /// Create a copy of Quote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuoteImplCopyWith<_$QuoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Symbol _$SymbolFromJson(Map<String, dynamic> json) {
  return _Symbol.fromJson(json);
}

/// @nodoc
mixin _$Symbol {
  String get code => throw _privateConstructorUsedError;
  String get nameCn => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;
  String get market => throw _privateConstructorUsedError;
  String get symbolType => throw _privateConstructorUsedError;
  String? get baseCurrency => throw _privateConstructorUsedError;
  String? get quoteCurrency => throw _privateConstructorUsedError;
  int? get decimalPlaces => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this Symbol to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Symbol
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SymbolCopyWith<Symbol> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SymbolCopyWith<$Res> {
  factory $SymbolCopyWith(Symbol value, $Res Function(Symbol) then) =
      _$SymbolCopyWithImpl<$Res, Symbol>;
  @useResult
  $Res call(
      {String code,
      String nameCn,
      String nameEn,
      String market,
      String symbolType,
      String? baseCurrency,
      String? quoteCurrency,
      int? decimalPlaces,
      String? unit,
      String? description,
      bool? isActive});
}

/// @nodoc
class _$SymbolCopyWithImpl<$Res, $Val extends Symbol>
    implements $SymbolCopyWith<$Res> {
  _$SymbolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Symbol
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? nameCn = null,
    Object? nameEn = null,
    Object? market = null,
    Object? symbolType = null,
    Object? baseCurrency = freezed,
    Object? quoteCurrency = freezed,
    Object? decimalPlaces = freezed,
    Object? unit = freezed,
    Object? description = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      nameCn: null == nameCn
          ? _value.nameCn
          : nameCn // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      market: null == market
          ? _value.market
          : market // ignore: cast_nullable_to_non_nullable
              as String,
      symbolType: null == symbolType
          ? _value.symbolType
          : symbolType // ignore: cast_nullable_to_non_nullable
              as String,
      baseCurrency: freezed == baseCurrency
          ? _value.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      quoteCurrency: freezed == quoteCurrency
          ? _value.quoteCurrency
          : quoteCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      decimalPlaces: freezed == decimalPlaces
          ? _value.decimalPlaces
          : decimalPlaces // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SymbolImplCopyWith<$Res> implements $SymbolCopyWith<$Res> {
  factory _$$SymbolImplCopyWith(
          _$SymbolImpl value, $Res Function(_$SymbolImpl) then) =
      __$$SymbolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String nameCn,
      String nameEn,
      String market,
      String symbolType,
      String? baseCurrency,
      String? quoteCurrency,
      int? decimalPlaces,
      String? unit,
      String? description,
      bool? isActive});
}

/// @nodoc
class __$$SymbolImplCopyWithImpl<$Res>
    extends _$SymbolCopyWithImpl<$Res, _$SymbolImpl>
    implements _$$SymbolImplCopyWith<$Res> {
  __$$SymbolImplCopyWithImpl(
      _$SymbolImpl _value, $Res Function(_$SymbolImpl) _then)
      : super(_value, _then);

  /// Create a copy of Symbol
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? nameCn = null,
    Object? nameEn = null,
    Object? market = null,
    Object? symbolType = null,
    Object? baseCurrency = freezed,
    Object? quoteCurrency = freezed,
    Object? decimalPlaces = freezed,
    Object? unit = freezed,
    Object? description = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$SymbolImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      nameCn: null == nameCn
          ? _value.nameCn
          : nameCn // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      market: null == market
          ? _value.market
          : market // ignore: cast_nullable_to_non_nullable
              as String,
      symbolType: null == symbolType
          ? _value.symbolType
          : symbolType // ignore: cast_nullable_to_non_nullable
              as String,
      baseCurrency: freezed == baseCurrency
          ? _value.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      quoteCurrency: freezed == quoteCurrency
          ? _value.quoteCurrency
          : quoteCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      decimalPlaces: freezed == decimalPlaces
          ? _value.decimalPlaces
          : decimalPlaces // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SymbolImpl implements _Symbol {
  const _$SymbolImpl(
      {required this.code,
      required this.nameCn,
      required this.nameEn,
      required this.market,
      required this.symbolType,
      this.baseCurrency,
      this.quoteCurrency,
      this.decimalPlaces,
      this.unit,
      this.description,
      this.isActive});

  factory _$SymbolImpl.fromJson(Map<String, dynamic> json) =>
      _$$SymbolImplFromJson(json);

  @override
  final String code;
  @override
  final String nameCn;
  @override
  final String nameEn;
  @override
  final String market;
  @override
  final String symbolType;
  @override
  final String? baseCurrency;
  @override
  final String? quoteCurrency;
  @override
  final int? decimalPlaces;
  @override
  final String? unit;
  @override
  final String? description;
  @override
  final bool? isActive;

  @override
  String toString() {
    return 'Symbol(code: $code, nameCn: $nameCn, nameEn: $nameEn, market: $market, symbolType: $symbolType, baseCurrency: $baseCurrency, quoteCurrency: $quoteCurrency, decimalPlaces: $decimalPlaces, unit: $unit, description: $description, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SymbolImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.nameCn, nameCn) || other.nameCn == nameCn) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.market, market) || other.market == market) &&
            (identical(other.symbolType, symbolType) ||
                other.symbolType == symbolType) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.quoteCurrency, quoteCurrency) ||
                other.quoteCurrency == quoteCurrency) &&
            (identical(other.decimalPlaces, decimalPlaces) ||
                other.decimalPlaces == decimalPlaces) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      code,
      nameCn,
      nameEn,
      market,
      symbolType,
      baseCurrency,
      quoteCurrency,
      decimalPlaces,
      unit,
      description,
      isActive);

  /// Create a copy of Symbol
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SymbolImplCopyWith<_$SymbolImpl> get copyWith =>
      __$$SymbolImplCopyWithImpl<_$SymbolImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SymbolImplToJson(
      this,
    );
  }
}

abstract class _Symbol implements Symbol {
  const factory _Symbol(
      {required final String code,
      required final String nameCn,
      required final String nameEn,
      required final String market,
      required final String symbolType,
      final String? baseCurrency,
      final String? quoteCurrency,
      final int? decimalPlaces,
      final String? unit,
      final String? description,
      final bool? isActive}) = _$SymbolImpl;

  factory _Symbol.fromJson(Map<String, dynamic> json) = _$SymbolImpl.fromJson;

  @override
  String get code;
  @override
  String get nameCn;
  @override
  String get nameEn;
  @override
  String get market;
  @override
  String get symbolType;
  @override
  String? get baseCurrency;
  @override
  String? get quoteCurrency;
  @override
  int? get decimalPlaces;
  @override
  String? get unit;
  @override
  String? get description;
  @override
  bool? get isActive;

  /// Create a copy of Symbol
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SymbolImplCopyWith<_$SymbolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OHLCV _$OHLCVFromJson(Map<String, dynamic> json) {
  return _OHLCV.fromJson(json);
}

/// @nodoc
mixin _$OHLCV {
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get open => throw _privateConstructorUsedError;
  double get high => throw _privateConstructorUsedError;
  double get low => throw _privateConstructorUsedError;
  double get close => throw _privateConstructorUsedError;
  int? get volume => throw _privateConstructorUsedError;

  /// Serializes this OHLCV to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OHLCV
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OHLCVCopyWith<OHLCV> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OHLCVCopyWith<$Res> {
  factory $OHLCVCopyWith(OHLCV value, $Res Function(OHLCV) then) =
      _$OHLCVCopyWithImpl<$Res, OHLCV>;
  @useResult
  $Res call(
      {DateTime timestamp,
      double open,
      double high,
      double low,
      double close,
      int? volume});
}

/// @nodoc
class _$OHLCVCopyWithImpl<$Res, $Val extends OHLCV>
    implements $OHLCVCopyWith<$Res> {
  _$OHLCVCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OHLCV
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? open = null,
    Object? high = null,
    Object? low = null,
    Object? close = null,
    Object? volume = freezed,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as double,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double,
      close: null == close
          ? _value.close
          : close // ignore: cast_nullable_to_non_nullable
              as double,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OHLCVImplCopyWith<$Res> implements $OHLCVCopyWith<$Res> {
  factory _$$OHLCVImplCopyWith(
          _$OHLCVImpl value, $Res Function(_$OHLCVImpl) then) =
      __$$OHLCVImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp,
      double open,
      double high,
      double low,
      double close,
      int? volume});
}

/// @nodoc
class __$$OHLCVImplCopyWithImpl<$Res>
    extends _$OHLCVCopyWithImpl<$Res, _$OHLCVImpl>
    implements _$$OHLCVImplCopyWith<$Res> {
  __$$OHLCVImplCopyWithImpl(
      _$OHLCVImpl _value, $Res Function(_$OHLCVImpl) _then)
      : super(_value, _then);

  /// Create a copy of OHLCV
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? open = null,
    Object? high = null,
    Object? low = null,
    Object? close = null,
    Object? volume = freezed,
  }) {
    return _then(_$OHLCVImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as double,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double,
      close: null == close
          ? _value.close
          : close // ignore: cast_nullable_to_non_nullable
              as double,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OHLCVImpl implements _OHLCV {
  const _$OHLCVImpl(
      {required this.timestamp,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      this.volume});

  factory _$OHLCVImpl.fromJson(Map<String, dynamic> json) =>
      _$$OHLCVImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final double open;
  @override
  final double high;
  @override
  final double low;
  @override
  final double close;
  @override
  final int? volume;

  @override
  String toString() {
    return 'OHLCV(timestamp: $timestamp, open: $open, high: $high, low: $low, close: $close, volume: $volume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OHLCVImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.high, high) || other.high == high) &&
            (identical(other.low, low) || other.low == low) &&
            (identical(other.close, close) || other.close == close) &&
            (identical(other.volume, volume) || other.volume == volume));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, timestamp, open, high, low, close, volume);

  /// Create a copy of OHLCV
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OHLCVImplCopyWith<_$OHLCVImpl> get copyWith =>
      __$$OHLCVImplCopyWithImpl<_$OHLCVImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OHLCVImplToJson(
      this,
    );
  }
}

abstract class _OHLCV implements OHLCV {
  const factory _OHLCV(
      {required final DateTime timestamp,
      required final double open,
      required final double high,
      required final double low,
      required final double close,
      final int? volume}) = _$OHLCVImpl;

  factory _OHLCV.fromJson(Map<String, dynamic> json) = _$OHLCVImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  double get open;
  @override
  double get high;
  @override
  double get low;
  @override
  double get close;
  @override
  int? get volume;

  /// Create a copy of OHLCV
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OHLCVImplCopyWith<_$OHLCVImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HistoricalData _$HistoricalDataFromJson(Map<String, dynamic> json) {
  return _HistoricalData.fromJson(json);
}

/// @nodoc
mixin _$HistoricalData {
  String get symbolCode => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  String get interval => throw _privateConstructorUsedError;
  List<OHLCV> get data => throw _privateConstructorUsedError;

  /// Serializes this HistoricalData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoricalData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoricalDataCopyWith<HistoricalData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoricalDataCopyWith<$Res> {
  factory $HistoricalDataCopyWith(
          HistoricalData value, $Res Function(HistoricalData) then) =
      _$HistoricalDataCopyWithImpl<$Res, HistoricalData>;
  @useResult
  $Res call(
      {String symbolCode, String period, String interval, List<OHLCV> data});
}

/// @nodoc
class _$HistoricalDataCopyWithImpl<$Res, $Val extends HistoricalData>
    implements $HistoricalDataCopyWith<$Res> {
  _$HistoricalDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoricalData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbolCode = null,
    Object? period = null,
    Object? interval = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      symbolCode: null == symbolCode
          ? _value.symbolCode
          : symbolCode // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<OHLCV>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoricalDataImplCopyWith<$Res>
    implements $HistoricalDataCopyWith<$Res> {
  factory _$$HistoricalDataImplCopyWith(_$HistoricalDataImpl value,
          $Res Function(_$HistoricalDataImpl) then) =
      __$$HistoricalDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String symbolCode, String period, String interval, List<OHLCV> data});
}

/// @nodoc
class __$$HistoricalDataImplCopyWithImpl<$Res>
    extends _$HistoricalDataCopyWithImpl<$Res, _$HistoricalDataImpl>
    implements _$$HistoricalDataImplCopyWith<$Res> {
  __$$HistoricalDataImplCopyWithImpl(
      _$HistoricalDataImpl _value, $Res Function(_$HistoricalDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoricalData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbolCode = null,
    Object? period = null,
    Object? interval = null,
    Object? data = null,
  }) {
    return _then(_$HistoricalDataImpl(
      symbolCode: null == symbolCode
          ? _value.symbolCode
          : symbolCode // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<OHLCV>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoricalDataImpl implements _HistoricalData {
  const _$HistoricalDataImpl(
      {required this.symbolCode,
      required this.period,
      required this.interval,
      required final List<OHLCV> data})
      : _data = data;

  factory _$HistoricalDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoricalDataImplFromJson(json);

  @override
  final String symbolCode;
  @override
  final String period;
  @override
  final String interval;
  final List<OHLCV> _data;
  @override
  List<OHLCV> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'HistoricalData(symbolCode: $symbolCode, period: $period, interval: $interval, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoricalDataImpl &&
            (identical(other.symbolCode, symbolCode) ||
                other.symbolCode == symbolCode) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbolCode, period, interval,
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of HistoricalData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoricalDataImplCopyWith<_$HistoricalDataImpl> get copyWith =>
      __$$HistoricalDataImplCopyWithImpl<_$HistoricalDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoricalDataImplToJson(
      this,
    );
  }
}

abstract class _HistoricalData implements HistoricalData {
  const factory _HistoricalData(
      {required final String symbolCode,
      required final String period,
      required final String interval,
      required final List<OHLCV> data}) = _$HistoricalDataImpl;

  factory _HistoricalData.fromJson(Map<String, dynamic> json) =
      _$HistoricalDataImpl.fromJson;

  @override
  String get symbolCode;
  @override
  String get period;
  @override
  String get interval;
  @override
  List<OHLCV> get data;

  /// Create a copy of HistoricalData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoricalDataImplCopyWith<_$HistoricalDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
