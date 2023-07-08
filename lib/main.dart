import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quotes/category_chip.dart';
import 'package:quotes/database.dart';
import 'package:quotes/notification_helper.dart';
import 'package:quotes/pref_util.dart';
import 'package:quotes/quote.dart';
import 'file_util.dart';

void main() async {
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
      // CategoryChip();
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

  Future<Quote> getData() {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Random random = Random();
    int rand = random.nextInt(2075) + 1;
    return databaseHelper.findById(rand);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6e491),
      body: SafeArea(
        child: FutureBuilder<Quote>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "/quotes",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        CircleAvatar(
                          backgroundImage: AssetImage("images/profile.jpg"),
                          radius: 18,
                        )
                      ],
                    ),
                    Text(
                      "Welcome Back !",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Text(
                            snapshot.data.txt,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 Icon(Icons.favorite_outline),
                                 Text(" 224"),
                               ],
                             ),
                             Row(
                               children: [Text(snapshot.data.author)],
                             ),
                           ],
                         )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          getData();
                        });
                      },
                      child: Container(
                        height: 70,
                        width: 100,
                        color: Colors.green,
                        child: const Text('Next'),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return const Text(
                "Could not fetch data",
                style: TextStyle(color: Colors.white),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Container dottedContainer() {
    return Container(
      height: 1,
      width: 5,
      color: Colors.black,
    );
  }
}

void notificationTapBackground(NotificationResponse details) {
  print(
      "Background------------${details.id}, ${details.input}----------------");
}

void onNotificationReceived(NotificationResponse details) {
  print(
      "Foreground------------${details.id}, ${details.input}----------------");
  DatabaseHelper databaseHelper = DatabaseHelper();
  databaseHelper.search("love");
}
