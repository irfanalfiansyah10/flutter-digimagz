import 'dart:convert';

import 'package:mcnmr_common_ext/NonNullChecker.dart';
import 'package:digimagz/network/response/BaseResponse.dart';

class UserResponse extends BaseResponse {
  List<User> data;

  UserResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    data = List();
    if(json["data"] != null){
      json["data"].forEach((it) => data.add(User.fromJson(it)));
    }
  }
}

class User{
  String email;
  String userName;
  String urlPic;
  String lastLogin;

  User();

  User.fromJson(Map<String, dynamic> json){
    email = obtainValue(json["EMAIL"], "");
    userName = obtainValue(json["USER_NAME"], "");
    urlPic = obtainValue(json["PROFILEPIC_URL"], "");
    lastLogin = obtainValue(json["LAST_LOGIN"], "");
  }

  String toJson(){
    var json = {
      "EMAIL" : email,
      "USER_NAME" : userName,
      "PROFILEPIC_URL" : urlPic,
      "LAST_LOGIN" : lastLogin
    };

    return jsonEncode(json);
  }
}