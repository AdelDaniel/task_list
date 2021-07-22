import 'package:path/path.dart'
    as path; // will find the location or the path of database
import 'package:sqflite/sqflite.dart';

import '../models/task_model.dart';

class DBHelper {
  static const String _databaseName = "MyDatabase.db";
  static const int _databaseVersion = 1;

  static const String _tableName = 'my_table';

  //constructor return _instance
  factory DBHelper() => _instance;
  //named constructor return
  DBHelper._internal();
  // only one instance of our class
  static final DBHelper _instance = DBHelper._internal();

  Database? _database;
  Future<Database> get _getdatabase async {
    print('get db');
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _createDatabase();
    return _database!;
  }

  Future<Database> _createDatabase() async {
    print('Before :: data base created...');
    final String _path = path.join(await getDatabasesPath(), _databaseName);
    final Database database = await openDatabase(
      _path,
      version: _databaseVersion,
      onCreate: (Database db, int v) {
        db.execute("""
            CREATE TABLE $_tableName(
   $columnId                INTEGER PRIMARY KEY AUTOINCREMENT,
   $columnTitle             TEXT,
   $columnIsTaskDone        INTEGER,
   $columnIsTaskArchived    INTEGER,
   $columnTaskTime          TEXT
  );      """);
      },
    );
    print('data base created...');
    return database;
  }

  Future<int> insert(Task task) async {
    final Database db = await _getdatabase;
    // the id is auto generate so we must retur it
    return db.insert(_tableName, task.toDBMap());
  }

  Future<int> update(Task task) async {
    final Database db = await _getdatabase;
    // the id is auto generate so we must retur it
    return db.update(_tableName, task.toDBMap(),
        where: '$columnId = ?', whereArgs: <Object>[task.id]);
  }

  Future<List<Task>> getAllTasks() async {
    print('getting all tasks');
    final Database db = await _getdatabase;
    final List<Map<String, Object?>> tableData = await db.query(_tableName);
    return tableData
        .map<Task>((Map<String, Object?> item) => Task.fromDbMap(item))
        .toList();
  }

  Future<List<Task>> getNotDoneNotArchivedTask() async {
    final Database db = await _getdatabase;
    final List<Map<String, Object?>> tableData = await db.rawQuery("""
        SELECT * FROM $_tableName
        WHERE $columnIsTaskDone = 0 
        AND $columnIsTaskArchived = 0;
         """);
    return tableData
        .map<Task>((Map<String, Object?> item) => Task.fromDbMap(item))
        .toList();
  }

  Future<List<Task>> getArchivedTasks() async {
    final Database db = await _getdatabase;
    final List<Map<String, Object?>> tableData = await db.query(_tableName,
        where: '$columnIsTaskArchived = ?', whereArgs: <Object>[1]);
    return tableData
        .map<Task>((Map<String, Object?> item) => Task.fromDbMap(item))
        .toList();
  }

  Future<List<Task>> getDoneTasks() async {
    final Database db = await _getdatabase;
    final List<Map<String, Object?>> tableData = await db.query(_tableName,
        where: '$columnIsTaskDone = ?', whereArgs: <Object>[1]);
    return tableData
        .map<Task>((Map<String, Object?> item) => Task.fromDbMap(item))
        .toList();
  }

  Future<int> delete(int id) async {
    final Database db = await _getdatabase;
    return db
        .delete(_tableName, where: '$columnId = ?', whereArgs: <Object>[id]);
  }
}
