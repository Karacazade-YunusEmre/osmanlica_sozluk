import 'package:json_annotation/json_annotation.dart';
import 'package:lugat/model/abstract/i_base_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 23.09.2022

part 'sentence_model.g.dart';

@JsonSerializable()
class SentenceModel implements IBaseModel {
  String id;
  String title;
  String content;
  String? listId;

  SentenceModel({required this.id, required this.title, required this.content, required this.listId});

  factory SentenceModel.fromJson(Map<String, dynamic> json) => _$SentenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceModelToJson(this);
}
