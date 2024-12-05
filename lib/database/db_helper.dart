import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const _dbName = 'user_database.db';
  static const _dbVersion = 1;
  static const _tableName = 'users';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnSurname = 'surname';
  static const columnAge = 'age';
  static const columnHeight = 'height';
  static const columnGender = 'gender';
  static const columnWeight = 'weight';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnSurname TEXT NOT NULL,
            $columnAge INTEGER NOT NULL,
            $columnHeight REAL NOT NULL,
            $columnGender TEXT NOT NULL,
            $columnWeight REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(_tableName, user);
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final db = await database;
    return await db.query(_tableName);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}