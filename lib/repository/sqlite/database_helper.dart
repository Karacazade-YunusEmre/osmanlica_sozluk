import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../utilities/create_tables.dart';

/// Created by Yunus Emre Yıldırım
/// on 23.09.2022

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  static const int _dbVersion = 1;

  factory DatabaseHelper() {
    return _databaseHelper ??= DatabaseHelper._createInstance();
  }

  DatabaseHelper._createInstance();

  static Future<Database> get getDB async {
    _database ??= await _initializeDB;
    return _database!;
  }

  static Future<Database> get _initializeDB async {
    final databasePath = await getDatabasesPath();
    String absolutePath = join(databasePath, 'appDB.db');

    return openDatabase(absolutePath, version: _dbVersion, onCreate: _createDB);
  }

  static Future<FutureOr<void>> _createDB(Database db, int version) async {
    await db.execute(createSentenceTable);
    await db.execute(createDirectoryTable);
  }
}
