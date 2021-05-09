import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/ui/login/LoginDelegate.dart';
import 'package:digimagz/ui/login/LoginPresenter.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends BaseState<Login, LoginPresenter> implements LoginDelegate{

  @override
  LoginPresenter initPresenter() => LoginPresenter(this, this);

  @override
  void onSuccessLogin() {
    navigateTo(MyApp.ROUTE_HOME, singleTop: true);
  }

  @override
  void onUnknownError(int typeRequest, String msg) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Image.asset("assets/images/logo_toolbar.png"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: (){
            finish();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/canvas.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Container(
              width: adaptiveWidth(context, 250),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Please Sign In",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: 10),
                      FlatButton(
                        color: ColorUtils.primary,
                        onPressed: () => navigateTo(MyApp.ROUTE_LOGIN_EMAIL),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.email, color: Colors.white, size: 24),
                            Expanded(
                              child: Text("Sign in with email",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        color: ColorUtils.redGoogle,
                        onPressed: (){
                          presenter.executeSignInGoogle();
                        },
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset("assets/images/ic_google.svg", width: 24, height: 24,),
                            Expanded(
                              child: Text("Sign in with google",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        color: ColorUtils.blueFacebook,
                        onPressed: (){
                          presenter.executeSignInFacebook();
                        },
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset("assets/images/ic_facebook.svg", width: 24, height: 24,),
                            Expanded(
                              child: Text("Sign in with facebook",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        color: Colors.black,
                        onPressed: (){
                          presenter.executeSignInApple();
                        },
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset("assets/images/ic_apple.svg", width: 24, height: 24,),
                            Expanded(
                              child: Text("Sign in with apple",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
