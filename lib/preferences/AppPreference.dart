import 'dart:convert';

import 'package:digimagz/network/response/UserResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static const PREF_USER = "PREF_USER";

  static SharedPreferences _instance;

  static Future<void> _init() async {
    if(_instance == null){
      _instance = await SharedPreferences.getInstance();
    }
  }

  static Future<User> getUser() async {
    await _init();

    if(_instance.containsKey(PREF_USER)){
      return User.fromJson(jsonDecode(_instance.getString(PREF_USER)));
    }

    return null;
  }

  static Future<bool> saveUser(User user) async {
    await _init();

    return _instance.setString(PREF_USER, user.toJson());
  }

  static Future<bool> removeUser() async {
    await _init();

    return _instance.remove(PREF_USER);
  }
}