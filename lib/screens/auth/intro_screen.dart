import 'dart:io';

import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkwell/linkwell.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..reverse();
    // TODO: implement initState
    super.initState();
  }

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
                                          final credential = await SignInWithApple.getAppleIDCredential(
                                            scopes: [
                                              AppleIDAuthorizationScopes.email,
                                              AppleIDAuthorizationScopes.fullName,
                                            ],
                                          );

                                          print(credential);
                                        },
                                      ),
                                    ),

                                  // _socialButton(
                                  //     text: AppStrings.signInWithGoogle,
                                  //     icon: AppAssets.google,
                                  //     color: Colors.white,
                                  //     textColor: Colors.black,
                                  //     onTap: () async => await socialLoginController
                                  //         .signInWithGoogle()),
                                  // smallSizedBox,
                                  // _socialButton(
                                  //     text: AppStrings.signInWithFacebook,
                                  //     icon: AppAssets.facebook,
                                  //     onTap: () async => await socialLoginController
                                  //         .signInWithFacebook()),
                                  // smallSizedBox,
                                  // _socialButton(
                                  //     text: AppStrings.signInWithLinkedIn,
                                  //     icon: AppAssets.facebook,
                                  //     onTap: () async => await socialLoginController
                                  //         .signInWithFacebook()),
                                  // smallSizedBox,
                                  // _socialButton(
                                  //     text: AppStrings.signInWithInstagram,
                                  //     icon: AppAssets.facebook,
                                  //     onTap: () async => await socialLoginController
                                  //         .signInWithFacebook()),
                                  // smallSizedBox,
                                  // _socialButton(
                                  //     text: AppStrings.signInWithOutlook,
                                  //     icon: AppAssets.facebook,
                                  //     onTap: () async => await socialLoginController
                                  //         .signInWithFacebook()),
                                  // smallSizedBox,
                                  // _socialButton(
                                  //     text: AppStrings.signInWithTwitter,
                                  //     icon: AppAssets.facebook,
                                  //     onTap: () async => await socialLoginController
                                  //         .signInWithFacebook()),
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

                                  LinkWell(AppStrings.acceptPrivacyPolicy,
                                      textAlign: TextAlign.center,
                                      style: AppStyles.smallTextStyle.copyWith(
                                        color: Colors.grey,
                                      ),
                                      linkStyle:
                                          AppStyles.smallTextStyle.copyWith(
                                        color: Colors.blue,
                                      )),

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

  // Future<void> _onOpen(LinkableElement link) async {
  //   if (await canLaunchUrl(Uri.parse(link.url))) {
  //     await launchUrl(Uri.parse(link.url));
  //   } else {
  //     throw 'Could not launch $link';
  //   }
  // }

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
}

class DisplayOptions {
  String text;
  String routeString;

  DisplayOptions({required this.text, required this.routeString});
}
