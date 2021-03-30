import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';

class SplashScreenPresenter extends BasePresenter {
  SplashScreenPresenter(BaseState state) : super(state);

  void executeToken(String token) async {
    var params = {
      "token": token
    };

    var result = await repository.postToken(6, params);

    if (result != null) {
      print("postToken: $result");
    }
  }
}