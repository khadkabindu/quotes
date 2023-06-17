import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quotes/database.dart';
import 'package:quotes/pref_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper databaseHelper = DatabaseHelper();
  databaseHelper.database;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {

   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {

    PrefUtil.isFirstLaunch().then((value){
      print(value);
    }).catchError((error){
      if(error is HttpException){

      }
      print(error);
    });

    FileUtil fileUtil = FileUtil();
     fileUtil.saveData().then((value) => value).catchError((e){
       print(e);
     });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PrefUtil.isFirstLaunch(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
      return Text(snapshot.data.toString());

    });
  }
}



