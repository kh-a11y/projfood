import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'recipe.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _db;

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'favorites.db');
    return openDatabase(
      path,
      version: 3, // 🔼 زوّد رقم النسخة لتفعيل onUpgrade
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            image TEXT,
            description TEXT,
            url TEXT,
            isFavorite INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // ✅ حذف الجدول القديم وإعادة إنشائه بشكل صحيح إذا تغيرت الحقول
        await db.execute('DROP TABLE IF EXISTS favorites');
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            image TEXT NOT NULL,
            description TEXT NOT NULL,
            url TEXT NOT NULL,
            isFavorite INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  /// ✅ إرجاع ID بعد الإدخال
  static Future<int> insertFavorite(Recipe recipe) async {
    final dbClient = await instance.db;
    return await dbClient.insert(
      'favorites',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteFavorite(int id) async {
    final dbClient = await instance.db;
    await dbClient.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Recipe>> getFavorites() async {
    final dbClient = await instance.db;
    final maps = await dbClient.query('favorites');
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  static Future<void> clearFavorites() async {
    final dbClient = await instance.db;
    await dbClient.delete('favorites');
  }
}
