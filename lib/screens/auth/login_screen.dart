import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //contoller
  AuthController authController = Get.put(AuthController());
  SocialLoginController socialLoginController =
  Get.put(SocialLoginController());

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: ColorConstant.linearColor),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            shrinkWrap: true,
            children: [
              mediumSizedBox,
              Image.asset(
                AppAssets.bondioText,
                height: 10.h,
              ),
              mediumSizedBox,
              Obx(
                    () =>
                    Form(
                      key: _formkey,
                      child: Padding(
                        padding:
                        paddingSymmetric(horizontalPad: 4.w, verticalPad: 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.loginWithEmail,
                              style: AppStyles.largeTextStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            mediumSizedBox,
                            AppWidget.textFormFiledWhite(
                                validator: FormValidation.emailValidation(
                                    value:
                                    authController.emailController.value.text),
                                textEditingController:
                                authController.emailController.value,
                                hintText: AppStrings.emailAddress,
                                icon: Icons.email,
                                textInputType: TextInputType.emailAddress),
                            smallSizedBox,
                            AppWidget.textFormFiledWhite(
                                textEditingController:
                                authController.passController.value,
                                hintText: AppStrings.password,
                                obscureText: authController.obscure.value,
                                textInputType: TextInputType.text,
                                validator: FormValidation.passwordValidation(
                                    value:
                                    authController.passController.value.text),
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
                            Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () =>
                                      Get.toNamed(RouteHelper.forgotPassword),
                                  child: Text(
                                    AppStrings.forgotPass,
                                    style: AppStyles.smallerTextStyle,
                                  ),
                                )),
                            Obx(
                                  () =>
                                  CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    controlAffinity: ListTileControlAffinity
                                        .leading,
                                    checkColor: ColorConstant
                                        .backGroundColorOrange,
                                    value: authController.rememberOrNot.value,
                                    activeColor: Colors.white,
                                    hoverColor: Colors.white,
                                    title: Text(AppStrings.rememberMe,
                                        style: AppStyles.smallTextStyle
                                            .copyWith(
                                            color: Colors.white,
                                            fontSize: 11.sp)),
                                    onChanged: (bool? value) {
                                      authController.rememberOrNot.value =
                                      value!;
                                      authController.update();
                                    },
                                  ),
                            ),
                            mediumSizedBox,
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                      color: Colors.white, thickness: 1),
                                ),
                                Text('OR', style: AppStyles.smallerTextStyle),
                                const Expanded(
                                  child: Divider(
                                      color: Colors.white, thickness: 1),
                                ),
                              ],
                            ),
                            mediumSizedBox,
                            AppWidget.socialLogin(),
                            mediumSizedBox,
                            Obx(() =>
                                AppWidget.elevatedButton(
                                    loading: authController.isLoading.value,
                                    text: AppStrings.submit,
                                    onTap: () async {
                                      if (_formkey.currentState!.validate()) {
                                        await authController.loginApiCall();
                                      }
                                    })),
                            smallerSizedBox,
                          ],
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}