import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/network/response/UserResponse.dart';
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';

class NewsAdapterPresenter extends BasePresenter{
  static const REQUEST_CHECK_LIKE = 0;

  User user;

  NewsAdapterPresenter(BaseState state) : super(state);

  void executeCheckLike(RequestWrapper<bool> wrapper, String idNews) async {
    user = await AppPreference.getUser();
    if(user == null) return;

    wrapper.doRequestKeepState();

    var params = {
      "id_news" : idNews,
      "email" : user.email
    };

    var result = await repository.getLikes(REQUEST_CHECK_LIKE, params);
    if(result != null){
      wrapper.finishRequest(result.status);
    }
  }
}