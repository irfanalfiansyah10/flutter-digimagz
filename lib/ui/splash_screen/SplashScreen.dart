import 'dart:ui';

import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/main.dart';
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

