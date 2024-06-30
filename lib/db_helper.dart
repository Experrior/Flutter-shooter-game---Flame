import 'package:path/path.dart';
import 'package:archerer/home.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    
    sqfliteFfiInit();   
    databaseFactory = databaseFactoryFfi;
    var localDbPath = join('.dart_tool', 'sqflite_exp', 'test', 'databases');
    await databaseFactory.setDatabasesPath(localDbPath);
    String path = join(await databaseFactory.getDatabasesPath(), 'highscore.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE highscores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dateTime TEXT,
        score INTEGER
      )
    ''');
  }

  Future<void> clearHighScores() async {
    final db = await database;
    await db.delete('highscores');
  }

 
  Future<Database?> getDatabase() async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<List<HighScore>> getHighScores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('highscores',
    orderBy: 'score DESC');
    return List.generate(maps.length, (i) {
      return HighScore.fromMap(maps[i]);
    });
  }

  Future<void> insertHighScore(HighScore highScore) async {
    final db = await database;
    await db.insert(
      'highscores',
      highScore.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
