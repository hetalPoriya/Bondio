import 'package:bondio/utils/app_widget_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controller/auth_controller.dart';
import '../../utils/utils.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    return SafeArea(
        child: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(gradient: ColorConstant.linearColor),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppWidget.appbar(text: AppStrings.forgotPass),
          body: Center(
            child: ListView(
                padding: paddingSymmetric(horizontalPad: 6.w, verticalPad: 2.h),
                shrinkWrap: true,
                children: [
                  Text(AppStrings.forgotPasswordLink,
                      style: AppStyles.smallTextStyle,
                      textAlign: TextAlign.center),
                  largeSizedBox,
                  AppWidget.textFormFiledWhite(
                      textEditingController:
                          authController.emailLoginController.value,
                      hintText: AppStrings.emailAddress,
                      icon: Icons.email,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.emailAddress),
                  SizedBox(height: 30.h),
                  AppWidget.elevatedButton(
                    loading: authController.isLoading.value,
                    text: AppStrings.submit,
                    onTap: () {},
                  ),
                  //Get.toNamed(RouteHelper.verifyEmailForForgotPass)),
                ]),
          )),
    ));
  }
}
