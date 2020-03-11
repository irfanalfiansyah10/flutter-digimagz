import 'dart:convert';
import 'dart:ui';

import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/network/response/UserResponse.dart';
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:digimagz/ui/splash_screen/SplashScreenPresenter.dart';
import 'package:flutter/material.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen, SplashScreenPresenter> {

  @override
  SplashScreenPresenter initPresenter() => SplashScreenPresenter(this);

  @override
  void afterWidgetBuilt() {
    delay(2500, () async {
      var json = "{\"status\": true,\"data\": [{\"EMAIL\": \"firnasreyhan@gmail.com\",\"USER_NAME\": \"Adani Firnas\",\"PROFILEPIC_URL\": \"http://pn10mobprd.ptpn10.co.id:8598/images/users/cropped-949833815.jpg\",\"LAST_LOGIN\": \"2019-10-07 10:07:30\",\"DATE_BIRTH\": \"2012-12-12\",\"GENDER\": \"L\",\"USER_TYPE\": \"External\"}]}";
      var user = UserResponse.fromJson(jsonDecode(json));
      await AppPreference.saveUser(user.data[0]);
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

