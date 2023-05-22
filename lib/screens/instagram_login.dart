import 'package:bondio/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class InstagramLogin extends StatelessWidget {
  const InstagramLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SocialLoginController socialLoginController =
        Get.put(SocialLoginController());
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: paddingSymmetric(horizontalPad: 6.w),
          decoration: BoxDecoration(gradient: ColorConstant.linearColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppWidget.textFormFiledWhite(
                  textEditingController:
                      socialLoginController.instagramName.value,
                  hintText: 'Enter Instagram User Name'),
              largeSizedBox,
              AppWidget.elevatedButton(
                  text: 'Continue',
                  onTap: () => socialLoginController.signInWithInstagram(
                      userName: socialLoginController.instagramName.value.text))
            ],
          )),
    );
  }
}
