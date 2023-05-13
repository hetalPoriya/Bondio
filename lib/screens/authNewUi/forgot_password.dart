// import 'package:bondio/route_helper/route_helper.dart';
// import 'package:bondio/utils/all_classes/bigPolygon_background.dart';
// import 'package:bondio/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// class ForgotPassword extends StatelessWidget {
//   ForgotPassword({Key? key}) : super(key: key);
//
//   //controller
//   TextEditingController email = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return BigPolygonBackground(
//         widget: Form(
//       child: Padding(
//         padding: paddingSymmetric(horizontalPad: 8.w, verticalPad: 0.h),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             mediumSizedBox,
//             Text(
//               AppStrings.forgotPassword,
//               style: headerTextStyleBlack,
//             ),
//             smallerSizedBox,
//             Text(AppStrings.forgotPasswordLink,
//                 style: smallerTextStyle, textAlign: TextAlign.center),
//             largeSizedBox,
//             AppWidget.textFormFiled(
//                 textEditingController: email,
//                 hintText: AppStrings.emailAddress,
//                 icon: Icons.email,
//                 textInputType: TextInputType.emailAddress),
//             largeSizedBox,
//             AppWidget.elevatedButton(
//                 text: AppStrings.submit,
//                 onTap: () => Get.toNamed(RouteHelper.verifyEmailForForgotPass)),
//             mediumSizedBox,
//           ],
//         ),
//       ),
//     ));
//   }
// }
