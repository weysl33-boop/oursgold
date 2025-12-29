// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NewsArticle _$NewsArticleFromJson(Map<String, dynamic> json) {
  return _NewsArticle.fromJson(json);
}

/// @nodoc
mixin _$NewsArticle {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  DateTime get publishedAt => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  List<String> get relatedSymbols => throw _privateConstructorUsedError;

  /// Serializes this NewsArticle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NewsArticle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewsArticleCopyWith<NewsArticle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsArticleCopyWith<$Res> {
  factory $NewsArticleCopyWith(
          NewsArticle value, $Res Function(NewsArticle) then) =
      _$NewsArticleCopyWithImpl<$Res, NewsArticle>;
  @useResult
  $Res call(
      {String id,
      String title,
      String category,
      DateTime publishedAt,
      String? thumbnailUrl,
      String? content,
      List<String> relatedSymbols});
}

/// @nodoc
class _$NewsArticleCopyWithImpl<$Res, $Val extends NewsArticle>
    implements $NewsArticleCopyWith<$Res> {
  _$NewsArticleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewsArticle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? publishedAt = null,
    Object? thumbnailUrl = freezed,
    Object? content = freezed,
    Object? relatedSymbols = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: null == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedSymbols: null == relatedSymbols
          ? _value.relatedSymbols
          : relatedSymbols // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NewsArticleImplCopyWith<$Res>
    implements $NewsArticleCopyWith<$Res> {
  factory _$$NewsArticleImplCopyWith(
          _$NewsArticleImpl value, $Res Function(_$NewsArticleImpl) then) =
      __$$NewsArticleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String category,
      DateTime publishedAt,
      String? thumbnailUrl,
      String? content,
      List<String> relatedSymbols});
}

/// @nodoc
class __$$NewsArticleImplCopyWithImpl<$Res>
    extends _$NewsArticleCopyWithImpl<$Res, _$NewsArticleImpl>
    implements _$$NewsArticleImplCopyWith<$Res> {
  __$$NewsArticleImplCopyWithImpl(
      _$NewsArticleImpl _value, $Res Function(_$NewsArticleImpl) _then)
      : super(_value, _then);

  /// Create a copy of NewsArticle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? publishedAt = null,
    Object? thumbnailUrl = freezed,
    Object? content = freezed,
    Object? relatedSymbols = null,
  }) {
    return _then(_$NewsArticleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: null == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedSymbols: null == relatedSymbols
          ? _value._relatedSymbols
          : relatedSymbols // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NewsArticleImpl implements _NewsArticle {
  const _$NewsArticleImpl(
      {required this.id,
      required this.title,
      required this.category,
      required this.publishedAt,
      this.thumbnailUrl,
      this.content,
      final List<String> relatedSymbols = const []})
      : _relatedSymbols = relatedSymbols;

  factory _$NewsArticleImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsArticleImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String category;
  @override
  final DateTime publishedAt;
  @override
  final String? thumbnailUrl;
  @override
  final String? content;
  final List<String> _relatedSymbols;
  @override
  @JsonKey()
  List<String> get relatedSymbols {
    if (_relatedSymbols is EqualUnmodifiableListView) return _relatedSymbols;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedSymbols);
  }

  @override
  String toString() {
    return 'NewsArticle(id: $id, title: $title, category: $category, publishedAt: $publishedAt, thumbnailUrl: $thumbnailUrl, content: $content, relatedSymbols: $relatedSymbols)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsArticleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._relatedSymbols, _relatedSymbols));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      category,
      publishedAt,
      thumbnailUrl,
      content,
      const DeepCollectionEquality().hash(_relatedSymbols));

  /// Create a copy of NewsArticle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsArticleImplCopyWith<_$NewsArticleImpl> get copyWith =>
      __$$NewsArticleImplCopyWithImpl<_$NewsArticleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsArticleImplToJson(
      this,
    );
  }
}

abstract class _NewsArticle implements NewsArticle {
  const factory _NewsArticle(
      {required final String id,
      required final String title,
      required final String category,
      required final DateTime publishedAt,
      final String? thumbnailUrl,
      final String? content,
      final List<String> relatedSymbols}) = _$NewsArticleImpl;

  factory _NewsArticle.fromJson(Map<String, dynamic> json) =
      _$NewsArticleImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get category;
  @override
  DateTime get publishedAt;
  @override
  String? get thumbnailUrl;
  @override
  String? get content;
  @override
  List<String> get relatedSymbols;

  /// Create a copy of NewsArticle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewsArticleImplCopyWith<_$NewsArticleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
