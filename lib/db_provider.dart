import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/toDoModel.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE TODO(
          id INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT,
          date TEXT
      )
      ''');
  }

  Future<List<ToDo>> getList() async {
    Database db = await instance.database;
    var res = await db.rawQuery('SELECT * FROM TODO ORDER BY id DESC');
    print(res);
    List<ToDo> todoList = res.isNotEmpty
        ? res.map((c) => ToDo.fromMap(c)).toList()
        : [];
    return todoList;
  }

  Future<int> add(ToDo todo) async {
    Database db = await instance.database;
    return await db.insert('TODO', todo.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('TODO', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(ToDo todo) async {
    Database db = await instance.database;
    return await db.update('TODO', todo.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
  }
}