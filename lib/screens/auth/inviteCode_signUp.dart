import 'package:bondio/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../utils/utils.dart';

class InviteCodeSignUp extends StatelessWidget {
  const InviteCodeSignUp({Key? key}) : super(key: key);

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
                body: Padding(
                  padding: paddingSymmetric(horizontalPad: 6.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mediumSizedBox,
                      Text(
                        'Welcome to Bondio App',
                        style: AppStyles.largeTextStyle,
                      ),
                      const Spacer(),
                      Text(
                        AppStrings.yourInviteCode,
                        style: AppStyles.mediumTextStyle,
                      ),
                      smallSizedBox,
                      AppWidget.textFormFiledWhite(
                          hintText: AppStrings.inviteCode,
                          textEditingController:
                              authController.referCodeController.value,
                          textInputAction: TextInputAction.done),
                      largeSizedBox,
                      Obx(
                        () => AppWidget.elevatedButton(
                            loading: authController.isLoading.value,
                            text: AppStrings.submit,
                            onTap: () {
                              if (authController
                                  .referCodeController.value.text.isNotEmpty) {
                                authController.checkInviteCodeApi();
                              } else {
                                AppWidget.toast(
                                    text: 'Please enter an Invite Code');
                              }
                            }),
                      ),
                      const Spacer(),
                    ],
                  ),
                ))));
  }
}
