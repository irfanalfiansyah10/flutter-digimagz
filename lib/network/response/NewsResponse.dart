import 'package:digimagz/network/response/BaseResponse.dart';
import 'package:mcnmr_common_ext/NonNullChecker.dart';
import 'package:digimagz/network/response/NewsCoverStoryResponse.dart';

class NewsResponse extends BaseResponse{
  List<News> data;

  NewsResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    data = List();
    if(json["data"] != null){
      json["data"].forEach((it) => data.add(News.fromJson(it)));
    }
  }

  NewsResponse.fromNewsCoverStory(NewsCoverStoryResponse response){
    status = response.status;

    data = List();

    for(final i in response.data){
      News news = News();
      news.idNews = i.idNews;
      news.nameCategory = i.nameCategory;
      news.titleNews = i.titleNews;
      news.contentNews = i.contentNews;
      news.contentNewsIos = i.contentNewsIos;
      news.viewsCount = i.viewsCount;
      news.sharesCount = i.sharesCount;
      news.dateNews = i.dateNews;
      news.likes = i.likes;
      news.comments = i.comments;
      news.newsImage = i.newsImage;
      news.editor = i.editor;
      news.verificator = i.verificator;
      news.status = i.status;

      data.add(news);
    }
  }
}

class News {
  String idNews;
  String nameCategory;
  String titleNews;
  String contentNews;
  String contentNewsIos;
  String viewsCount;
  String sharesCount;
  String dateNews;
  List<String> newsImage;
  String likes;
  String comments;
  String editor;
  String verificator;
  String status;

  News();

  News.fromJson(Map<String, dynamic> json){
    idNews = obtainValue(json["ID_NEWS"], "");
    nameCategory = obtainValue(json["NAME_CATEGORY"], "");
    titleNews = obtainValue(json["TITLE_NEWS"], "");
    contentNews = obtainValue(json["CONTENT_NEWS"], "");
    contentNewsIos = obtainValue(json["CONTENT_NEWS_IOS"], "");
    viewsCount = obtainValue(json["VIEWS_COUNT"], "");
    sharesCount = obtainValue(json["SHARES_COUNT"], "");
    dateNews = obtainValue(json["DATE_NEWS"], "");
    likes = obtainValue(json["LIKES"], "0");
    comments = obtainValue(json["COMMENTS"], "");
    editor = obtainValue(json["EDITOR"], "");
    verificator = obtainValue(json["VERIFICATOR"], "");
    status = obtainValue(json["STATUS"], "");

    newsImage = List();

    if(json["NEWS_IMAGE"] != null){
      json["NEWS_IMAGE"].forEach((it){
        if(it == null){
          newsImage.add("");
        }else {
          newsImage.add(it);
        }
      });
    }
  }
}