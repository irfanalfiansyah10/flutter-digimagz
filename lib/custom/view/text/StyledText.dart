import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String value;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final FontStyle fontStyle;
  final TextDecoration decoration;

  const StyledText(this.value, {Key key,
    this.size,
    this.color = Colors.black,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.fontStyle = FontStyle.normal,
    this.decoration = TextDecoration.none
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Text(
      value, textScaleFactor: 1.0,
      textAlign: textAlign,
      style: TextStyle(
        decoration: decoration,
        fontSize: size,
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
