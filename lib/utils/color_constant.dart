import 'package:flutter/material.dart';

class ColorConstant {
  //new colors
  static Color mainAppColorNew = const Color(0xffF44B5A);

  static Color lightOrange = const Color(0xffFFB574);
  static Color darkOrange = const Color(0xffF6534C);
  static Color lightPink = const Color(0xffC9379D);
  static Color extraLightPink = const Color(0xffCE689A);
  static Color backGroundColorOrange = const Color(0xffFF7A00);
  static Color backGroundColorLightPink = const Color(0xffED2D92);
  static Color backGroundColorDarkPurple = const Color(0xff000080);
  static Color chatColor = const Color(0xffFAE8DD);
  static Color lightGrey = const Color(0xffFCFCFC);
  static Color greyBorder = const Color(0xffD4D4D4);
  static Color mainColor = const Color(0xffE7E7E7);
  static Color lightGreyContainer = const Color(0xffF3F3F3);
  static Color faceLightColor = const Color(0xffFFF7F0);
  static Color darkPink = const Color(0xffD22890);
  static Color lightRed = const Color(0xffF6524D);
  static Color darkRed = const Color(0xffFD740D);
  static Color drawerColor1 = const Color(0xffE83E6B);
  static Color drawerColor2 = const Color(0xffF76F11);

  static Color gredient1 = const Color(0xffF7554F);
  static Color gredient2 = const Color(0xffC62695);
  static Color gredient3 = const Color(0xff1A0460);

  static List<Color> gradientColor = [
    gredient1,
    gredient2,
    gredient3,
  ];

  static Gradient linearColor = LinearGradient(
      colors: ColorConstant.gradientColor,
      begin: Alignment.centerLeft,
      end: Alignment.bottomRight);
}
