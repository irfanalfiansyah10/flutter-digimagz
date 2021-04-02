import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class LocalNotification {
  static Future<void> showNotification(dynamic payload) async {
    print("payload: ${payload.toString()}");
    var title = payload['notification']['title'].toString();
    var body = payload['notification']['body'].toString();
    // final dynamic data = jsonDecode(payload['data']);
    // final dynamic notification = jsonDecode(payload['notification']);
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'BBD', 'Notification', 'All Notification is Here',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    const IOSNotificationDetails iosPlatformChannelSpecifics = IOSNotificationDetails();
    // final int idNotification = data['id'] != null ? int.parse(data['id']) : 1;
    const NotificationDetails platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        1, title, body, platformChannelSpecifics);
  }

  Future<void> notificationHandler(GlobalKey<NavigatorState> navigatorKey) async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('logo_bbd_sm');
    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            NavigatorNavigate().go(navigatorKey, payload);
          }
        });
  }
}

class NavigatorNavigate {
  go(GlobalKey<NavigatorState> navState, String type) {
    switch(type) {
      case 'login':
        navState.currentState.pushNamed('/');
        break;

      default:
        navState.currentState.pushNamed('error');
    }
  }
}