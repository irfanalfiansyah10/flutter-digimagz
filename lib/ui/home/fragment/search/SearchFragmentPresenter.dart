import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/ui/home/fragment/search/SearchFragmentDelegate.dart';
import 'package:dio/dio.dart';

class SearchFragmentPresenter extends BasePresenter {
  static const REQUEST_GET_NEWS = 0;

  final SearchFragmentDelegate _delegate;

  CancelToken _newsToken;

  SearchFragmentPresenter(BaseState<BaseStatefulWidget> state, this._delegate) : super(state);

  void executeGetNews(RequestWrapper<NewsResponse> wrapper) async {
    wrapper.doRequestKeepState();

    if(_newsToken != null){
      _newsToken.cancel();
    }

    _newsToken = CancelToken();

    wrapper.finishRequestIfNotNull(await repository.getNews(REQUEST_GET_NEWS, cancelToken: _newsToken));
  }
}