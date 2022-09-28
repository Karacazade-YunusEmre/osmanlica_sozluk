import 'package:flutter/material.dart';
import 'package:lugat/repository/base/i_sentence_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/concrete/sentence_model.dart';
import '../../utilities/create_tables.dart';
import 'database_helper.dart';

/// Created by Yunus Emre Yıldırım
/// on 23.09.2022

class SentenceDal implements ISentenceRepository {
  @override
  Future<bool> add(SentenceModel item) async {
    Database? db = await DatabaseHelper.getDB;
    try {
      await db.insert(tableSentenceName, item.toJson());
      return true;
    } on Exception catch (e) {
      debugPrint('Cümle ekleme sırasında hata çıktı. ${e.toString()}');
      return false;
    }
  }

  @override
  Future<bool> delete(SentenceModel item) async {
    Database? db = await DatabaseHelper.getDB;
    try {
      await db.delete(tableSentenceName, where: 'id=?', whereArgs: [item.id]);
      return true;
    } on Exception catch (e) {
      debugPrint('Cümle silme sırasında hata çıktı. ${e.toString()}');
      return false;
    }
  }

  @override
  Future<List<SentenceModel>> getAll() async {
    Database? db = await DatabaseHelper.getDB;

    List<Map<String, Object?>>? objectList = await db.query(tableSentenceName);
    List<SentenceModel> sentenceModelList = objectList.map((item) => SentenceModel.fromJson(item)).toList();
    return sentenceModelList;
  }

  @override
  Future<bool> update(SentenceModel item) async {
    Database? db = await DatabaseHelper.getDB;
    try {
      await db.update(tableSentenceName, item.toJson(), where: 'id=?', whereArgs: [item.id]);
      return true;
    } on Exception catch (e) {
      debugPrint('Cümle güncelleme sırasında hata çıktı. ${e.toString()}');
      return false;
    }
  }

  @override
  Future<bool> addAll(List<SentenceModel> sentenceList) async {
    Database? db = await DatabaseHelper.getDB;
    try {
      Batch batch = db.batch();

      for (SentenceModel item in sentenceList) {
        batch.insert(tableSentenceName, item.toJson());
      }
      await batch.commit(noResult: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isTableEmpty() async {
    Database? db = await DatabaseHelper.getDB;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT * FROM $tableSentenceName'));

    if (count != null && count != 0) {
    return false;
    } else {
    return true;
    }
  }
}
