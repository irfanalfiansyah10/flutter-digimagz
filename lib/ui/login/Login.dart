import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/ui/login/LoginDelegate.dart';
import 'package:digimagz/ui/login/LoginPresenter.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends BaseState<Login> implements LoginDelegate{
  LoginPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = LoginPresenter(this, this);
  }

  @override
  void onSuccessLogin() {
    Fluttertoast.showToast(msg: "Success Login");
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
          icon: Icon(Icons.arrow_back),
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
              )
          ),
          child: Center(
            child: Container(
              width: adaptiveWidth(context, 250),
              height: adaptiveWidth(context, 200),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
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
                        color: ColorUtils.redGoogle,
                        onPressed: (){
                          _presenter.executeSignInGoogle();
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
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        color: ColorUtils.blueFacebook,
                        onPressed: (){
                          _presenter.executeSignInFacebook();
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
                                    fontWeight: FontWeight.w500
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
