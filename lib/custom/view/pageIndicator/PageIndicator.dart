import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final bool _isActive;

  PageIndicator(this._isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 12,
      width: 12,
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
          color: _isActive ? Colors.white : Colors.grey
      ),
    );
  }
}