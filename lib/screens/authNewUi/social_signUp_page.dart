// import 'package:bondio/controller/controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// class SocialSignUpPage extends StatefulWidget {
//   const SocialSignUpPage({Key? key}) : super(key: key);
//
//   @override
//   State<SocialSignUpPage> createState() => _SocialSignUpPageState();
// }
//
// class _SocialSignUpPageState extends State<SocialSignUpPage> {
//   AuthController authController = Get.put(AuthController());
//
//   final _formkey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: ListView(
//           children: [
//             Container(
//               padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 0.h),
//               height: 34.h,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                 image: AssetImage(
//                   AppAssets.smallPolygon,
//                 ),
//                 fit: BoxFit.fill,
//               )),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   smallerSizedBox,
//                   AppWidget.backIcon(onTap: () => Get.back()),
//                   Text(AppStrings.createAccount,
//                       style:
//                           largeTextStyle.copyWith(fontFamily: 'Poppins-Bold'),
//                       textAlign: TextAlign.center),
//                   largeSizedBox,
//                   mediumSizedBox
//                 ],
//               ),
//             ),
//             Form(
//                 key: _formkey,
//                 child: Padding(
//                     padding:
//                         paddingSymmetric(horizontalPad: 10.w, verticalPad: 2.h),
//                     child: Obx(
//                       () {
//                         return ListView(
//                           physics: const ClampingScrollPhysics(),
//                           shrinkWrap: true,
//                           children: [
//                             Text('Great, you have logged in via Google',
//                                 style: smallTextStyleGreyText.copyWith(
//                                     fontFamily: 'Poppins-Bold',
//                                     color: Colors.black),
//                                 textAlign: TextAlign.center),
//                             smallSizedBox,
//                             Text(
//                                 'Fill additional details to complete sign up via ${authController.isGoogle}',
//                                 style: smallTextStyleOrangeText.copyWith(
//                                     fontFamily: 'Poppins-Bold'),
//                                 textAlign: TextAlign.center),
//                             mediumSizedBox,
//                             AppWidget.textFormFiledProfilePage(
//                               textEditingController:
//                                   authController.fullNameController.value,
//                               hintText: AppStrings.fullName,
//                               validator: FormValidation.emptyValidation(
//                                   value: authController
//                                       .fullNameController.value.text),
//                               // icon: Icons.person_outline,
//                             ),
//                             SizedBox(height: 3.h),
//                             AppWidget.textFormFiledProfilePage(
//                                 textEditingController:
//                                     authController.emailController.value,
//                                 hintText: AppStrings.emailAddress,
//                                 validator: FormValidation.emailValidation(
//                                     value: authController
//                                         .emailController.value.text),
//                                 textInputType: TextInputType.emailAddress),
//                             SizedBox(height: 3.h),
//                             AppWidget.textFormFiledProfilePage(
//                                 textEditingController:
//                                     authController.mobileController.value,
//                                 hintText: AppStrings.mobileNumber,
//                                 validator:
//                                     FormValidation.mobileNumberValidation(
//                                         value: authController
//                                             .mobileController.value.text),
//                                 textInputType: TextInputType.number,
//                                 textInputAction: TextInputAction.done),
//                             largeSizedBox,
//                             AppWidget.elevatedButton(
//                                 loading: authController.isLoading.value,
//                                 text: AppStrings.signUp,
//                                 onTap: () async {
//                                   if (_formkey.currentState!.validate()) {
//                                     await authController.userExistOrNotApi();
//                                   }
//                                 }),
//                             smallSizedBox,
//                           ],
//                         );
//                       },
//                     )))
//           ],
//         ),
//       ),
//     );
//   }
// }
