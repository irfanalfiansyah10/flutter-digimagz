import 'package:mcnmr_common_ext/NonNullChecker.dart';

class BaseResponse {
  bool status = false;
  String message = "";

  BaseResponse();

  BaseResponse.fromJson(Map<String, dynamic> json){
    status = obtainValue(json["status"], false);
    message = obtainValue(json["message"], "");
  }
}

class ResponseException implements Exception{
  final String msg;

  ResponseException({this.msg});
}