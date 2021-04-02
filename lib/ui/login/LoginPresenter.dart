import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/network/response/UserResponse.dart' as response;
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:digimagz/ui/login/LoginDelegate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPresenter extends BasePresenter{
  static const REQUEST_POST_USER = 0;
  static const REQUEST_GET_USER = 1;

  final LoginDelegate _delegate;

  LoginPresenter(BaseState state, this._delegate) : super(state);

  void executeSignInGoogle() async {
    try{
      var signIn = await GoogleSignIn().signIn();
      var auth = await signIn.authentication;

      var credential = GoogleAuthProvider.getCredential(
          idToken: auth.idToken, accessToken: auth.accessToken
      );

      var user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      _checkUser(user.email, user.displayName, user.photoUrl);
    }on Exception catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void executeSignInFacebook() async {
    try {
      var signIn = await FacebookLogin().logIn(["email"]);

      switch(signIn.status){
        case FacebookLoginStatus.loggedIn :
          Fluttertoast.showToast(msg: "Logged In");
          break;
        case FacebookLoginStatus.error :
          Fluttertoast.showToast(msg: "Error");
          Fluttertoast.showToast(msg: signIn.errorMessage);
          break;
        case FacebookLoginStatus.cancelledByUser :
          Fluttertoast.showToast(msg: "Cancelled");
          break;
      }

      var credential = FacebookAuthProvider.getCredential(accessToken: signIn.accessToken.token);

      var user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      _checkUser(user.email, user.displayName, user.photoUrl);
    }on Exception catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void _checkUser(String email, String name, String picUrl) async {
    var getUserParams = {"email" : email};
    var result = await repository.getUser(REQUEST_GET_USER, getUserParams);

    if(result != null){
      if(result.data.length > 0) {
        if(result.data[0].email == email) {
          await AppPreference.saveUser(result.data[0]);
          _delegate.onSuccessLogin();
          return;
        }
      }
    }

    var postUserParams = {
      "email" : email,
      "name" : name,
      "pic_url" : picUrl
    };

    await repository.postUser(REQUEST_POST_USER, postUserParams);
    var newUser = response.User()
      ..email = email
      ..userName = name
      ..urlPic = picUrl;

    await AppPreference.saveUser(newUser);
    _delegate.onSuccessLogin();
  }
}