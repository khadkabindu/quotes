import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quotes/database.dart';
import 'package:quotes/notification_helper.dart';
import 'package:quotes/pref_util.dart';
import 'file_util.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper databaseHelper = DatabaseHelper();
  databaseHelper.database;

  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    onDidReceiveNotificationResponse: onNotificationReceived,

  );

  NotificationHelper notificationHelper = NotificationHelper();
  notificationHelper.repeatNotification();



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
      home: HomePage(),
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
    PrefUtil.isFirstLaunch().then((value) {
      print(value);
    }).catchError((error) {
      if (error is HttpException) {}
      print(error);
    });

    FileUtil fileUtil = FileUtil();
    fileUtil.saveData().then((value) => value).catchError((e) {
      print(e);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PrefUtil.isFirstLaunch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Text(snapshot.data.toString());
        });
  }
}

void notificationTapBackground(NotificationResponse details) {

  print("Background------------${details.id}, ${details.input}----------------");
}

void onNotificationReceived(NotificationResponse details) {
  print("Foreground------------${details.id}, ${details.input}----------------");


}
