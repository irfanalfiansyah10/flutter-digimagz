import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:digimagz/ui/login_email/LoginEmailDelegate.dart';

/** Uncomment this later
 * import 'package:firebase_auth/firebase_auth.dart';
 */

class LoginEmailPresenter extends BasePresenter {
  static const REQUEST_CHECK_EMAIL_AVAILABILITY = 0;
  static const REQUEST_CREATE_USER = 1;
  static const REQUEST_LOGIN = 2;

  final LoginEmailDelegate _delegate;

  /** Uncomment this later
   * var _auth = FirebaseAuth.instance;
   */

  LoginEmailPresenter(BaseState state, this._delegate) : super(state);

  void checkEmailAvailability(String email) async {
    /** Uncomment this later
    state.shouldShowLoading(REQUEST_CHECK_EMAIL_AVAILABILITY);
    var result = await _auth.fetchSignInMethodsForEmail(email: email);
    state.shouldHideLoading(REQUEST_CHECK_EMAIL_AVAILABILITY);

    if(result.length > 0){
      if(result[0] == "google.com"){
        state.alert(title: "Email telah terdaftar",
            message: "Email telah terdaftar di google, Anda bisa login menggunakan google",
            positiveTitle: "Tutup"
        );
        return;
      }

      if(result[0] == "facebook.com"){
        state.alert(title: "Email telah terdaftar",
            message: "Email telah terdaftar di facebook, Anda bisa login menggunakan facebook",
            positiveTitle: "Tutup"
        );
        return;
      }

      if(result[0] == "password"){
        _delegate.onEmailAlreadyRegistered();
        return;
      }
    }

    _delegate.onEmailNotRegistered();*/
  }

  void login(String email, String password) async {
    /** Uncomment this later
    state.shouldShowLoading(REQUEST_LOGIN);
    var user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
    state.shouldHideLoading(REQUEST_LOGIN);

    _executeGetUser(user.email);*/
  }

  void createUser(String email, String password, String name) async {
    /** Uncomment this later
    state.shouldShowLoading(REQUEST_CREATE_USER);
    var user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;

    var updateInfo = UserUpdateInfo();
    updateInfo.displayName = name;

    await user.updateProfile(updateInfo);
    await user.reload();
    user = await _auth.currentUser();

    state.shouldHideLoading(REQUEST_CREATE_USER);

    _executePostUserToApi(user.email, user.displayName, user.photoUrl);*/
  }

  void _executePostUserToApi(String email, String name, String picUrl) async {
    var params = {
      "email" : email,
      "name" : name,
      "pic_url" : picUrl
    };

    var user = await repository.postUser(REQUEST_LOGIN, params);

    if(user != null) {
      await AppPreference.saveUser(user);
      _delegate.onSuccessLoginOrCreateUser();
      return;
    }

    state.alert(title: "Terjadi kesalahan", message: "Terjadi kesalahan yang tidak diketahui");
  }

  void _executeGetUser(String email) async {
    var params = {
      "email" : email,
    };

    var user = await repository.getUser(REQUEST_LOGIN, params);

    if(user != null){
      if(user.data.length > 0){
        await AppPreference.saveUser(user.data[0]);
        _delegate.onSuccessLoginOrCreateUser();
        return;
      }
    }

    state.alert(title: "Terjadi kesalahan", message: "Terjadi kesalahan yang tidak diketahui");
  }
}