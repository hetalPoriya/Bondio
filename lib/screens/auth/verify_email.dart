import 'package:bondio/controller/auth_controller.dart';
import 'package:bondio/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({Key? key}) : super(key: key);

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
          appBar: AppWidget.appbar(text: AppStrings.verifyEmail),
          body: Center(
            child: ListView(
                padding: paddingSymmetric(horizontalPad: 6.w, verticalPad: 2.h),
                shrinkWrap: true,
                children: [
                  smallerSizedBox,
                  Center(
                    child: Text(AppStrings.verificationEmail,
                        style: AppStyles.smallTextStyle),
                  ),
                  Center(
                    child: Text(
                        Get.arguments[0] == 0
                            ? '${authController.countryCodeController.value.text}${authController.mobileController.value.text}'
                            : authController.emailOrPhone.value,
                        style: AppStyles.smallTextStyle.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  // smallSizedBox,
                  // Center(
                  //   child: Text(AppStrings.codeExpireString,
                  //       style:
                  //           AppStyles.smallTextStyle.copyWith(fontSize: 9.sp),
                  //       textAlign: TextAlign.center),
                  // ),
                  largeSizedBox,
                  OtpTextField(
                    numberOfFields: 6,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    fieldWidth: 12.w,
                    textStyle: AppStyles.smallTextStyle,
                    cursorColor: Colors.white,
                    focusedBorderColor: Colors.white,
                    enabledBorderColor: Colors.orange.shade100,
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    onSubmit: (String verificationCode) {
                      authController.enterOtpByUser.value = verificationCode;
                      authController.update();
                    }, // end onSubmit
                  ),
                  largeSizedBox,
                  largeSizedBox,
                  Obx(
                    () => AppWidget.elevatedButton(
                        text: AppStrings.verify,
                        loading: authController.isLoading.value,
                        onTap: () async => Get.arguments[0] == 0
                            ? await authController.registerApiCall()
                            : await authController
                                .forgotPasswordVerifyOtpApiCall()),
                  ),
                  //onTap: () => Get.toNamed(RouteHelper.homeScreen)),
                  smallSizedBox,
                  GestureDetector(
                    onTap: () async => Get.arguments[0] == 0
                        ? await authController.registerOtpApiCall()
                        : await authController.forgotPasswordOtpApiCall(),
                    child: Center(
                      child: Text(
                        AppStrings.resendCode,
                        style: AppStyles.smallTextStyle,
                      ),
                    ),
                  ),
                  smallSizedBox,
                  const Divider(color: Colors.grey, thickness: 1),
                  smallSizedBox,
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Center(
                      child: Text(
                        AppStrings.backToPrevious,
                        style: AppStyles.smallTextStyle,
                      ),
                    ),
                  ),
                ]),
          )),
    ));
  }
}
