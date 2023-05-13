import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/utils/app_widget_new.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 6), () {
      if (SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) == true) {
        Get.offNamedUntil(RouteHelper.homeScreen, (route) => false);
      } else {
        Get.offNamed(RouteHelper.introScreen);
      }
    });

    return SafeArea(
      child: Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(gradient: ColorConstant.linearColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.bondioText,
                  width: 50.w,
                ),
                smallSizedBox,
                Container(
                  margin: paddingSymmetric(horizontalPad: 8.w),
                  width: double.infinity,
                  child: DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontFamily: 'Alex Brush',
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                            'Being miles apart shouldn\'t keep you apart meet dine celebrate!',
                            textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontFamily: 'Alex Brush',
                            ),
                            textAlign: TextAlign.center,
                            speed: Duration(milliseconds: 80)),
                      ],
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
