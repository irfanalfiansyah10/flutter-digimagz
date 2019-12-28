import 'package:digimagz/provider/LikeProvider.dart';
import 'package:digimagz/ui/detail/news/DetailNews.dart';
import 'package:digimagz/ui/detail/story/DetailStory.dart';
import 'package:digimagz/ui/home/Home.dart';
import 'package:digimagz/ui/list/news/ListNews.dart';
import 'package:digimagz/ui/login/Login.dart';
import 'package:digimagz/ui/login_email/LoginEmail.dart';
import 'package:digimagz/ui/splash_screen/SplashScreen.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//export PATH="$PATH:/Users/apple/Documents/flutter/bin"

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const ROUTE_ROOT = "/";
  static const ROUTE_HOME = "/home";
  static const ROUTE_LIST_NEWS = "/listNews";
  static const ROUTE_LOGIN = "/login";
  static const ROUTE_DETAIL_NEWS = "/detailNews";
  static const ROUTE_DETAIL_STORY = "/detailStory";
  static const ROUTE_LOGIN_EMAIL = "/loginEmail";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LikeProvider>(create: (_) => LikeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ColorUtils.primary,
          primaryColorDark: ColorUtils.primaryDark,
          primaryColorLight: Colors.white
        ),
        onGenerateRoute: (settings){
          switch(settings.name){
            case ROUTE_ROOT :
              return MaterialPageRoute(builder: (ctx) => SplashScreen());
            case ROUTE_HOME :
              return MaterialPageRoute(builder: (ctx) => Home());
            case ROUTE_LIST_NEWS :
              return MaterialPageRoute(builder: (ctx) => ListNews(settings.arguments));
            case ROUTE_LOGIN :
              return MaterialPageRoute(builder: (ctx) => Login());
            case ROUTE_DETAIL_NEWS :
              return MaterialPageRoute(builder: (ctx) => DetailNews(settings.arguments));
            case ROUTE_DETAIL_STORY :
              return MaterialPageRoute(builder: (ctx) => DetailStory(settings.arguments));
            case ROUTE_LOGIN_EMAIL :
              return MaterialPageRoute(builder: (ctx) => LoginEmail());
            default :
              return MaterialPageRoute(builder: (ctx) => SplashScreen());
          }
        },

        initialRoute: ROUTE_ROOT,
      ),
    );
  }
}
