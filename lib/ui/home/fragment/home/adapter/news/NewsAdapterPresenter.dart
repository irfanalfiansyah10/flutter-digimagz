import 'dart:convert';

import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_common_ext/NonNullChecker.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';

class NewsAdapterPresenter extends BasePresenter{
  static const REQUEST_CHECK_LIKE = 0;

  NewsAdapterPresenter(BaseState<BaseStatefulWidget> state) : super(state);

  void executeCheckLike(RequestWrapper<bool> wrapper, String email, String idNews) async {
    wrapper.doRequestKeepState();

    var params = {
      "id_news" : idNews,
      "email" : email
    };

    var result = await repository.getLikes(REQUEST_CHECK_LIKE, params);
    if(result != null){
      var json = jsonDecode(result);

      var isLiked = obtainValue(json["data"], "") == "Yes";

      wrapper.finishRequest(isLiked);
    }
  }
}