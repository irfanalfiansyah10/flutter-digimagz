import 'package:mcnmr_common_ext/NonNullChecker.dart';
import 'package:digimagz/network/response/BaseResponse.dart';

class LikeResponse extends BaseResponse{
  List<Like> data;

  LikeResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    if(json["data"] != null){
      json["data"].forEach((it) => data.add(Like.fromJson(it)));
    }
  }
}

class Like {
  String idNews;
  String email;

  Like.fromJson(Map<String, dynamic> json){
    idNews = obtainValue(json["ID_NEWS"], "");
    email = obtainValue(json["EMAIL"], "");
  }
}