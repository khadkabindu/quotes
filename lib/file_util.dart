import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes/database.dart';
import 'package:quotes/pref_util.dart';
import 'package:quotes/quote.dart';

class FileUtil {
  Future<String> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> getLocalFile() async {
    String path = await getPath();
    return File('$path/data.csv');
  }

  Future<String> saveData() async {
    if (await PrefUtil.isFirstLaunch()) {
      print("First launch--------------");
      DatabaseHelper databaseHelper = DatabaseHelper();
      List<List<dynamic>> result = await readData();
      int counter = 0;
      try {
        List<Quote> quotes = [];
        for (List<dynamic> line in result) {
          counter += 1;
          Quote quote = Quote(
              id: counter, txt: line[0], author: line[1], category: line[2]);
          quotes.add(quote);
        }
        databaseHelper.bulkInsert(quotes);
      } catch (e) {
        throw Exception(e);
      }
    } else {
      print("Not first launch----------------");
    }

    return "";
  }

  Future<List<List<dynamic>>> readData() async {
    String content = await rootBundle.loadString("assets/quotes.csv");
    List<List<dynamic>> result =
        CsvToListConverter().convert(content, eol: "\n");
    return result;
  }
}
