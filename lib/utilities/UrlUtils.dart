import 'package:digimagz/network/response/NewsResponse.dart';

class UrlUtils{
  static const String URL_IMAGE_NEWS = "http://digimon.kristomoyo.com/images/news/";
  static const String URL_IMAGE_STORY = "http://digimon.kristomoyo.com/images/coverstory/";
  static const String URL_IMAGE_GALLERY = "http://digimon.kristomoyo.com/images/gallery/";
  static const String URL_IMAGE_EMAGZ = "http://digimon.kristomoyo.com/emagazine/thumbnail/";
  static const String URL = "http://digimon.kristomoyo.com/";

  static String getUrlForImage(News news){
    if(news.nameCategory.toLowerCase() == "berita"){
      return URL_IMAGE_NEWS+news.newsImage[0];
    }else if(news.nameCategory.toLowerCase() == "artikel"){
      return URL_IMAGE_NEWS+news.newsImage[0];
    }else {
      return URL_IMAGE_GALLERY+news.idNews+"/"+news.newsImage[0];
    }
  }
}