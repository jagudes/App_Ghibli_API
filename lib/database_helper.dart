import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ghibli_app/film_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ghibli.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(join(dbPath, filePath), version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE films (
          id TEXT PRIMARY KEY,
          title TEXT,
          director TEXT,
          description TEXT,
          image TEXT
        )
      ''');
    });
  }

  Future<void> saveFilms(List<FilmModel> films) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var film in films) {
      batch.insert('films', {
        'id': film.id,
        'title': film.title,
        'director': film.director,
        'description': film.description,
        'image': film.image
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<List<FilmModel>> getFilms() async {
    final db = await instance.database;
    final result = await db.query('films');
    return result.map((json) => FilmModel.fromJson(json)).toList();
  }
}