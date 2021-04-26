import 'dart:io';
import 'dart:ui';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/extension/LocalNotification.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/ui/splash_screen/SplashScreenPresenter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_version/get_version.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen, SplashScreenPresenter> {
  String _homeScreenText = "Waiting for token...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<Map<PermissionGroup, PermissionStatus>> permissionsAndroid() async =>
      await PermissionHandler().requestPermissions([PermissionGroup.camera, PermissionGroup.storage]);

  Future<Map<PermissionGroup, PermissionStatus>> permissionsIos() async =>
      await PermissionHandler().requestPermissions([PermissionGroup.camera]);

  @override
  SplashScreenPresenter initPresenter() => SplashScreenPresenter(this);

  @override
  void afterWidgetBuilt() async {
    if(Platform.isAndroid) {
      var permissionResult = await permissionsAndroid();
      if(permissionResult[PermissionGroup.storage] == PermissionStatus.granted){
        delay(2500, () async {
          navigateTo(MyApp.ROUTE_HOME, singleTop: true);
        });
      }
    } else {
      var permissionResult = await permissionsIos();
      if(permissionResult[PermissionGroup.camera] == PermissionStatus.granted){
        delay(2500, () async {
          navigateTo(MyApp.ROUTE_HOME, singleTop: true);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        print("data: ${message['data']['id_news']}");
        showNotification(message['notification']['title'], message['notification']['body']);
        // LocalNotification.showNotification(message);
        // _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
        presenter.executeToken(token);
      });
      print(_homeScreenText);
    });
    // FirebaseMessaging.onMessage.listen((event) {
    //   print("onMessage: ${event.data}");
    //   print("data: ${event.data['id_news']}");
    //   // _showItemDialog(message);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   print("onLaunch: ${event.notification}");
    //   // _navigateToItemDetail(message);
    // });
    //
    // _firebaseMessaging.requestPermission();
    // _firebaseMessaging.getToken().then((String token) {
    //   assert(token != null);
    //   print("Push Messaging token: $token");
    //   presenter.executeToken(token);
    // });

    if(Platform.isAndroid) {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) => {
        print('Version ID: ${packageInfo.appName}')
      });
    } else if(Platform.isIOS) {
      GetVersion.projectCode.then((String version) {
        print('Version ID: $version');
      });
    }

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) => {
      print('Version ID: ${packageInfo.packageName}')
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

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.Max,
        playSound: true,
        showProgress: true,
        priority: Priority.High,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  // Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) {
  //   print("onBackgroundMessage: $message");
  //   return LocalNotification.showNotification(message);
  // }
}