import 'dart:ui';

import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/ui/splash_screen/SplashScreenPresenter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen, SplashScreenPresenter> {
  final scaffoldState = GlobalKey();
  final firebaseMessaging = FirebaseMessaging();
  final controllerTopic = TextEditingController();
  bool isSubscribed = false;
  String token = '';

  static Future onBackgroundMessage(Map message) {
    print('onBackgroundMessage: $message');
    return null;
  }

  @override
  void initState() {
    firebaseMessaging.configure(
      onMessage: (Map message) async {
        print('onMessage: $message');
      },
      onBackgroundMessage: onBackgroundMessage,
      onResume: (Map message) async {
        print('onResume: $message');

      },
      onLaunch: (Map message) async {
        print('onLaunch: $message');

      },
    );
    firebaseMessaging.getToken().then((value) => print('token: $value'));
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true),
    );
    firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      debugPrint('Settings registered: $settings');
    });
    firebaseMessaging.getToken().then((token) => setState(() {
      this.token = token;
    }));
    super.initState();
  }

  @override
  SplashScreenPresenter initPresenter() => SplashScreenPresenter(this);

  @override
  void afterWidgetBuilt() {
    delay(2500, () async {
      navigateTo(MyApp.ROUTE_HOME, singleTop: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/canvas.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}

