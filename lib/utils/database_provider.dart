import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'foodly.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 2,
      onCreate: create,
      onUpgrade: onUpgrade,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database db, int version) async {
    await db.execute(
      'CREATE TABLE settings (id INTEGER PRIMARY KEY, theme TEXT, language TEXT)',
    );
    await db.execute(
      "CREATE TABLE scan_history (id INTEGER PRIMARY KEY, image BLOB, createdAt TEXT)",
    );
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute(
        "CREATE TABLE scan_history (id INTEGER PRIMARY KEY, image BLOB, createdAt TEXT)",
      );
    }
  }
}
