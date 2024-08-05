import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  final String _money = '''CREATE TABLE money(
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            title TEXT,
                            date_money DATETIME,
                            value REAL,
                            situation_of_money TEXT)''';

  DB._();

  static final instance = DB._();

  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

   _initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'plus_plus_pocket.db'),
      onCreate: _onCreate,
      version: 1,
    );

    return database;
  }

  _onCreate(db, version) async{
    await db.execute(_money);
  }
}
