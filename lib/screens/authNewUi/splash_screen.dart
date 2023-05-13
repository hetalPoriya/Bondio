// import 'dart:async';
//
// import 'package:bondio/route_helper/route_helper.dart';
// import 'package:bondio/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     Timer(const Duration(seconds: 6), () {
//       if (SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) == true) {
//         Get.offNamedUntil(RouteHelper.homeScreen, (route) => false);
//       } else {
//         Get.offAllNamed(RouteHelper.loginPage);
//       }
//     });
//
//     return Scaffold(
//       body: SizedBox(
//           height: double.infinity,
//           width: double.infinity,
//           // //   decoration: BoxDecoration(gradient: linearGradientColor),
//           child: Image.asset(
//             AppAssets.bondioGif,
//             fit: BoxFit.fill,
//           )),
//     );
//   }
// }
// // import 'dart:async';
// //
// // import 'package:bondio/route_helper/route_helper.dart';
// // import 'package:bondio/utils/utils.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:sizer/sizer.dart';
// //
// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }
// //
// // class _SplashScreenState extends State<SplashScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     Timer(const Duration(seconds: 6), () {
// //       if (SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) == true) {
// //         Get.offNamedUntil(RouteHelper.homeScreen, (route) => false);
// //       } else {
// //         Get.offAllNamed(RouteHelper.loginPage);
// //       }
// //     });
// //
// //     return Scaffold(
// //       body: Container(
// //           height: double.infinity,
// //           width: double.infinity,
// //           color: ColorConstant.mainAppColor,
// //           // //   decoration: BoxDecoration(gradient: linearGradientColor),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Image.asset(
// //                 AppAssets.bondioText,
// //                 width: 50.w,
// //               ),
// //             ],
// //           )),
// //     );
// //   }
// // }
