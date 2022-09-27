// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectoryModel _$DirectoryModelFromJson(Map<String, dynamic> json) =>
    DirectoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sentenceCount: json['sentenceCount'] as int,
    );

Map<String, dynamic> _$DirectoryModelToJson(DirectoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sentenceCount': instance.sentenceCount,
    };
