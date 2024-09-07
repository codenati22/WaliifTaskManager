import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_manager_app/model/task.dart';

class DBHelper {
  static const String tableName = 'tasks';
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'task_manager.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            dueDate TEXT,
            status INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertTask(Task task) async {
    var dbClient = await db;
    return await dbClient.insert(tableName, task.toMap());
  }

  Future<List<Task>> getTasks() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(tableName);

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<int> updateTask(Task task) async {
    var dbClient = await db;
    return await dbClient
        .update(tableName, task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
