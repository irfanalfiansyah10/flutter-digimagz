import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:digimagz/ui/fill_personal_data/FillPersonalDataDelegate.dart';

class FillPersonalDataPresenter extends BasePresenter {
  static const REQUEST_UPDATE_PROFILE = 0;

  final FillPersonalDataDelegate _delegate;

  FillPersonalDataPresenter(BaseState state, this._delegate) : super(state);

  void executeUpdateProfile(String birthDate, String gender) async {
    var user = await AppPreference.getUser();

    var params = {
      "email" : user.email,
      "name" : user.userName,
      "pic_url" : user.urlPic,
      "date_birth" : birthDate,
      "gender" : gender
    };

    var result = await repository.putUser(REQUEST_UPDATE_PROFILE, params);

    if(result != null){
      user.dateBirth = birthDate;
      user.gender = gender;
      await AppPreference.saveUser(user);
      _delegate.onSuccessChangePersonalData();
    }
  }
}