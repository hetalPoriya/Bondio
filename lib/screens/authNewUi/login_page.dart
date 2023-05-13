// import 'package:bondio/controller/controller.dart';
// import 'package:bondio/route_helper/route_helper.dart';
// import 'package:bondio/utils/all_classes/bigPolygon_background.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   //for social Media options
//   List<String?> socialMedia = [
//     AppAssets.google,
//     AppAssets.facebook,
//     // AppAssets.linkedin,
//     // // AppAssets.outlook,
//     // AppAssets.email
//   ];
//
//   //contoller
//   AuthController authController = Get.put(AuthController());
//   SocialLoginController socialLoginController =
//       Get.put(SocialLoginController());
//
//   final _formkey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return BigPolygonBackground(
//         showingBackIconOrNot: false,
//         widget: Center(
//             child: Obx(
//           () => Stack(children: [
//             Form(
//               key: _formkey,
//               child: Padding(
//                   padding:
//                       paddingSymmetric(horizontalPad: 10.w, verticalPad: 2.h),
//                   child: Obx(
//                     () => Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         AppWidget.textFormFiled(
//                             validator: FormValidation.emailValidation(
//                                 value: authController
//                                     .emailLoginController.value.text),
//                             textEditingController:
//                                 authController.emailLoginController.value,
//                             hintText: AppStrings.emailAddress,
//                             icon: Icons.email,
//                             textInputType: TextInputType.emailAddress),
//                         smallSizedBox,
//                         AppWidget.textFormFiled(
//                             textEditingController:
//                                 authController.passLoginController.value,
//                             hintText: AppStrings.password,
//                             obscureText: authController.obscure.value,
//                             textInputType: TextInputType.text,
//                             textInputAction: TextInputAction.done,
//                             icon: authController.obscure.value
//                                 ? Icons.remove_red_eye_outlined
//                                 : Icons.remove_red_eye,
//                             suffixOnTap: () {
//                               authController.obscure.value =
//                                   !authController.obscure.value;
//                               authController.update();
//                             }),
//                         CheckboxListTile(
//                           contentPadding: EdgeInsets.zero,
//                           controlAffinity: ListTileControlAffinity.leading,
//                           value: authController.rememberOrNot.value,
//                           activeColor: ColorConstant.backGroundColorOrange,
//                           title: Text(AppStrings.rememberMe,
//                               style: smallerTextStyle),
//                           onChanged: (bool? value) {
//                             authController.rememberOrNot.value = value!;
//                             authController.update();
//                           },
//                         ),
//                         smallerSizedBox,
//                         Obx(() => AppWidget.elevatedButton(
//                             loading: authController.isLoading.value,
//                             text: AppStrings.signIn,
//                             onTap: () async {
//                               if (_formkey.currentState!.validate()) {
//                                 await authController.loginApiCall();
//                               }
//                             })),
//                         smallerSizedBox,
//                         Align(
//                             alignment: Alignment.centerRight,
//                             child: GestureDetector(
//                               onTap: () =>
//                                   Get.toNamed(RouteHelper.forgotPassword),
//                               child: Text(
//                                 AppStrings.forgotPass,
//                                 style: smallerTextStyleOrangeText,
//                               ),
//                             )),
//                         smallerSizedBox,
//                         Row(
//                           children: [
//                             Expanded(
//                                 child: Divider(
//                               color: ColorConstant.lightOrange,
//                               thickness: 1,
//                             )),
//                             Container(
//                               width: 15.w,
//                               height: 4.h,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border:
//                                       Border.all(color: ColorConstant.lightOrange)),
//                               child: Text(' OR ',
//                                   style: smallerTextStyleOrangeText),
//                             ),
//                             Expanded(
//                                 child: Divider(
//                               color: ColorConstant.lightOrange,
//                               thickness: 1,
//                             )),
//                           ],
//                         ),
//                         mediumSizedBox,
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: List.generate(
//                               socialMedia.length,
//                               (index) => GestureDetector(
//                                 onTap: () async {
//                                   if (index == 0) {
//                                     authController.isGoogle.value = 'Google';
//                                     authController.update();
//                                     socialLoginController.signInWithGoogle();
//                                   } else {
//                                     authController.isGoogle.value = 'Facebook';
//                                     authController.update();
//                                     socialLoginController.signInWithFacebook();
//                                     // final LoginResult result = await FacebookAuth
//                                     //     .instance
//                                     //     .login(permissions: ['email']);
//                                     // if (result.status == LoginStatus.success) {
//                                     //   final userInfo = await FacebookAuth.instance
//                                     //       .getUserData();
//                                     //   print("userData ${userInfo["email"]}");
//                                     // }
//                                   }
//                                 },
//                                 child: Container(
//                                   width: 15.w,
//                                   height: 6.h,
//                                   padding: paddingAll(paddingAll: 2.w),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           spreadRadius: 2,
//                                           blurRadius: 2,
//                                           offset: Offset(2,
//                                               1), // changes position of shadow
//                                         ),
//                                       ],
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                           color: Colors.grey.shade300)),
//                                   child: Image.asset(
//                                       socialMedia[index].toString(),
//                                       alignment: Alignment.center),
//                                 ),
//                               ),
//                             )),
//                         mediumSizedBox,
//                         AppWidget.richText(
//                             text1: AppStrings.notHaveAccount,
//                             text2: AppStrings.signUp,
//                             onTap: () => Get.toNamed(RouteHelper.signUpPage))
//                       ],
//                     ),
//                   )),
//             ),
//             if (authController.isLoadingForSocial.value == true)
//               AppWidget.progressIndicator()
//           ]),
//         )));
//   }
// }
