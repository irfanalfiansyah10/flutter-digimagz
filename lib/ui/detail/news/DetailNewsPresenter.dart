import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
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
  static const REQUEST_CHECK_LIKE = 4;
  static const REQUEST_POST_VIEWS = 5;
  static const REQUEST_POST_SHARE = 6;

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

  void executeCheckLike(String idNews) async {
    var account = await AppPreference.getUser();
    var params = {
      "id_news" : idNews,
      "email" : account.email
    };

    var result = await repository.getLikes(REQUEST_CHECK_LIKE, params);
    if(result != null){
      if(result.status){
        _delegate.onAlreadyLiked();
      }
    }
  }

  void executeLike(String idNews) async {
    var account = await AppPreference.getUser();
    var params = {
      "id_news" : idNews,
      "email" : account.email
    };

    var response = await repository.postLike(REQUEST_LIKE, params);

    if(response != null){
      if(response.status){
        _delegate.onSuccessLike();
      }
    }
  }

  void executeUnlike(String idNews) async {
    var account = await AppPreference.getUser();
    Map<String, String> params = {
      "id_news" : idNews,
      "email" : account.email
    };

    var response = await repository.deleteLike(REQUEST_LIKE, params);

    if(response != null){
      if(response.status){
        _delegate.onSuccessUnlike();
      }
    }
  }

  void executeComment(String idNews, String comment) async {
    var user = await AppPreference.getUser();

    var params = {
      "id_news" : idNews,
      "email" : user.email,
      "comments" : comment
    };

    var result = await repository.postComment(REQUEST_POST_COMMENT, params);

    if(result != null){
      state.alert(title: "Terima Kasih",
        message: "Komentar Anda sedang kami moderasi",
        positiveTitle: "Tutup"
      );
    }
  }

  void executePostViews(String idNews) async {
    var user = await AppPreference.getUser();
    var params = {
      "id_news" : idNews,
      "email" : user.email
    };

    repository.postView(REQUEST_POST_VIEWS, params);
  }

  void executePostShare(String idNews) async {
    var user = await AppPreference.getUser();
    var params = {
      "id_news" : idNews,
      "email" : user.email
    };

    repository.postShare(REQUEST_POST_SHARE, params);
  }
}