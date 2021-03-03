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
  String email = "-";
  String userName = "-";
  String urlPic = "-";
  String lastLogin = "-";
  String dateBirth = "-";
  String gender = "-";
  String userType = "-";

  User();

  User.fromJson(Map<String, dynamic> json){
    email = obtainValue(json["EMAIL"], "-");
    userName = obtainValue(json["USER_NAME"], "-");
    urlPic = obtainValue(json["PROFILEPIC_URL"], "");
    lastLogin = obtainValue(json["LAST_LOGIN"], "");
    dateBirth = obtainValue(json["DATE_BIRTH"], "-");
    gender = obtainValue(json["GENDER"], "-");
    userType = obtainValue(json["USER_TYPE"], "-");
  }

  String toJson(){
    var json = {
      "EMAIL" : email,
      "USER_NAME" : userName,
      "PROFILEPIC_URL" : urlPic,
      "LAST_LOGIN" : lastLogin,
      "DATE_BIRTH" : dateBirth,
      "GENDER" : gender,
      "USER_TYPE" : userType
    };

    return jsonEncode(json);
  }
}