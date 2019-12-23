import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              width: adaptiveWidth(context, 85),
              height: adaptiveWidth(context, 85),
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ColorUtils.primary),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}