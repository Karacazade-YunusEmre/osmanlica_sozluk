import 'package:json_annotation/json_annotation.dart';

import '../abstract/i_base_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 23.09.2022

part 'directory_model.g.dart';

@JsonSerializable()
class DirectoryModel implements IBaseModel {
  String id;
  String name;

  DirectoryModel({required this.id, required this.name});

  factory DirectoryModel.fromJson(Map<String, dynamic> json) => _$DirectoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DirectoryModelToJson(this);
}
