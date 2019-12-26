import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/network/response/UserResponse.dart';
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:digimagz/ui/home/fragment/emagz/EmagzFragment.dart';
import 'package:digimagz/ui/home/fragment/home/HomeFragment.dart';
import 'package:digimagz/ui/home/fragment/profile/ProfileFragment.dart';
import 'package:digimagz/ui/home/fragment/search/SearchFragment.dart';
import 'package:digimagz/ui/home/fragment/video/VideoFragment.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends BaseState<Home> {

  var _content = [
    HomeFragment(),
    VideoFragment(),
    SearchFragment(),
    EmagzFragment(),
    ProfileFragment(),
  ];

  User _user;

  int _currentPosition = 0;

  @override
  void afterWidgetBuilt() async {
    _user = await AppPreference.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Center(
          child: Image.asset("assets/images/logo_toolbar.png"),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          children: _content,
          index: _currentPosition,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), title: Text("Video")),
          BottomNavigationBarItem(icon: Icon(Icons.search), title: Text("Search")),
          BottomNavigationBarItem(icon: Icon(Icons.book), title: Text("Emagz")),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), title: Text("Login")),
        ],
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        currentIndex: _currentPosition,
        backgroundColor: Colors.white,
        selectedItemColor: ColorUtils.primary,
        onTap: _onBottomBarTapped,
      ),
    );
  }

  void _onBottomBarTapped(int newPosition) async {

    if(newPosition == 1){
      (_content[newPosition] as VideoFragment).visit();
    }else if(newPosition == 2){
      (_content[newPosition] as SearchFragment).visit();
    }else if(newPosition == 4){
      if(_user == null){
        navigateTo(MyApp.ROUTE_LOGIN);
        return;
      }
    }

    setState(() {
      _currentPosition = newPosition;
    });
  }
}

