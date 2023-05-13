// import 'package:bondio/route_helper/route_helper.dart';
// import 'package:bondio/utils/utils.dart';
// import 'package:bondio/utils/all_classes/bigPolygon_background.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// class NewPassword extends StatefulWidget {
//   const NewPassword({Key? key}) : super(key: key);
//
//   @override
//   State<NewPassword> createState() => _NewPasswordState();
// }
//
// class _NewPasswordState extends State<NewPassword> {
//   //controller
//   TextEditingController email = TextEditingController();
//
//   //controller
//   TextEditingController pass = TextEditingController();
//   TextEditingController conPass = TextEditingController();
//
//   //for password
//   bool obscure = true;
//   bool obscureForConPass = true;
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
//               AppStrings.enterNewPass,
//               style: headerTextStyleBlack,
//             ),
//             smallerSizedBox,
//             Text(AppStrings.newPassDec,
//                 style: smallerTextStyle, textAlign: TextAlign.center),
//             mediumSizedBox,
//             AppWidget.textFormFiled(
//                 textEditingController: pass,
//                 hintText: AppStrings.password,
//                 obscureText: obscure,
//                 textInputType: TextInputType.text,
//                 textInputAction: TextInputAction.next,
//                 icon: obscure
//                     ? Icons.remove_red_eye
//                     : Icons.remove_red_eye_outlined,
//                 suffixOnTap: () {
//                   setState(() {
//                     obscure = !obscure;
//                   });
//                 }),
//             smallerSizedBox,
//             AppWidget.textFormFiled(
//                 textEditingController: conPass,
//                 hintText: AppStrings.confirmPass,
//                 obscureText: obscureForConPass,
//                 textInputType: TextInputType.text,
//                 icon: obscureForConPass
//                     ? Icons.remove_red_eye
//                     : Icons.remove_red_eye_outlined,
//                 suffixOnTap: () {
//                   setState(() {
//                     obscureForConPass = !obscureForConPass;
//                   });
//                 }),
//             largeSizedBox,
//             AppWidget.elevatedButton(
//                 text: AppStrings.submit,
//                 onTap: () => Get.toNamed(RouteHelper.loginPage)),
//             mediumSizedBox,
//           ],
//         ),
//       ),
//     ));
//   }
// }
