import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:dio/dio.dart';

class SearchFragmentPresenter extends BasePresenter {
  static const REQUEST_GET_NEWS = 0;

  CancelToken _newsToken;

  SearchFragmentPresenter(BaseState state) : super(state);

  void executeGetNews(RequestWrapper<NewsResponse> wrapper) async {
    wrapper.doRequestKeepState();

    if(_newsToken != null){
      _newsToken.cancel();
    }

    _newsToken = CancelToken();

    wrapper.finishRequestIfNotNull(await repository.getNews(REQUEST_GET_NEWS, cancelToken: _newsToken));
  }
}