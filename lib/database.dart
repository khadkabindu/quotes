import 'package:quotes/quote.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();


  Future<Database?> get database async {
    _database ??= await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'quotes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE quote(id INTEGER PRIMARY KEY, txt TEXT, author TEXT, category TEXT )',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insert(Quote quote) async {
    final db = await database;
    db?.insert(
      "quote",
      quote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> bulkInsert(List<Quote> quotes)async{
    final db = await database;

    Batch batch =  db!.batch();
    for(Quote quote in quotes){
      batch.insert("quote", quote.toMap());
    }
    await batch.commit(noResult: true);
  }
}

//
