import 'package:bondio/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

EdgeInsets paddingAll({required double paddingAll}) =>
    EdgeInsets.all(paddingAll);

EdgeInsets paddingSymmetric({double? horizontalPad, double? verticalPad}) =>
    EdgeInsets.symmetric(
        horizontal: horizontalPad ?? 00, vertical: verticalPad ?? 00);

SizedBox smallerSizedBox = SizedBox(height: 1.h);
SizedBox smallSizedBox = SizedBox(height: 2.h);
SizedBox mediumSizedBox = SizedBox(height: 4.h);
SizedBox largeSizedBox = SizedBox(height: 8.h);

LinearGradient linearGradientColor = LinearGradient(colors: [
  ColorConstant.backGroundColorOrange,
  ColorConstant.backGroundColorLightPink,
  ColorConstant.backGroundColorDarkPurple,
], begin: Alignment.bottomLeft, end: Alignment.topRight);

LinearGradient drawerLinearColor = LinearGradient(colors: [
  ColorConstant.drawerColor1,
  ColorConstant.drawerColor2,
], begin: Alignment.topCenter, end: Alignment.bottomCenter);

class AppStyles {
  static TextStyle smallerTextStyle = TextStyle(
      fontSize: 10.sp, fontFamily: 'Exo2-Regular', color: Colors.white);

  static TextStyle smallTextStyle = TextStyle(
      fontSize: 12.sp, fontFamily: 'Exo2-Regular', color: Colors.white);

  static TextStyle mediumTextStyle = TextStyle(
      fontSize: 14.sp, fontFamily: 'Exo2-Regular', color: Colors.white);

  static TextStyle largeTextStyle = TextStyle(
      fontSize: 16.sp, fontFamily: 'Exo2-Regular', color: Colors.white);

  static TextStyle extraLargeTextStyle = TextStyle(
      fontSize: 18.sp, fontFamily: 'Exo2-Regular', color: Colors.white);
}