import 'dart:io';

import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:dio/dio.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:digimagz/network/response/UserResponse.dart';
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:digimagz/ui/home/fragment/profile/ProfileFragmentDelegate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileFragmentPresenter extends BasePresenter{
  static const REQUEST_LOGOUT = 1;
  static const REQUEST_GET_USER = 2;
  static const CHANGE_AVATAR = 3;

  final ProfileFragmentDelegate _delegate;

  ProfileFragmentPresenter(BaseState state, this._delegate) : super(state);

  void getAccount(RequestWrapper<User> userWrapper) async {
    userWrapper.doRequestKeepState();
    userWrapper.finishRequestIfNotNull(await AppPreference.getUser());
  }

  void getAccountFromAPI(RequestWrapper<User> userWrapper) async {
    userWrapper.doRequestKeepState();
    var user = await AppPreference.getUser();
    var params = {"email" : user.email};
    var result = await repository.getUser(REQUEST_GET_USER, params);

    if(result != null){
      if(result.data.length > 0) {
        if(result.data[0].email == user.email) {
          await AppPreference.saveUser(result.data[0]);
          userWrapper.finishRequest(result.data[0]);
        }
      }
    }
  }

  void executeChangeAvatar(File avatar) async {
    var user = await AppPreference.getUser();
    var params = {
      "email" : user.email,
      "picture" : MultipartFile.fromFileSync(avatar.path, filename: avatar.path.split("/").last)
    };

    var result = await repository.changeAvatar(CHANGE_AVATAR, params);
    if(result != null){
      _delegate.onSuccessChangeAvatar(result);
    }
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