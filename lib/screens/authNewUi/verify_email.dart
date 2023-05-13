// import 'package:bondio/utils/all_classes/bigPolygon_background.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:bondio/controller/controller.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// class VerifyEmail extends StatelessWidget {
//   VerifyEmail({Key? key}) : super(key: key);
//
//   AuthController authController = Get.put(AuthController());
//
//   @override
//   Widget build(BuildContext context) {
//     return BigPolygonBackground(
//         aboveText: Padding(
//           padding: paddingSymmetric(horizontalPad: 8.w, verticalPad: 0.0),
//           child: Text(AppStrings.checkMail,
//               style: headerTextStyleWhite, textAlign: TextAlign.center),
//         ),
//         widget: Padding(
//           padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 0.h),
//           child: Column(children: [
//             smallerSizedBox,
//             Text(AppStrings.verificationEmail, style: smallTextStyleGreyText),
//             Text(authController.emailController.value.text,
//                 style: smallTextStyleGreyText.copyWith(color: Colors.black)),
//             smallSizedBox,
//             Text(AppStrings.codeExpireString,
//                 style: smallerTextStyle.copyWith(fontSize: 9.sp),
//                 textAlign: TextAlign.center),
//             smallerSizedBox,
//             smallerSizedBox,
//             OtpTextField(
//               numberOfFields: 6,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               fieldWidth: 12.w,
//               cursorColor: ColorConstant.lightOrange,
//               focusedBorderColor: ColorConstant.backGroundColorOrange,
//               enabledBorderColor: Colors.orange.shade100,
//               //set to true to show as box or false to show as dash
//               showFieldAsBox: true,
//               onSubmit: (String verificationCode) {
//                 authController.enterOtpByUser.value = verificationCode;
//                 authController.update();
//               }, // end onSubmit
//             ),
//             smallSizedBox,
//             Obx(
//               () => AppWidget.elevatedButton(
//                   text: AppStrings.verify,
//                   loading: authController.isLoading.value,
//                   onTap: () async {
//                     if (authController.enterOtpByUser.value !=
//                         authController.otpValue.value) {
//                       Fluttertoast.showToast(msg: 'Please enter valid otp');
//                     } else {
//                       await authController.registerApiCall();
//                     }
//                   }),
//             ),
//             //onTap: () => Get.toNamed(RouteHelper.homeScreen)),
//             smallSizedBox,
//             GestureDetector(
//               onTap: () async => await authController.registerOtpApiCall(),
//               child: Text(
//                 AppStrings.resendCode,
//                 style: smallTextStyleOrangeText,
//               ),
//             ),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //   children: [
//             //     Text(
//             //       AppStrings.resendCode,
//             //       style: smallTextStyleOrangeText,
//             //     ),
//             //     Text(
//             //       AppStrings.changeEmail,
//             //       style: smallTextStyleOrangeText,
//             //     )
//             //   ],
//             // ),
//             smallerSizedBox,
//             smallerSizedBox,
//             Divider(color: ColorConstant.lightOrange, thickness: 1),
//             smallSizedBox,
//             GestureDetector(
//               onTap: () => Get.back(),
//               child: Text(
//                 AppStrings.backToPrevious,
//                 style: smallTextStyleOrangeText.copyWith(
//                     color: ColorConstant.lightOrange),
//               ),
//             ),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             //   children: List.generate(
//             //       6,
//             //       (index) => SizedBox(
//             //             height: 60,
//             //             width: 50,
//             //             child: TextField(
//             //               textAlign: TextAlign.center,
//             //               keyboardType: TextInputType.number,
//             //               maxLength: 1,
//             //               cursorColor: Theme.of(context).primaryColor,
//             //               decoration: const InputDecoration(
//             //                   border: OutlineInputBorder(),
//             //                   counterText: '',
//             //                   hintStyle: TextStyle(
//             //                       color: Colors.black, fontSize: 20.0)),
//             //               onChanged: (value) {
//             //                 if (value.length == 1) {
//             //                   FocusScope.of(context).nextFocus();
//             //                 }
//             //               },
//             //             ),
//             //           )),
//             // )
//           ]),
//         ));
//   }
// }
