
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  int id = 2;
  Future<void> repeatNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'repeating channel id', 'repeating channel name',
        channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id++,
      "Have you checked today's quote",
      'repeating body',
      RepeatInterval.everyMinute,
      notificationDetails,
      androidAllowWhileIdle: true,
    );
  }

}