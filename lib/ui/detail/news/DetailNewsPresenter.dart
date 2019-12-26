import 'dart:convert';

import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_common_ext/NonNullChecker.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:digimagz/network/response/CommentResponse.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:digimagz/ui/detail/news/DetailNewsDelegate.dart';

class DetailNewsPresenter extends BasePresenter{
  static const REQUEST_GET_RELATED_NEWS = 0;
  static const REQUEST_GET_COMMENT = 1;
  static const REQUEST_LIKE = 2;
  static const REQUEST_POST_COMMENT = 3;

  final DetailNewsDelegate _delegate;

  DetailNewsPresenter(BaseState state, this._delegate) : super(state);

  void executeGetRelatedNews(String idNews, RequestWrapper<NewsResponse> wrapper) async {
    wrapper.doRequest();

    var params = {
      "id" : idNews
    };

    wrapper.finishRequestIfNotNull(await repository.getNewsRelated(REQUEST_GET_RELATED_NEWS, params));
  }

  void executeGetComment(String idNews, RequestWrapper<CommentResponse> wrapper) async {
    wrapper.doRequest();

    var params = {
      "id_news" : idNews
    };

    wrapper.finishRequestIfNotNull(await repository.getComment(REQUEST_GET_COMMENT, params));
  }

  void executeCheckLike(String idNews, RequestWrapper<bool> wrapper) async {
    wrapper.doRequestKeepState();

    var account = await AppPreference.getUser();
    var params = {
      "id_news" : idNews,
      "email" : account.email
    };

    var result = await repository.getLikes(REQUEST_LIKE, params);
    if(result != null){
      var json = jsonDecode(result);

      var isLiked = obtainValue(json["data"], "") == "Yes";

      wrapper.finishRequest(isLiked);
    }
  }

  void executeLike(String idNews, RequestWrapper<bool> wrapper) async {
    wrapper.doRequest();

    var account = await AppPreference.getUser();
    var params = {
      "id_news" : idNews,
      "email" : account.email
    };

    var response = await repository.postLike(REQUEST_LIKE, params);

    if(response != null){
      wrapper.finishRequest(true);

      _delegate.onSuccessLike();
    }else {
      wrapper.finishRequest(false);
    }
  }

  void executeUnlike(String idNews, RequestWrapper<bool> wrapper) async {
    wrapper.doRequest();

    var account = await AppPreference.getUser();
    Map<String, String> params = {
      "id_news" : idNews,
      "email" : account.email
    };

    var response = await repository.deleteLike(REQUEST_LIKE, params);

    if(response != null){
      wrapper.finishRequest(false);

      _delegate.onSuccessDislike();
    }else {
      wrapper.finishRequest(true);
    }
  }

  void executeComment(String idNews, String comment) async {
    var user = await AppPreference.getUser();

    var params = {
      "id_news" : idNews,
      "email" : user.email,
      "comments" : comment
    };

    var result = repository.postComment(REQUEST_POST_COMMENT, params);

    if(result != null){
      _delegate.onSuccessPostComment();
    }
  }
}