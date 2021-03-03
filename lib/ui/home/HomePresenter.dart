import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/preferences/AppPreference.dart';

class HomePresenter extends BasePresenter{
  HomePresenter(BaseState state) : super(state);

  void getAccountFromAPI() async {
    var user = await AppPreference.getUser();
    var params = {"email" : user.email};
    var result = await repository.getUser(0, params);

    if(result != null){
      if(result.data.length > 0) {
        if(result.data[0].email == user.email) {
          //await AppPreference.saveUser(result.data[0]);
        }
      }
    }
  }
}