import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            isDone INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertTask(Task task) async {
    final dbClient = await db;
    return dbClient.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final dbClient = await db;
    final res = await dbClient.query('tasks');
    return res.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> updateTask(Task task) async {
    final dbClient = await db;
    return dbClient.update(
      'tasks',
      task.toMap(),
      where: 'id=?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final dbClient = await db;
    return dbClient.delete('tasks', where: 'id=?', whereArgs: [id]);
  }
}