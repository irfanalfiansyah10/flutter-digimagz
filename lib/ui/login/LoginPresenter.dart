import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/network/response/UserResponse.dart';
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:digimagz/ui/login/LoginDelegate.dart';
import 'package:fluttertoast/fluttertoast.dart';
/**
 * Uncomment this later
 * import 'package:firebase_auth/firebase_auth.dart';
 * import 'package:flutter_facebook_login/flutter_facebook_login.dart';
 * import 'package:google_sign_in/google_sign_in.dart';
 */

class LoginPresenter extends BasePresenter{
  static const REQUEST_LOGIN = 0;

  final LoginDelegate _delegate;

  LoginPresenter(BaseState state, this._delegate) : super(state);


  void executeSignInGoogle() async {
    /** Uncomment this later
    try{
      var signIn = await GoogleSignIn().signIn();
      var auth = await signIn.authentication;

      var credential = GoogleAuthProvider.getCredential(
          idToken: auth.idToken, accessToken: auth.accessToken
      );

      var user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      _executePostUserToApi(user.email, user.displayName, user.photoUrl);
    }on Exception catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }*/
  }

  void executeSignInFacebook() async {
    /** Uncomment this later
    try {
      var signIn = await FacebookLogin().logIn(["email"]);

      switch(signIn.status){
        case FacebookLoginStatus.loggedIn :
          Fluttertoast.showToast(msg: "Logged In");
          break;
        case FacebookLoginStatus.error :
          Fluttertoast.showToast(msg: "Error");
          Fluttertoast.showToast(msg: signIn.errorMessage, timeInSecForIos: 10);
          break;
        case FacebookLoginStatus.cancelledByUser :
          Fluttertoast.showToast(msg: "Cancelled");
          break;
      }

      var credential = FacebookAuthProvider.getCredential(accessToken: signIn.accessToken.token);

      var user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      _executePostUserToApi(user.email, user.displayName, user.photoUrl);
    }on Exception catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }*/
  }

  void _executePostUserToApi(String email, String name, String picUrl) async {
    var params = {
      "email" : email,
      "name" : name,
      "pic_url" : picUrl
    };

    var user = await repository.postUser(REQUEST_LOGIN, params);

    if(user == null){
      var alreadySavedUser = User();
      alreadySavedUser.email = email;
      alreadySavedUser.userName = name;
      alreadySavedUser.urlPic = picUrl;

      await AppPreference.saveUser(alreadySavedUser);
      _delegate.onSuccessLogin();
    }else {
      await AppPreference.saveUser(user);
      _delegate.onSuccessLogin();
    }
  }
}