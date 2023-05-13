import 'dart:developer';

import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/utils/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controller/controller.dart';
import '../../utils/app_widget_new.dart';

class InviteFriend extends StatelessWidget {
  InviteFriend({Key? key}) : super(key: key);

  HomeController homeController = Get.put(HomeController());
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).viewPadding.top,
        alignment: Alignment.center,
        child: Padding(
          padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 0.0),
          child: ListView(children: [
            mediumSizedBox,
            AppWidget.bondioTextAndMenu(context: context),
            mediumSizedBox,
            AppWidget.containerWithLinearColor(
              onTap: () {
                homeController.selectedIndex.value = 0;
                homeController.update();
              },
              widget: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.inviteFriend,
                  textAlign: TextAlign.start,
                  style: smallTextStyleWhiteText.copyWith(
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            mediumSizedBox,
            Container(
                height: 30.h,
                width: 80.w,
                padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 00),
                child: Image.asset(
                  AppAssets.inviteFriendImage,
                  fit: BoxFit.fill,
                )),
            smallerSizedBox,
            Padding(
              padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 0.0),
              child: Text(
                AppStrings.inviteFriendDec,
                textAlign: TextAlign.center,
                style: smallTextStyleGreyText,
              ),
            ),
            mediumSizedBox,
            GestureDetector(
              onTap: SharedPrefClass.getBool(
                          SharedPrefStrings.isLogin, false) ==
                      false
                  ? () {
                      _showDialogToGuest(context);
                    }
                  : () => FlutterShare.share(
                      title: 'Bondio App',
                      text:
                          'Hey! I\'ve been using Bondio App. Enter my code ${authController.userModel.value.user?.referCode.toString()} while signing up and increase your chances of getting rewards! 😍',
                      linkUrl:
                          'https://play.google.com/store/apps/details?id=com.app.bondio'),
              child: DottedBorder(
                color: ColorConstant.backGroundColorOrange,
                radius: Radius.circular(10.w),
                borderType: BorderType.RRect,
                padding: EdgeInsets.zero,
                child: SizedBox(
                  height: 6.h,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10.w),
                  //     border: Border.all(
                  //       color: ColorConstant.lightOrange,
                  //       style: BorderStyle.solid,
                  //     )),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: paddingSymmetric(
                              horizontalPad: 4.w, verticalPad: 00),
                          child: Text(
                            authController.userModel.value.user?.referCode
                                    .toString() ??
                                ' ',
                            style: headerTextStyleBlack.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        Container(
                          width: 15.w,
                          margin: paddingAll(paddingAll: 1.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.w),
                              gradient: LinearGradient(colors: [
                                ColorConstant.backGroundColorOrange,
                                ColorConstant.backGroundColorLightPink
                              ])),
                          child:
                              Icon(Icons.share, color: Colors.white, size: 6.w),
                        )
                      ]),
                ),
              ),
            ),
            mediumSizedBox
          ]),
        ),
      ),
    ));
  }

  _showDialogToGuest(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Bondio',
              style: AppStyles.mediumTextStyle
                  .copyWith(color: ColorConstant.darkOrange)),
          content: Text(
              'In order to invite your friend on this amazing app, please create your account.',
              style: AppStyles.smallTextStyle.copyWith(color: Colors.black)),
          actionsPadding: EdgeInsets.zero,
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed(RouteHelper.signUpPage);
                },
                child: Text(
                  'Ok',
                  style: AppStyles.smallTextStyle.copyWith(color: Colors.black),
                ))
          ],
        );
      },
    );
  }
}
