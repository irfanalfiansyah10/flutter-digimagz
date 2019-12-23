import 'package:digimagz/custom/dialog/LoadingDialog.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';

abstract class BaseStatefulWidget extends StatefulWidget {

}

abstract class BaseState<T extends BaseStatefulWidget> extends State<T> {

  @override
  void initState() {
    super.initState();
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

  void finish({dynamic result}){
    Navigator.of(context).pop(result);
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

  void onRequestTimeOut(int typeRequest){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext c) => AlertDialog(
          title: Text("Error", style: TextStyle(fontSize: 20, color: Colors.black)),
          content: Text("Request Time Out, try again later", style: TextStyle(fontSize: 16, color: Color(0x8a000000))),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {Navigator.of(c).pop();},
            )
          ],
        )
    );
  }

  void onNoConnection(int typeRequest){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext c) => AlertDialog(
          title: Text("Error", style: TextStyle(fontSize: 20, color: Colors.black)),
          content: Text("No Internet Connection, check your connection", style: TextStyle(fontSize: 16, color: Color(0x8a000000))),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {Navigator.of(c).pop();},
            )
          ],
        )
    );
  }

  void onUnknownError(int typeRequest, String msg){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext c) => AlertDialog(
          title: Text("Error", style: TextStyle(fontSize: 20, color: Colors.black)),
          content: Text(msg, style: TextStyle(fontSize: 16, color: Color(0x8a000000))),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {Navigator.of(c).pop();},
            )
          ],
        )
    );
  }

  void alert(String title, String message,
      String negativeAction,
      String positiveAction,
      VoidCallback onNegative,
      VoidCallback onPositive,
      {
        Color negativeColor = Colors.grey,
        Color positiveColor = ColorUtils.primary
      }){
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title,
              style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w500, color: Colors.black)),
          content: Text(message,
              style: TextStyle(fontSize: 16,
                  color: Colors.black)),
          actions: <Widget>[
            FlatButton(
              child: Text(negativeAction,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,
                      color: negativeColor)),
              onPressed: (){
                onNegative();
              },
            ),

            FlatButton(
              child: Text(positiveAction,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,
                      color: positiveColor)),
              onPressed: (){
                onPositive();
              },
            )
          ],
        )
    );
  }
}

