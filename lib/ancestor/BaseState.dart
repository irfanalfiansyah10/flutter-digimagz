import 'dart:io';

import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/custom/dialog/LoadingDialog.dart';
import 'package:digimagz/extension/ErrorMessaging.dart';
import 'package:digimagz/network/response/BaseResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class BaseState<T extends StatefulWidget, P extends BasePresenter> extends State<T> {
  P presenter;

  P initPresenter();

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    presenter = initPresenter();
    WidgetsBinding.instance.addPostFrameCallback((_){
      afterWidgetBuilt();
    });
  }

  void afterWidgetBuilt(){

  }

  void onNavigationResume(String from){

  }

  void onNavigationResult(String from, dynamic result){

  }

  void navigateTo(String destination, {bool singleTop = false, dynamic arguments}) async {
    if(singleTop){
      Navigator.of(context).pushReplacementNamed(destination, arguments: arguments);
    }else {
      var result = await Navigator.of(context)
          .pushNamed(destination, arguments: arguments);

      if(result != null){
        onNavigationResult(destination, result);
      }
      onNavigationResume(destination);
    }
  }

  void navigateAndFinishCurrent(String destination, {dynamic arguments}) async {
    Navigator.of(context).popAndPushNamed(destination, arguments: arguments);
  }

  void finish({dynamic result}){
    Navigator.of(context).pop(result);
  }

  void openDialog({@required dynamic tag,
    @required BuildContext context,
    @required Widget Function(BuildContext context) builder}) async {
    var result = await showDialog(
        context: context,
        builder: builder
    );

    if(result != null){
      onDialogResult(tag, result);
    }
    onDialogClosed(tag);
  }

  void onDialogResult(dynamic tag, dynamic result){

  }

  void onDialogClosed(dynamic tag){

  }

  void shouldShowLoading(int typeRequest){
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) => LoadingDialog()
    );
  }

  void shouldHideLoading(int typeRequest){
    Navigator.of(context).pop();
  }

  void onResponseError(int typeRequest, ResponseException exception){
    dialog(msg: exception.msg);
  }

  void onRequestTimeOut(int typeRequest){
    dialog(msg: ErrorMessaging.REQUEST_TIME_OUT_MESSAGE);
  }

  void onNoConnection(int typeRequest){
    dialog(msg: ErrorMessaging.NO_CONNECTION_MESSAGE);
  }

  void onUnknownError(int typeRequest, String msg){
    dialog(msg: msg);
  }


  Future<dynamic> dialog({String title = ErrorMessaging.ERROR_TITLE_MESSAGE,
    String msg = ErrorMessaging.DEFAULT_MESSAGE,
    String actionMsg = ErrorMessaging.CLOSE_ACTION_MESSAGE, Function() action}){
    if(action == null){
      action = () => Navigator.of(context).pop();
    }

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext c) => AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 20, color: Colors.black)),
          content: Text(msg, style: TextStyle(fontSize: 16, color: Color(0x8a000000))),
          actions: <Widget>[
            FlatButton(
              child: Text(actionMsg),
              onPressed: action,
            )
          ],
        )
    );
  }

  void alert({String title = "Error", String message = "Something went wrong", String negativeTitle,
    String positiveTitle, VoidCallback onNegative, VoidCallback onPositive,
    Color negativeColor = Colors.grey, Color positiveColor = Colors.blue}){
    if(Platform.isIOS){
      iOSAlert(title: title, message: message,
          negativeTitle: negativeTitle, positiveTitle: positiveTitle,
          onNegative: onNegative, onPositive: onPositive,
          negativeColor: negativeColor, positiveColor: positiveColor);
    }else if(Platform.isAndroid){
      androidAlert(title: title, message: message,
          negativeTitle: negativeTitle, positiveTitle: positiveTitle,
          onNegative: onNegative, onPositive: onPositive,
          negativeColor: negativeColor, positiveColor: positiveColor);
    }else {
      Fluttertoast.showToast(msg: message);
    }
  }

  void androidAlert({String title, String message, String negativeTitle, String positiveTitle,
    VoidCallback onNegative, VoidCallback onPositive, Color negativeColor, Color positiveColor}){
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title,
              style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w500, color: Colors.black)),
          content: Text(message,
              style: TextStyle(fontSize: 16,
                  color: Colors.black)),
          actions: _alertActions(negativeTitle, positiveTitle, onNegative,
              onPositive, negativeColor, positiveColor),
        )
    );
  }

  void iOSAlert({String title, String message, String negativeTitle, String positiveTitle,
    VoidCallback onNegative, VoidCallback onPositive, Color negativeColor, Color positiveColor}){
    showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(title,
              style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w500, color: Colors.black)),
          content: Text(message,
              style: TextStyle(fontSize: 16,
                  color: Colors.black)),
          actions: _alertActions(negativeTitle, positiveTitle, onNegative,
              onPositive, negativeColor, positiveColor),
        )
    );
  }

  List<Widget> _alertActions(String negativeTitle, String positiveTitle, VoidCallback onNegative,
      VoidCallback onPositive, Color negativeColor,
      Color positiveColor){
    var actions = <Widget>[];

    if(negativeTitle != null){
      if(Platform.isIOS){
        actions.add(CupertinoDialogAction(
          child: Text(negativeTitle),
          onPressed: onNegative ?? () => finish(),
          isDefaultAction: true,
        ));
      }else {
        actions.add(FlatButton(
          child: Text(negativeTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,
                  color: negativeColor)),
          onPressed: onNegative ?? () => finish(),
        ));
      }
    }

    if(positiveTitle != null){
      if(Platform.isIOS){
        actions.add(CupertinoDialogAction(
          child: Text(positiveTitle),
          onPressed: onPositive ?? () => finish(),
          isDefaultAction: true,
        ));
      }else {
        actions.add(FlatButton(
          child: Text(positiveTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,
                  color: positiveColor)),
          onPressed: onPositive ?? () => finish(),
        ));
      }
    }

    return actions;
  }
}

