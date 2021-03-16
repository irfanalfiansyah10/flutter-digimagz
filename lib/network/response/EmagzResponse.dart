import 'package:digimagz/network/response/BaseResponse.dart';
import 'package:mcnmr_common_ext/NonNullChecker.dart';

class EmagzResponse extends BaseResponse{
  List<EmagzData> data;

  EmagzResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    data = List();
    if(json["data"] != null){
      json["data"].forEach((it) => data.add(EmagzData.fromJson(it)));
    }
  }
}

class EmagzData{
  String idEmagz;
  String thumbnail;
  String file;
  String dateUploaded;
  String name;
  String linkPubHtml5;
  String linkQuiz;
  String isPubActive;

  EmagzData.fromJson(Map<String, dynamic> json){
    idEmagz = obtainValue(json["ID_EMAGZ"], "");
    thumbnail = obtainValue(json["THUMBNAIL"], "");
    file = obtainValue(json["FILE"], "");
    dateUploaded = obtainValue(json["DATE_UPLOADED"], "");
    name = obtainValue(json["NAME"], "");
    linkPubHtml5 = obtainValue(json["LINK_PUBHTML5"], "");
    linkQuiz = obtainValue(json["LINK_QUIZ"], "");
    isPubActive = obtainValue(json["IS_PUBACTIVE"], "");
  }
}