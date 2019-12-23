import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/main.dart';
import 'package:flutter/material.dart';

class SplashScreen extends BaseStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen> {

  @override
  void afterWidgetBuilt() {
    Future.delayed(Duration(seconds: 3)).then((_){
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
              )
          ),
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}

