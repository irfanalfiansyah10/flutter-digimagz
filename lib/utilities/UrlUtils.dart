import 'package:digimagz/network/response/NewsResponse.dart';

class UrlUtils{
  static const String URL_IMAGE_NEWS = URL+"images/news/";
  static const String URL_IMAGE_STORY = URL+"images/coverstory/";
  static const String URL_IMAGE_GALLERY = URL+"images/gallery/";
  static const String URL_IMAGE_EMAGZ = URL+"emagazine/thumbnail/";
  static const String URL_FILES_EMAGZ = URL+"emagazine/files/";
  static const String URL = "http://digimon.kristomoyo.com/";

  static String getUrlForImage(News news, int position){
    if(news.nameCategory.toLowerCase() == "berita"){
      return URL_IMAGE_NEWS+news.newsImage[position];
    }else if(news.nameCategory.toLowerCase() == "artikel"){
      return URL_IMAGE_NEWS+news.newsImage[position];
    }else {
      return URL_IMAGE_GALLERY+news.idNews+"/"+news.newsImage[position];
    }
  }
}