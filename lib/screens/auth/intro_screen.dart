import 'dart:io';
import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  AuthController authController = Get.put(AuthController());

  List<DisplayOptions> displayOptions = [
    DisplayOptions(
        text: AppStrings.createAnAccount, routeString: RouteHelper.signUpPage),
    DisplayOptions(
        text: AppStrings.loginWithEmail, routeString: RouteHelper.loginPage),
    DisplayOptions(
        text: AppStrings.doYouHaveAnInviteCode,
        routeString: RouteHelper.inviteCodeSignUp),
    DisplayOptions(
        text: AppStrings.enterAsAGuest, routeString: RouteHelper.homeScreen),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: ColorConstant.linearColor),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  Image.asset(
                    AppAssets.bondioText,
                    width: 50.w,
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () => showModalBottomSheet(
                          isDismissible: true,
                          isScrollControlled: true,
                          enableDrag: true,
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  smallSizedBox,
                                  Container(
                                    width: 25.w,
                                    height: 1.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.w),
                                        color: Colors.black54),
                                  ),
                                  smallSizedBox,
                                  Text(AppStrings.continueWith,
                                      style: AppStyles.mediumTextStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  smallSizedBox,
                                  AppWidget.socialLogin(),
                                  if (Platform.isIOS) smallSizedBox,
                                  if (Platform.isIOS)
                                    Padding(
                                      padding:
                                          paddingSymmetric(horizontalPad: 6.w),
                                      child: SignInWithAppleButton(
                                        borderRadius:
                                            BorderRadius.circular(2.w),
                                        style: SignInWithAppleButtonStyle
                                            .whiteOutlined,
                                        onPressed: () async {
                                          final credential =
                                              await SignInWithApple
                                                  .getAppleIDCredential(
                                            scopes: [
                                              AppleIDAuthorizationScopes.email,
                                              AppleIDAuthorizationScopes
                                                  .fullName,
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  smallerSizedBox,
                                  const Divider(thickness: 2),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: displayOptions.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            width: 100.w,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  maximumSize: Size(100.w, 4.h),
                                                  minimumSize: Size(100.w, 4.h),
                                                  padding: EdgeInsets.zero),
                                              onPressed: () {
                                                Get.back();

                                                Get.toNamed(
                                                    displayOptions[index]
                                                        .routeString);
                                              },
                                              child: Text(
                                                displayOptions[index].text,
                                                style: AppStyles.smallTextStyle
                                                    .copyWith(
                                                        color: Colors
                                                            .blue.shade800),
                                              ),
                                            ),
                                          ),
                                          const Divider(thickness: 2),
                                        ],
                                      );
                                    },
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        'By continuing you also accept our ',
                                        style: AppStyles.smallTextStyle
                                            .copyWith(color: Colors.black),
                                      ),
                                      GestureDetector(
                                          onTap: () => _showPrivacyDialog(),
                                          child: Text(
                                            'Privacy-policy',
                                            style: AppStyles.smallTextStyle
                                                .copyWith(color: Colors.blue),
                                          )),
                                      Text(
                                        'and ',
                                        style: AppStyles.smallTextStyle
                                            .copyWith(color: Colors.black),
                                      ),
                                      GestureDetector(
                                          onTap: () =>
                                              _showTermAndConditionDialog(),
                                          child: Text(
                                            'Terms and Conditions',
                                            style: AppStyles.smallTextStyle
                                                .copyWith(color: Colors.blue),
                                          )),
                                    ],
                                  ),
                                  smallSizedBox
                                ],
                              ),
                            );
                          }),
                      child: Container(
                        width: 50.w,
                        height: 6.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            color: Colors.white),
                        child: Text(
                          'Get Started',
                          style: AppStyles.smallTextStyle.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  largeSizedBox,
                ],
              ),
              Obx(
                () => authController.isLoading.value == true
                    ? AppWidget.containerIndicator()
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  buttonText({required String text, required VoidCallback onTap}) => SizedBox(
        width: 100.w,
        child: TextButton(
          style: TextButton.styleFrom(
              maximumSize: Size(100.w, 4.h),
              minimumSize: Size(100.w, 4.h),
              padding: EdgeInsets.zero),
          onPressed: onTap,
          child: Text(
            text,
            style:
                AppStyles.smallTextStyle.copyWith(color: Colors.blue.shade800),
          ),
        ),
      );

  _showPrivacyDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: 70.h,
          width: 100.w,
          child: WebViewWidget(
              controller: WebViewController()
                ..loadRequest(
                    Uri.parse('https://bondiomeet.com/privacy-policy'))),
        ),
        actionsPadding: EdgeInsets.zero,
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Ok',
                style: AppStyles.mediumTextStyle.copyWith(color: Colors.black),
              ))
        ],
      ),
    );
  }

  _showTermAndConditionDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: 70.h,
          width: 100.w,
          child: WebViewWidget(
              controller: WebViewController()
                ..loadRequest(
                    Uri.parse('https://bondiomeet.com/term-conditions'))),
        ),
        actionsPadding: EdgeInsets.zero,
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Ok',
                style: AppStyles.mediumTextStyle.copyWith(color: Colors.black),
              ))
        ],
      ),
    );
  }
}

class DisplayOptions {
  String text;
  String routeString;

  DisplayOptions({required this.text, required this.routeString});
}