import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/ui/list/news/ListNews.dart';

class ListNewsPresenter extends BasePresenter{
  static const REQUEST_GET_NEWS = 0;

  ListNewsPresenter(BaseState state) : super(state);

  void executeGetNews(ListNewsArgument argument, RequestWrapper<NewsResponse> wrapper) async {
    if(argument.isFavorit){
      wrapper.doRequest();
      var params = {
        "trending" : "yes"
      };
      wrapper.finishRequestIfNotNull(await repository.getNewsTrending(REQUEST_GET_NEWS, params));
    }else {
      wrapper.doRequest();
      var params = {
        "q" : argument.query
      };
      wrapper.finishRequestIfNotNull(await repository.getNewsSearch(REQUEST_GET_NEWS, params));
    }
  }
}
