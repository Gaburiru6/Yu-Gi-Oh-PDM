import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/hero_model.dart';
import 'dart:math';

class DatabaseHelper {
  static final _databaseName = "HeroApp.db";
  static final _databaseVersion = 1;

  static final tableHeroes = 'heroes';
  static final tableMyCards = 'my_cards';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableHeroes (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            powerstats TEXT NOT NULL,
            appearance TEXT NOT NULL,
            biography TEXT NOT NULL,
            images TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableMyCards (
            hero_id INTEGER PRIMARY KEY,
            FOREIGN KEY (hero_id) REFERENCES $tableHeroes (id)
          )
          ''');
  }

  Future<void> batchInsertHeroes(List<HeroModel> heroes) async {
    Database db = await instance.database;
    Batch batch = db.batch();
    for (var hero in heroes) {
      batch.insert(tableHeroes, hero.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<HeroModel>> getAllHeroes() async {
    Database db = await instance.database;
    var res = await db.query(tableHeroes);
    List<HeroModel> list =
    res.isNotEmpty ? res.map((c) => HeroModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<HeroModel>> getPaginatedHeroes(int page, int pageSize) async {
    Database db = await instance.database;
    int offset = (page - 1) * pageSize;
    var res =
    await db.query(tableHeroes, limit: pageSize, offset: offset);
    List<HeroModel> list =
    res.isNotEmpty ? res.map((c) => HeroModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> getHeroCount() async {
    Database db = await instance.database;
    var res = await db.rawQuery('SELECT COUNT(*) FROM $tableHeroes');
    return Sqflite.firstIntValue(res) ?? 0;
  }

  Future<HeroModel?> getRandomHero() async {
    Database db = await instance.database;
    int count = await getHeroCount();
    if (count == 0) return null;

    int randomIndex = Random().nextInt(count);

    var res = await db.query(tableHeroes, limit: 1, offset: randomIndex);
    if (res.isNotEmpty) {
      return HeroModel.fromMap(res.first);
    }
    return null;
  }

  Future<int> addHeroToMyCards(int heroId) async {
    Database db = await instance.database;
    return await db.insert(
      tableMyCards,
      {'hero_id': heroId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getMyCardsCount() async {
    Database db = await instance.database;
    var res = await db.rawQuery('SELECT COUNT(*) FROM $tableMyCards');
    return Sqflite.firstIntValue(res) ?? 0;
  }

  Future<bool> isHeroInMyCards(int heroId) async {
    Database db = await instance.database;
    var res = await db
        .query(tableMyCards, where: 'hero_id = ?', whereArgs: [heroId]);
    return res.isNotEmpty;
  }

  Future<List<HeroModel>> getMyCards() async {
    Database db = await instance.database;
    final String sql = '''
      SELECT T1.* FROM $tableHeroes T1
      INNER JOIN $tableMyCards T2 ON T1.id = T2.hero_id
    ''';
    var res = await db.rawQuery(sql);
    List<HeroModel> list =
    res.isNotEmpty ? res.map((c) => HeroModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> removeHeroFromMyCards(int heroId) async {
    Database db = await instance.database;
    return await db
        .delete(tableMyCards, where: 'hero_id = ?', whereArgs: [heroId]);
  }
}

