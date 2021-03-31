import 'dart:io';
import 'dart:ui';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/ui/splash_screen/SplashScreenPresenter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen, SplashScreenPresenter> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
      if(permissionResult[PermissionGroup.camera] == PermissionStatus.granted
          && permissionResult[PermissionGroup.storage] == PermissionStatus.granted){
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
    FirebaseMessaging.onMessage.listen((event) {
      print("onMessage: ${event.data}");
      print("data: ${event.data['id_news']}");
      // _showItemDialog(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("onLaunch: ${event.notification}");
      // _navigateToItemDetail(message);
    });

    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
      presenter.executeToken(token);
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