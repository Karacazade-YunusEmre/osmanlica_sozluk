import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '/model/concrete/directory_model.dart';
import '/repository/sqlite/database_helper.dart';
import '/utilities/create_tables.dart';

import '../base/i_directory_repository.dart';

/// Created by Yunus Emre Yıldırım
/// on 23.09.2022

class DirectoryDal implements IDirectoryRepository {
  @override
  Future<bool> add(DirectoryModel item) async {
    Database? db = await DatabaseHelper.getDB;
    try {
      await db.insert(tableDirectoryName, item.toJson());
      return true;
    } on Exception catch (e) {
      debugPrint('Klasöre ekleme sırasında hata çıktı. ${e.toString()}');
      return false;
    }
  }

  @override
  Future<bool> delete(DirectoryModel item) async {
    Database? db = await DatabaseHelper.getDB;
    try {
      await db.delete(tableDirectoryName, where: 'id=?', whereArgs: [item.id]);
      return true;
    } on Exception catch (e) {
      debugPrint('Klasörü silme sırasında hata çıktı. ${e.toString()}');
      return false;
    }
  }

  @override
  Future<List<DirectoryModel>> getAll() async {
    Database? db = await DatabaseHelper.getDB;

    List<Map<String, Object?>>? objectList = await db.query(tableDirectoryName);
    List<DirectoryModel> directoryModelList = objectList.map((item) => DirectoryModel.fromJson(item)).toList();
    return directoryModelList;
  }

  @override
  Future<bool> update(DirectoryModel item) async {
    Database? db = await DatabaseHelper.getDB;
    try {
      await db.update(tableDirectoryName, item.toJson(), where: 'id=?', whereArgs: [item.id]);
      return true;
    } on Exception catch (e) {
      debugPrint('Klasör güncelleme sırasında hata çıktı. ${e.toString()}');
      return false;
    }
  }
}
