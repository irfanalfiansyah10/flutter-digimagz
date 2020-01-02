import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:intl/intl.dart';
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

  void executeComment(String idNews, String comment, RequestWrapper<CommentResponse> wrapper) async {
    wrapper.doRequestKeepState();
    var user = await AppPreference.getUser();

    var params = {
      "id_news" : idNews,
      "email" : user.email,
      "comments" : comment
    };

    var result = repository.postComment(REQUEST_POST_COMMENT, params);

    if(result != null){
      var newCommentList = <Comment>[];
      var newComment = Comment();
      newComment.idNews = idNews;
      newComment.email = user.email;
      newComment.commentText = comment;
      newComment.dateComment = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
      newComment.userName = user.userName;
      newComment.profilepicUrl = user.urlPic;

      newCommentList.add(newComment);
      newCommentList.addAll(wrapper.result.data);
      var newCommentResponse = CommentResponse();
      newCommentResponse.data = newCommentList;

      _delegate.onSuccessPostComment();
      wrapper.finishRequest(newCommentResponse);
    }
  }
}