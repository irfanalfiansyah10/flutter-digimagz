import 'package:mcnmr_common_ext/NonNullChecker.dart';

class TokenResponse {
  int status = 0;
  String message = "";

  TokenResponse();

  TokenResponse.fromJson(Map<String, dynamic> json){
    status = obtainValue(json["value"], 0);
    message = obtainValue(json["message"], "");
  }
}

class ResponseException implements Exception{
  final String msg;

  ResponseException({this.msg});
}