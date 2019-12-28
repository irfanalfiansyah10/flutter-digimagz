import 'dart:collection';

import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:flutter/cupertino.dart';

class LikeProvider extends ChangeNotifier{
  HashMap<String, int> totalLikeMap = HashMap();
  List<String> likedNews = List();

  void collect(NewsResponse response){
    response.data.forEach((it){
      if(!totalLikeMap.containsKey(it.idNews)){
        totalLikeMap[it.idNews] = int.parse(it.likes);
      }
    });

    notifyListeners();
  }

  void alreadyLiked(News news){
    if(!likedNews.contains(news.idNews)){
      likedNews.add(news.idNews);
    }

    notifyListeners();
  }

  void addLike(News news){
    if(!totalLikeMap.containsKey(news.idNews)) return;

    totalLikeMap[news.idNews]++;
    likedNews.add(news.idNews);
    notifyListeners();
  }

  void removeLike(News news){
    if(!totalLikeMap.containsKey(news.idNews)) return;

    totalLikeMap[news.idNews]--;
    likedNews.remove(news.idNews);
    notifyListeners();
  }

  String getNumberOfLike(News news){
    if(totalLikeMap.containsKey(news.idNews)){
      return totalLikeMap[news.idNews].toString();
    }

    return "0";
  }

  void clear(){
    totalLikeMap.clear();
    likedNews.clear();

    notifyListeners();
  }
}