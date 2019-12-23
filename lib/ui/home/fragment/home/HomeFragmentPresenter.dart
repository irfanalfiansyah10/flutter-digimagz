import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/network/response/StoryResponse.dart';
import 'package:digimagz/ui/home/fragment/home/HomeFragmentDelegate.dart';
import 'package:dio/dio.dart';

class HomeFragmentPresenter extends BasePresenter{
  static const REQUEST_GET_NEWS_TREND = 0;
  static const REQUEST_GET_SLIDER = 1;
  static const REQUEST_GET_STORY = 2;
  static const REQUEST_GET_NEWS = 3;

  final HomeFragmentDelegate _delegate;

  CancelToken _trendingToken;
  CancelToken _newsToken;

  HomeFragmentPresenter(BaseState<BaseStatefulWidget> state, this._delegate) : super(state);

  void executeGetSlider(RequestWrapper<NewsResponse> wrapper) async {
    wrapper.doRequest();
    wrapper.finishRequestIfNotNull(await repository.getSlider(REQUEST_GET_SLIDER));
  }

  void executeGetNewsTrending(RequestWrapper<NewsResponse> wrapper) async {
    wrapper.doRequestKeepState();

    var params = {
      "trend" : "yes"
    };

    if(_trendingToken != null){
      _trendingToken.cancel();
    }

    _trendingToken = CancelToken();

    wrapper.finishRequestIfNotNull(await repository
        .getNewsTrending(REQUEST_GET_NEWS_TREND, params, cancelToken: _trendingToken));
  }

  void executeGetStory(RequestWrapper<StoryResponse> wrapper) async {
    wrapper.doRequest();
    wrapper.finishRequestIfNotNull(await repository.getStory(REQUEST_GET_SLIDER));
  }

  void executeGetNews(RequestWrapper<NewsResponse> wrapper) async {
    wrapper.doRequestKeepState();

    if(_newsToken != null){
      _newsToken.cancel();
    }

    _newsToken = CancelToken();

    wrapper.finishRequestIfNotNull(await repository.getNews(REQUEST_GET_NEWS, cancelToken: _newsToken));
  }
}