import 'dart:convert';

import 'package:digimagz/network/response/UserResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static const PREF_USER = "PREF_USER";

  static SharedPreferences _instance;

  static Future<User> getUser() async {
    if(_instance == null){
      _instance = await SharedPreferences.getInstance();
    }

    if(_instance.containsKey(PREF_USER)){
      return User.fromJson(jsonDecode(_instance.getString(PREF_USER)));
    }

    return null;
  }

  static Future<bool> saveUser(User user) async {
    if(_instance == null){
      _instance = await SharedPreferences.getInstance();
    }

    return _instance.setString(PREF_USER, user.toJson());
  }

  static Future<bool> removeUser() async {
    if(_instance == null){
      _instance = await SharedPreferences.getInstance();
    }

    return _instance.remove(PREF_USER);
  }
}