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
                          authController.emailController.value,
                      hintText: AppStrings.emailAddress,
                      icon: Icons.email,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.emailAddress),
                  smallSizedBox,
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Colors.white, thickness: 1),
                      ),
                      Text('OR', style: AppStyles.smallerTextStyle),
                      const Expanded(
                        child: Divider(color: Colors.white, thickness: 1),
                      ),
                    ],
                  ),
                  smallSizedBox,
                  AppWidget.phoneNumberTextField(),
                  largeSizedBox,

                  Obx(
                    () => AppWidget.elevatedButton(
                      loading: authController.isLoading.value,
                      text: AppStrings.submit,
                      onTap: () async {
                        if (authController.emailController.value.text.isEmpty &&
                            authController
                                .mobileController.value.text.isEmpty) {
                          AppWidget.toast(text: "Please enter valid data");
                        } else {
                          if (authController
                              .emailController.value.text.isNotEmpty) {
                            authController.emailOrPhone.value =
                                authController.emailController.value.text;
                            authController.update();

                            await authController.forgotPasswordOtpApiCall();
                          } else {
                            authController.emailOrPhone.value =
                                authController.mobileController.value.text;
                            authController.update();

                            await authController.forgotPasswordOtpApiCall();
                          }
                        }
                      },
                    ),
                  )
                  //Get.toNamed(RouteHelper.verifyEmailForForgotPass)),
                ]),
          )),
    ));
  }
}