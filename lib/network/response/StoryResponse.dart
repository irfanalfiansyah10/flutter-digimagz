import 'package:digimagz/network/response/BaseResponse.dart';
import 'package:mcnmr_common_ext/NonNullChecker.dart';

class StoryResponse extends BaseResponse{
  List<Story> data;

  StoryResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    data = List();
    if(json["data"] != null){
      json["data"].forEach((it) => data.add(Story.fromJson(it)));
    }
  }

}

class Story {
  String idCoverStory;
  String titleCoverStory;
  String summary;
  String summaryIos;
  String imageCoverStory;
  String dateCoverStory;

  Story.fromJson(Map<String, dynamic> json){
    idCoverStory = obtainValue(json["ID_COVERSTORY"], "");
    titleCoverStory = obtainValue(json["TITLE_COVERSTORY"], "");
    summary = obtainValue(json["SUMMARY"], "");
    summaryIos = obtainValue(json["SUMMARY_IOS"], "");
    imageCoverStory = obtainValue(json["IMAGE_COVERSTORY"], "");
    dateCoverStory = obtainValue(json["DATE_COVERSTORY"], "");
  }
}