import 'package:lugat/repository/base/i_sentence_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/concrete/sentence_model.dart';
import '../../utilities/create_tables.dart';
import 'database_helper.dart';

/// Created by Yunus Emre Yıldırım
/// on 23.09.2022

class SentenceDal implements ISentenceRepository {
  @override
  Future<List<SentenceModel>> getAll() async {
    Database? db = await DatabaseHelper.getDB;

    List<Map<String, Object?>>? objectList = await db.query(tableSentenceName);
    List<SentenceModel> sentenceModelList = objectList.map((item) => SentenceModel.fromJson(item)).toList();
    return sentenceModelList;
  }
}
