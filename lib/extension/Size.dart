import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double adaptiveWidth(BuildContext context, double size){
    ScreenUtil.instance = ScreenUtil(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        allowFontScaling: false)
      ..init(context);

  return ScreenUtil.instance.setWidth(size);
}

double adaptiveHeight(BuildContext context, double size){
    ScreenUtil.instance = ScreenUtil(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        allowFontScaling: false)
      ..init(context);

  return ScreenUtil.instance.setHeight(size);
}