// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsArticleImpl _$$NewsArticleImplFromJson(Map<String, dynamic> json) =>
    _$NewsArticleImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      content: json['content'] as String?,
      relatedSymbols: (json['relatedSymbols'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NewsArticleImplToJson(_$NewsArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'thumbnailUrl': instance.thumbnailUrl,
      'content': instance.content,
      'relatedSymbols': instance.relatedSymbols,
    };
