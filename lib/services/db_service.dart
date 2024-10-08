import 'dart:convert';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:streaksmate/models/streaks_model.dart';

class DbProvider {
  static DbProvider? _dbProvider;
  static Database? _database;

  String tableName = 'streaks';
  String colId = 'id';
  String colTitle = 'title';
  String colGoal = 'goal';

  factory DbProvider() {
    _dbProvider ??= DbProvider._createInstance();
    return _dbProvider!;
  }

  Future<Database> get database async {
    _database ??= await initializeDb();
    return _database!;
  }

  DbProvider._createInstance();

  Future<Database> initializeDb() async {
    final database = openDatabase(
      path.join(
        await getDatabasesPath(),
        'streaks.db',
      ),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, dates TEXT, goal INTEGER, icon INTEGER)',
        );
      },
      version: 1,
    );
    return database;
  }

  // fetch operation
  Future<List<Streak>> getStreakList() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(
      maps.length,
      (i) {
        return Streak.withId(
          maps[i]['id'],
          maps[i]['title'],
          maps[i]['goal'],
          List<String>.from(jsonDecode(maps[i]['dates'])),
          maps[i]['icon'],
        );
      },
    );
  }

  Future<int> insertStreak(Streak streak) async {
    final Database db = await database;
    int result = await db.insert(
      tableName,
      streak.toMap(),
    );
    return result;
  }

  Future<int> update(Streak streak) async {
    final db = await database;
    return await db.update(
      tableName,
      streak.toMap(),
      where: 'id = ?',
      whereArgs: [streak.id],
    );
  }

  Future<int> delete(Streak streak) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [streak.id],
    );
  }
}
