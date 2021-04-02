import 'package:digimagz/provider/DownloadEbookProvider.dart';
import 'package:digimagz/provider/LikeProvider.dart';
import 'package:digimagz/ui/detail/news/DetailNews.dart';
import 'package:digimagz/ui/detail/story/DetailStory.dart';
import 'package:digimagz/ui/fill_personal_data/FillPersonalData.dart';
import 'package:digimagz/ui/home/Home.dart';
import 'package:digimagz/ui/list/news/ListNews.dart';
import 'package:digimagz/ui/login/Login.dart';
import 'package:digimagz/ui/login_email/LoginEmail.dart';
import 'package:digimagz/ui/splash_screen/SplashScreen.dart';
import 'package:digimagz/ui/webview/WebView.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'extension/LocalNotification.dart';

//export PATH="$PATH:/Users/apple/Documents/flutter/bin"

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const ROUTE_ROOT = "/";
  static const ROUTE_HOME = "/home";
  static const ROUTE_LIST_NEWS = "/listNews";
  static const ROUTE_LOGIN = "/login";
  static const ROUTE_DETAIL_NEWS = "/detailNews";
  static const ROUTE_DETAIL_STORY = "/detailStory";
  static const ROUTE_LOGIN_EMAIL = "/loginEmail";
  static const ROUTE_FILL_PERSONAL_DATA = "/fillPersonalData";
  static const ROUTE_WEBVIEW = "/webview";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DownloadEbookProvider>(create: (_) => DownloadEbookProvider()),
        ChangeNotifierProvider<LikeProvider>(create: (_) => LikeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ColorUtils.primary,
          primaryColorDark: ColorUtils.primaryDark,
          primaryColorLight: Colors.white,
          accentColor: ColorUtils.primary
        ),
        onGenerateRoute: (settings){
          switch(settings.name){
            case ROUTE_ROOT :
              return CupertinoPageRoute(builder: (ctx) => SplashScreen());
            case ROUTE_HOME :
              return CupertinoPageRoute(builder: (ctx) => Home());
            case ROUTE_LIST_NEWS :
              return CupertinoPageRoute(builder: (ctx) => ListNews(settings.arguments));
            case ROUTE_LOGIN :
              return CupertinoPageRoute(builder: (ctx) => Login());
            case ROUTE_DETAIL_NEWS :
              return CupertinoPageRoute(builder: (ctx) => DetailNews(settings.arguments));
            case ROUTE_DETAIL_STORY :
              return CupertinoPageRoute(builder: (ctx) => DetailStory(settings.arguments));
            case ROUTE_LOGIN_EMAIL :
              return CupertinoPageRoute(builder: (ctx) => LoginEmail());
            case ROUTE_FILL_PERSONAL_DATA :
              return CupertinoPageRoute(builder: (ctx) => FillPersonalData());
            case ROUTE_WEBVIEW :
              return CupertinoPageRoute(builder: (ctx) => WebView(settings.arguments));
            default :
              return CupertinoPageRoute(builder: (ctx) => SplashScreen());
          }
        },

        initialRoute: ROUTE_ROOT,
      ),
    );
  }
}
