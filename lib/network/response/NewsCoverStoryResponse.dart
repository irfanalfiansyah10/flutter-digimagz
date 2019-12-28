import 'package:mcnmr_common_ext/NonNullChecker.dart';
import 'package:digimagz/network/response/BaseResponse.dart';

class NewsCoverStoryResponse extends BaseResponse {
  List<NewsCoverStory> data;

  NewsCoverStoryResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    data = List();

    if(json["data"] != null){
      json["data"].forEach((it) => data.add(NewsCoverStory.fromJson(it)));
    }
  }
}

class NewsCoverStory {
  String idNews;
  String nameCategory;
  String contentNews;
  String titleNews;
  String dateNews;
  List<String> newsImage;
  String viewsCount;
  String likes;
  String comments;
  String sharesCount;
  String idCoverStory;
  String titleCoverStory;

  NewsCoverStory.fromJson(Map<String, dynamic> json){
    idNews = obtainValue(json["ID_NEWS"], "");
    nameCategory = obtainValue(json["NAME_CATEGORY"], "");
    contentNews = obtainValue(json["CONTENT_NEWS"], "");
    titleNews = obtainValue(json["TITLE_NEWS"], "");
    dateNews = obtainValue(json["DATE_NEWS"], "");
    viewsCount = obtainValue(json["VIEWS_COUNT"], "");
    likes = obtainValue(json["LIKES"], "");
    comments = obtainValue(json["COMMENTS"], "");
    sharesCount = obtainValue(json["SHARES_COUNT"], "");
    idCoverStory = obtainValue(json["ID_COVERSTORY"], "");
    titleCoverStory = obtainValue(json["TITLE_COVERSTORY"], "");

    newsImage = List();
    if(json["NEWS_IMAGE"] != null){
      json["NEWS_IMAGE"].forEach((it) => newsImage.add(it));
    }
  }
}