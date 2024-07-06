import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  // create table function
  static Future<void> createTables(sql.Database databases) async {
    await databases.execute("""CREATE TABLE data(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      note TEXT,
      createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  // connect database function
  static Future<sql.Database> db() async {
    return sql.openDatabase('notes.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // create note function
  static Future<int> createNote(String? title, String? note) async {
    final db = await SqlHelper.db();
    final data = {'title': title, 'note': note};
    final id = await db.insert(
      'data',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return id;
  }

  // Get All Data From Database
  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SqlHelper.db();
    return db.query('data', orderBy: 'id');
  }

  // Update Data Function
  static Future<int> updateData(
    int id,
    String title,
    String? note,
  ) async {
    final db = await SqlHelper.db();
    final data = {
      "title": title,
      "note": note,
      "createAt": DateTime.now().toString(),
    };
    final result =
        await db.update('data', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  // Delete Function
  static Future<void> deleteData(int id) async {
    final db = await SqlHelper.db();
    try {
      await db.delete('data', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print(e);
    }
  }
}
