import 'package:mcnmr_common_ext/NonNullChecker.dart';

class YoutubeResponse {
  bool status;
  List<YoutubeVideo> data;

  YoutubeResponse.fromJson(Map<String, dynamic> json){
    status = obtainValue(json["status"], false);

    data = List();

    if(json["data"] != null){
      json["data"].forEach((v) => data.add(YoutubeVideo.fromJson(v)));
    }
  }
}

class YoutubeVideo{
  String idVideo;
  String title;
  String description;
  String datePublished;
  String urlDefaultThumbnail;
  String urlMediumThumbnail;
  String urlLargeThumbnail;
  String statusPublished;

  YoutubeVideo.fromJson(Map<String, dynamic> json){
    idVideo = obtainValue(json["ID_VIDEO"], "");
    title = obtainValue(json["TITLE"], "");
    description = obtainValue(json["DESCRIPTION"], "");
    datePublished = obtainValue(json["DATE_PUBLISHED"], "");
    urlDefaultThumbnail = obtainValue(json["URL_DEFAULT_THUMBNAIL"], "");
    urlMediumThumbnail = obtainValue(json["URL_MEDIUM_THUMBNAIL"], "");
    urlLargeThumbnail = obtainValue(json["URL_HIGH_THUMBNAIL"], "");
    statusPublished = obtainValue(json["STATUS_PUBLISHED"], "");
  }
}