import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/custom/view/text/StyledText.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/ui/login_email/LoginEmailDelegate.dart';
import 'package:digimagz/ui/login_email/LoginEmailPresenter.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginEmail extends StatefulWidget {
  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends BaseState<LoginEmail> implements LoginEmailDelegate{
  LoginEmailPresenter _presenter;

  String _email = "";
  String _name = "";
  String _password = "";

  bool _nextStep = false;
  bool _isAlreadyRegistered = false;

  @override
  void initState() {
    super.initState();
    _presenter = LoginEmailPresenter(this, this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: StyledText("Login With Email"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => finish(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(adaptiveWidth(context, 12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (it) => _email = it,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorUtils.primary),
                ),
                labelText: "Email",
                labelStyle: TextStyle(
                  color: ColorUtils.primary,
                ),
              ),
            ),
            SizedBox(height: adaptiveWidth(context, 10)),
            _formWidget(),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: MaterialButton(
                onPressed: _nextStep && !_isAlreadyRegistered ?
                    () => _presenter.createUser(_email, _password, _name) : _nextStep ?
                    () => _presenter.login(_email, _password) :
                    () => _presenter.checkEmailAvailability(_email),
                color: ColorUtils.primary,
                height: adaptiveWidth(context, 40),
                child: StyledText(_nextStep && _isAlreadyRegistered ? "LOGIN" : _nextStep ? "SIMPAN" : "BERIKUTNYA",
                  size: adaptiveWidth(context, 14),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void onEmailNotRegistered() {
    setState(() {
      _nextStep = true;
      _isAlreadyRegistered = false;
    });
  }

  @override
  void onEmailAlreadyRegistered() {
    setState(() {
      _nextStep = true;
      _isAlreadyRegistered = true;
    });
  }

  @override
  void onSuccessLoginOrCreateUser() {
    Fluttertoast.showToast(msg: "Success Login");
    navigateTo(MyApp.ROUTE_HOME, singleTop: true);
  }

  Widget _formWidget(){
    var widgets = <Widget>[];

    if(_nextStep && !_isAlreadyRegistered){
      widgets.add(
        TextFormField(
          textCapitalization: TextCapitalization.words,
          onChanged: (it) => _name = it,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.primary),
            ),
            labelText: "Nama Lengkap",
            labelStyle: TextStyle(
              color: ColorUtils.primary,
            ),
          ),
        )
      );
      widgets.add(SizedBox(height: adaptiveWidth(context, 10)));
    }

    if(_nextStep) {
      widgets.add(
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            textCapitalization: TextCapitalization.words,
            onChanged: (it) => _password = it,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.primary),
              ),
              labelText: "Password",
              labelStyle: TextStyle(
                color: ColorUtils.primary,
              ),
            ),
          )
      );

      widgets.add(SizedBox(height: adaptiveWidth(context, 10)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
}
