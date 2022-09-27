// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentenceModel _$SentenceModelFromJson(Map<String, dynamic> json) =>
    SentenceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      listId: json['listId'] as String?,
    );

Map<String, dynamic> _$SentenceModelToJson(SentenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'listId': instance.listId,
    };
