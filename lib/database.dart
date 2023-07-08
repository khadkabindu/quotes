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

  Future<void> bulkInsert(List<Quote> quotes) async {
    final db = await database;
    await db!.transaction((txn) async {
      Batch batch = db!.batch();
      int count = 0;
      try {
        for (Quote quote in quotes) {
          print("Insert To Map : ${quote.toMap()}");
          count++;
          if (count == 10) {
            break;
          }
          batch.insert("quote", quote.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      } catch (e) {
        print("-----Error: $e");
      }

      await batch.commit();
      // int? count = Sqflite.firstIntValue(
      //     await db.rawQuery("Select count(*) from quote"));
      // print("After bulk insert count = $count");
    });
  }

  Future<List<Quote>> search(String keyword) async {
    final db = await database;
    List<Map<String, dynamic>> quoteMaps = await db!.rawQuery(
      "SELECT * FROM quote WHERE category LIKE '%$keyword%'",
    );

    List<Quote> quotes = [];
    for (var quoteMap in quoteMaps) {
      quotes.add(Quote(
        id: quoteMap['id'],
        txt: quoteMap['txt'],
        author: quoteMap['author'],
        category: quoteMap['category'],
      ));
    }
    print(quotes);
    return quotes;
  }

  Future<Quote> findById(int id) async {
    final db = await database;
    List<Map<dynamic, dynamic>> result =
        await db!.query("quote", where: "id = ?", whereArgs: [id]);
    Quote quote = Quote(
        id: result[0]['id'],
        txt: result[0]['txt'],
        author: result[0]['author'],
        category: result[0]['category']);
    return quote;
  }


  filterCategory() async{

    List<String> uniqueCategories = [];
    final db = await database;
    List<Map<String, dynamic>> result = await db!.query("quote");
    for (var row in result) {
      String category = row['category'];
      if (category.contains(',')) {
        List<String> categories = category.split(", ");
        for (var element in categories) {
          if (!uniqueCategories.contains(element.trim())) {
            uniqueCategories.add(element.trim());
          }
        }
      } else {
        if (!uniqueCategories.contains(category.trim())) {
          uniqueCategories.add(category.trim());
        }
      }
    }
    print("Unique Categories: $uniqueCategories");
    return uniqueCategories;

  }






}
