import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/ui/detail/story/DetailStoryDelegate.dart';

class DetailStoryPresenter extends BasePresenter{
  static const REQUEST_GET_RELATED_NEWS = 0;

  final DetailStoryDelegate _delegate;

  DetailStoryPresenter(BaseState<BaseStatefulWidget> state, this._delegate) : super(state);

  void executeGetRelatedNews(String idStory, RequestWrapper<NewsResponse> wrapper) async {
    wrapper.doRequest();

    var params = {
      "id" : idStory
    };

    var result = await repository.getNewsFromStory(REQUEST_GET_RELATED_NEWS, params);

    if(result != null){
      wrapper.finishRequest(NewsResponse.fromNewsCoverStory(result));
    }

  }

  void executeGetRelatedNewsAsString(String idStory, RequestWrapper<String> wrapper) async {
    wrapper.doRequest();

    var params = {
      "id" : idStory
    };

    var result = await repository.getNewsFromStoryAsString(REQUEST_GET_RELATED_NEWS, params);

    if(result != null){
      wrapper.finishRequest(result);
      return;
    }
  }
}