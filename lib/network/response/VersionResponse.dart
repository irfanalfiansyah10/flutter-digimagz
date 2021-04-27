import 'dart:convert';

import 'package:mcnmr_common_ext/NonNullChecker.dart';
import 'package:digimagz/network/response/BaseResponse.dart';

class VersionResponse extends BaseResponse {
  Version data;

  VersionResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    data = new Version();
    if(json["data"] != null){
      data = Version.fromJson(json["data"]);
    }
  }
}

class Version{
  String version;

  Version();

  Version.fromJson(Map<String, dynamic> json){
    version = obtainValue(json["version"], "");
  }

  String toJson(){
    var json = {
      "version" : version,
    };

    return jsonEncode(json);
  }
}