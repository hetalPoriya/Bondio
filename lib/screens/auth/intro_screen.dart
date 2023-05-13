import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/app_widget_new.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  SocialLoginController socialLoginController =
      Get.put(SocialLoginController());
  AuthController authController = Get.put(AuthController());

  List<String?> socialMedia = [
    AppAssets.google,
    AppAssets.facebook,
    AppAssets.linkedIn,
    AppAssets.outlook,
    AppAssets.instagram,
    AppAssets.twitter,
  ];

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
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
                  Spacer(),
                  Image.asset(
                    AppAssets.bondioText,
                    width: 50.w,
                  ),
                  Spacer(),
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
                                          fontWeight: FontWeight.w600)),
                                  smallSizedBox,
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      margin:
                                          paddingSymmetric(horizontalPad: 3.w),
                                      height: 7.h,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: List.generate(
                                            socialMedia.length,
                                            (index) => GestureDetector(
                                              onTap: () async {
                                                authController
                                                    .fullNameController
                                                    .value
                                                    .text = '';
                                                authController.mobileController
                                                    .value.text = '';
                                                authController.dobController
                                                    .value.text = '';
                                                authController
                                                    .referCodeController
                                                    .value
                                                    .text = '';
                                                Get.back();
                                                if (index == 0) {
                                                  authController.isGoogle
                                                      .value = 'Google';
                                                  authController.update();
                                                  socialLoginController
                                                      .signInWithGoogle();
                                                } else if (index == 1) {
                                                  authController.isGoogle
                                                      .value = 'Facebook';
                                                  authController.update();
                                                  socialLoginController
                                                      .signInWithFacebook();
                                                } else if (index == 2) {
                                                  //linkedInLogin();
                                                  socialLoginController
                                                      .signInWithLinkedIn();
                                                } else if (index == 4) {
                                                  socialLoginController
                                                      .signInWithInstagram(
                                                          userName:
                                                              '_poriya_149');
                                                }
                                              },
                                              child: Container(
                                                width: 15.w,
                                                height: 6.h,
                                                padding:
                                                    paddingAll(paddingAll: 2.w),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.black12,
                                                        spreadRadius: 2,
                                                        blurRadius: 2,
                                                        offset: Offset(2,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300)),
                                                child: Image.asset(
                                                    socialMedia[index]
                                                        .toString(),
                                                    alignment:
                                                        Alignment.center),
                                              ),
                                            ),
                                          )),
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
                                  Divider(thickness: 2),

                                  buttonText(
                                      text: AppStrings.doYouHaveAnInviteCode,
                                      onTap: () {
                                        Get.back();
                                        Get.toNamed(RouteHelper.signUpPage);
                                      }),

                                  Divider(thickness: 2),

                                  buttonText(
                                      text: AppStrings.enterAsAGuest,
                                      onTap: () => Get.offNamedUntil(
                                          RouteHelper.homeScreen,
                                          (route) => false)),
                                  Divider(thickness: 2),
                                  buttonText(
                                      text: AppStrings.createAnAccount,
                                      onTap: () {
                                        Get.back();
                                        Get.toNamed(RouteHelper.signUpPage);
                                      }),
                                  Divider(thickness: 2),
                                  buttonText(
                                      text: AppStrings.loginWithEmail,
                                      onTap: () {
                                        Get.back();
                                        Get.toNamed(RouteHelper.loginPage);
                                      }),

                                  Divider(thickness: 2),

                                  Linkify(
                                      onOpen: _onOpen,
                                      text: AppStrings.acceptPrivacyPolicy,
                                      textAlign: TextAlign.center,
                                      linkStyle: AppStyles.smallTextStyle
                                          .copyWith(
                                              fontSize: 10.sp,
                                              color: Colors.grey.shade600),
                                      style: AppStyles.smallTextStyle.copyWith(
                                          fontSize: 10.sp,
                                          color: Colors.grey.shade500)),
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
                    ? Container(
                        color: Colors.black45,
                        child: Center(
                          child: Material(
                            borderRadius: BorderRadius.circular(2.w),
                            child: Container(
                              height: 12.h,
                              width: 24.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.w),
                                color: Colors.white,
                              ),
                              child: AppWidget.progressIndicator(
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunchUrl(Uri.parse(link.url))) {
      await launchUrl(Uri.parse(link.url));
    } else {
      throw 'Could not launch $link';
    }
  }

  _socialButton(
      {required String text,
      required String icon,
      Color? textColor,
      Color? color,
      required VoidCallback onTap}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.black,
            //side: BorderSide(color: Colors.black),
            elevation: 2.w,
            maximumSize: Size(80.w, 6.h),
            minimumSize: Size(80.w, 6.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.w))),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(icon, height: 3.h),
            ),
            SizedBox(
              width: 4.w,
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.smallTextStyle.copyWith(color: textColor),
                ),
              ),
            )
          ],
        ));
  }

  linkedInLogin() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LinkedInUserWidget(
          appBar: AppBar(
            title: Text('Bondio'),
          ),
          redirectUrl: 'http://example.com/sa/complete/linkedin-oauth2/',
          clientId: '77qs3v01ir4zv2',
          clientSecret: '5ZzZmoAjn3KtZblB',
          onGetUserProfile: (UserSucceededAction linkedInUser) async {},
        ),
        fullscreenDialog: true,
      ),
    );
  }

  buttonText({required String text, required VoidCallback onTap}) => Container(
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
