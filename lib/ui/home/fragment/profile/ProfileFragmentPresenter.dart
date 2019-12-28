import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:digimagz/network/response/UserResponse.dart';
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:digimagz/ui/home/fragment/profile/ProfileFragmentDelegate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileFragmentPresenter extends BasePresenter{
  static const REQUEST_LOGOUT = 1;

  final ProfileFragmentDelegate _delegate;

  ProfileFragmentPresenter(BaseState state, this._delegate) : super(state);

  void getAccount(RequestWrapper<User> userWrapper) async {
    userWrapper.doRequestKeepState();
    userWrapper.finishRequestIfNotNull(await AppPreference.getUser());
  }

  void logout() async {
    state.shouldShowLoading(REQUEST_LOGOUT);

    await GoogleSignIn().disconnect();
    await FacebookLogin().logOut();
    await FirebaseAuth.instance.signOut();
    await AppPreference.removeUser();

    state.shouldHideLoading(REQUEST_LOGOUT);

    _delegate.onSuccessLogout();
  }
}