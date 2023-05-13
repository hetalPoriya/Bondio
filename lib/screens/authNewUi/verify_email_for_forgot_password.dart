// import 'package:bondio/route_helper/route_helper.dart';
// import 'package:bondio/utils/all_classes/bigPolygon_background.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:bondio/utils/utils.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// class VerifyEmailForForgotPass extends StatelessWidget {
//   const VerifyEmailForForgotPass({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BigPolygonBackground(
//         widget: Padding(
//       padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 0.h),
//       child: Column(children: [
//         mediumSizedBox,
//         Text(AppStrings.verifyYourAccount, style: headerTextStyleBlack),
//         smallerSizedBox,
//         Text(AppStrings.sixDigitCodeDes,
//             style: smallerTextStyle, textAlign: TextAlign.center),
//         largeSizedBox,
//         OtpTextField(
//           numberOfFields: 6,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           fieldWidth: 12.w,
//           cursorColor: ColorConstant.lightOrange,
//           focusedBorderColor: ColorConstant.backGroundColorOrange,
//           enabledBorderColor: Colors.orange.shade100,
//           //set to true to show as box or false to show as dash
//           showFieldAsBox: true,
//           //runs when a code is typed in
//           onCodeChanged: (String code) {
//             //handle validation or checks here
//           },
//           //runs when every textfield is filled
//           onSubmit: (String verificationCode) {
//             showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: const Text("Verification Code"),
//                     content: Text('Code entered is $verificationCode'),
//                   );
//                 });
//           }, // end onSubmit
//         ),
//         largeSizedBox,
//         Padding(
//           padding: paddingSymmetric(
//             horizontalPad: 3.w,
//             verticalPad: 0.0,
//           ),
//           child: AppWidget.elevatedButton(
//               text: AppStrings.verify,
//               onTap: () => Get.toNamed(RouteHelper.newPassword)),
//         ),
//         smallSizedBox,
//       ]),
//     ));
//   }
// }
