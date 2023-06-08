import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controller/auth_controller.dart';
import '../../utils/utils.dart';

class NewPassword extends StatelessWidget {
  NewPassword({Key? key}) : super(key: key);
  final _formkey = GlobalKey<FormState>();

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
          appBar: AppWidget.appbar(text: AppStrings.enterNewPass),
          body: Center(
            child: Form(
                key: _formkey,
                child: Obx(
                  () => ListView(
                      padding: paddingSymmetric(
                          horizontalPad: 6.w, verticalPad: 2.h),
                      shrinkWrap: true,
                      children: [
                        Text(AppStrings.newPassDec,
                            style: AppStyles.smallTextStyle,
                            textAlign: TextAlign.center),
                        largeSizedBox,
                        AppWidget.textFormFiledWhite(
                            textEditingController:
                                authController.newPassController.value,
                            hintText: AppStrings.password,
                            obscureText: authController.obscure.value,
                            textInputType: TextInputType.text,
                            validator: FormValidation.passwordValidation(
                                value: authController
                                    .newPassController.value.text),
                            isIconVisible: true,
                            textInputAction: TextInputAction.done,
                            icon: authController.obscure.value
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                            suffixOnTap: () {
                              authController.obscure.value =
                                  !authController.obscure.value;
                              authController.update();
                            }),
                        smallSizedBox,
                        AppWidget.textFormFiledWhite(
                            textEditingController:
                                authController.conPassController.value,
                            hintText: AppStrings.conPassword,
                            obscureText: authController.obscureForConPass.value,
                            textInputType: TextInputType.text,
                            validator: FormValidation.passwordValidation(
                                value: authController
                                    .conPassController.value.text),
                            isIconVisible: true,
                            textInputAction: TextInputAction.done,
                            icon: authController.obscureForConPass.value
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                            suffixOnTap: () {
                              authController.obscureForConPass.value =
                                  !authController.obscureForConPass.value;
                              authController.update();
                            }),

                        largeSizedBox,

                        Obx(
                          () => AppWidget.elevatedButton(
                              loading: authController.isLoading.value,
                              text: AppStrings.submit,
                              onTap: () async {
                                if (_formkey.currentState!.validate()) {
                                  await authController
                                      .forgotPasswordUpdateApiCall();
                                }
                              }),
                        )
                        //Get.toNamed(RouteHelper.verifyEmailForForgotPass)),
                      ]),
                )),
          )),
    ));
  }
}
