import 'dart:async';
import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
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
    Timer(const Duration(seconds: 4), () {
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
                  child: Text(
                    AppStrings.meetMineCelebrate,
                    style: AppStyles.mediumTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}