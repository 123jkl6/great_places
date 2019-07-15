import "package:sqflite/sqflite.dart" as sql;
import "package:path/path.dart" as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, "places.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE USER_PLACES(id TEXT PRIMARY KEY, title TEXT, image TEXT)");
      },
      version: 1,
    );
    return db;
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    //execute update in csae of existing primary keys
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String,dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
