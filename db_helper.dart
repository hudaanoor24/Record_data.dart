import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> _getDb() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'grading.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE grading(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            course TEXT,
            semester TEXT,
            credit TEXT,
            marks TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  static Future<void> initDb() async {
    await _getDb();
  }

  static Future<int> insertRecord(Map<String, dynamic> data) async {
    final db = await _getDb();
    return await db.insert('grading', data);
  }

  static Future<List<Map<String, dynamic>>> getRecords() async {
    final db = await _getDb();
    return await db.query('grading');
  }

  static Future<int> updateRecord(int id, Map<String, dynamic> data) async {
    final db = await _getDb();
    return await db.update('grading', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteRecord(int id) async {
    final db = await _getDb();
    return await db.delete('grading', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearTable() async {
    final db = await _getDb();
    await db.delete('grading');
  }
}
