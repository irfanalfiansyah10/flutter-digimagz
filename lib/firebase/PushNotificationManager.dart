import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  final FirebaseMessaging FM = FirebaseMessaging();

  Future initialize() async {
    if(Platform.isIOS) {
      FM.requestNotificationPermissions(IosNotificationSettings());
    }

    FM.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
  }
}