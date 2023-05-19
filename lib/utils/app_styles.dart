// import 'package:bondio/responsive.dart';
// import 'package:bondio/utils/all_colors.dart';
// import 'package:bondio/utils/utils.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// EdgeInsets paddingAll({required double paddingAll}) =>
//     EdgeInsets.all(paddingAll);
//
// EdgeInsets paddingSymmetric(
//         {required double horizontalPad, required double verticalPad}) =>
//     EdgeInsets.symmetric(horizontal: horizontalPad, vertical: verticalPad);
//
// TextStyle smallerTextStyle = TextStyle(
//     fontFamily: 'Poppins', fontSize: 12.sp, color: Colors.grey.shade600);
//
// TextStyle smallTextStyleGreyText = TextStyle(
//     fontFamily: 'Poppins', fontSize: 14.sp, color: Colors.grey.shade600);
//
// TextStyle smallerTextStyleOrangeText = TextStyle(
//     fontFamily: 'Poppins',
//     fontSize: 12.sp,
//     color: ColorConstant.backGroundColorOrange);
//
// TextStyle smallTextStyleOrangeText = TextStyle(
//     fontFamily: 'Poppins',
//     fontSize: 14.sp,
//     color: ColorConstant.backGroundColorOrange);
//
// TextStyle smallTextStyleWhiteText =
//     TextStyle(fontFamily: 'Poppins', fontSize: 14.sp, color: Colors.white);
//
// TextStyle mediumTextStyleWhiteText =
//     TextStyle(fontFamily: 'Poppins', fontSize: 16.sp, color: Colors.white);
//
// TextStyle headerTextStyleBlack = TextStyle(
//     fontFamily: 'Poppins-Bold',
//     fontSize: 16.sp,
//     color: Colors.black,
//     fontWeight: FontWeight.w500);
//
// TextStyle headerTextStyleWhite = TextStyle(
//     fontFamily: 'Poppins-Bold',
//     fontSize: 22.sp,
//     color: Colors.white,
//     fontWeight: FontWeight.w500);
//
// TextStyle largeTextStyle =
//     TextStyle(fontFamily: 'Poppins', fontSize: 24.sp, color: Colors.white);
//
// smallerSizedBox(BuildContext context) {
//   return SizedBox(height: displayHeight(context) * .01);
// }
//
// smallSizedBox(BuildContext context) {
//   return SizedBox(height: displayHeight(context) * .02);
// }
//
// mediumSizedBox(BuildContext context) {
//   return SizedBox(height: displayHeight(context) * .04);
// }
//
// largeSizedBox(BuildContext context) {
//   return SizedBox(height: displayHeight(context) * .08);
// }
//
// LinearGradient linearGradientColor = LinearGradient(colors: [
//   ColorConstant.backGroundColorOrange,
//   ColorConstant.backGroundColorLightPink,
//   ColorConstant.backGroundColorDarkPurple,
// ], begin: Alignment.bottomLeft, end: Alignment.topRight);
//
// class AppWidget {
//   static textFormFiled({
//     String? hintText,
//     IconData? icon,
//     TextInputAction? textInputAction,
//     TextInputType? textInputType,
//     bool? obscureText,
//     void Function()? suffixOnTap,
//     void Function()? onTapReadOnly,
//     TextStyle? textStyle,
//     bool? readOnly,
//     TextEditingController? textEditingController,
//   }) =>
//       TextFormField(
//         textInputAction: textInputAction ?? TextInputAction.next,
//         keyboardType: textInputType ?? TextInputType.text,
//         obscureText: obscureText ?? false,
//         readOnly: readOnly ?? false,
//         onTap: onTapReadOnly,
//         controller: textEditingController,
//         decoration: InputDecoration(
//           hintText: hintText,
//           hintStyle: textStyle ?? smallTextStyleGreyText,
//           labelStyle: textStyle ?? smallTextStyleGreyText,
//           suffixIcon: IconButton(
//             onPressed: suffixOnTap,
//             icon: Icon(icon, color: Color(0xffFFB574)),
//           ),
//           enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: ColorConstant.backGroundColorOrange)),
//           focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: ColorConstant.backGroundColorOrange)),
//         ),
//         cursorColor: ColorConstant.backGroundColorOrange,
//       );
//
//   static elevatedButton(
//           {required String text,
//           required void Function()? onTap,
//           required BuildContext context}) =>
//       GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: displayWidth(context),
//           height: orientation(context) == Orientation.portrait
//               ? displayHeight(context) * .06
//               : displayHeight(context) * .12,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(displayWidth(context) * .12),
//               gradient: LinearGradient(colors: [
//                 ColorConstant.backGroundColorLightPink,
//                 ColorConstant.backGroundColorOrange,
//               ])),
//           child: Text(
//             text,
//             style: smallTextStyleWhiteText,
//           ),
//         ),
//       );
//
//   static richText(
//           {required String text1,
//           required String text2,
//           void Function()? onTap}) =>
//       GestureDetector(
//         onTap: onTap,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             RichText(
//               text: TextSpan(
//                   style: smallTextStyleOrangeText,
//                   text: text1,
//                   children: [
//                     TextSpan(text: text2, style: smallTextStyleGreyText)
//                   ]),
//             )
//           ],
//         ),
//       );
//
//   static bihPolygon({required BuildContext context}) => Container(
//         padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 0.0),
//         height: 38.h,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//             image: DecorationImage(
//           image: AssetImage(
//             AppAssets.bigPolygon,
//           ),
//           fit: BoxFit.fill,
//         )),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               AppAssets.bondioText,
//               width: 50.w,
//             ),
//            mediumSizedBox
//           ],
//         ),
//       );
// }
import 'package:bondio/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

EdgeInsets paddingAll({required double paddingAll}) =>
    EdgeInsets.all(paddingAll);

EdgeInsets paddingSymmetric({double? horizontalPad, double? verticalPad}) =>
    EdgeInsets.symmetric(
        horizontal: horizontalPad ?? 00, vertical: verticalPad ?? 00);

// TextStyle smallerTextStyle = TextStyle(
//     fontFamily: 'Poppins', fontSize: 10.sp, color: Colors.grey.shade600);
//
// TextStyle smallTextStyleGreyText = TextStyle(
//     fontFamily: 'Poppins', fontSize: 12.sp, color: Colors.grey.shade600);
//
// TextStyle smallerTextStyleOrangeText = TextStyle(
//     fontFamily: 'Poppins',
//     fontSize: 10.sp,
//     color: ColorConstant.backGroundColorOrange);
//
// TextStyle smallTextStyleOrangeText = TextStyle(
//     fontFamily: 'Poppins',
//     fontSize: 12.sp,
//     color: ColorConstant.backGroundColorOrange);
//
// TextStyle smallTextStyleWhiteText =
//     TextStyle(fontFamily: 'Poppins', fontSize: 12.sp, color: Colors.white);
//
// TextStyle mediumTextStyleWhiteText =
//     TextStyle(fontFamily: 'Poppins', fontSize: 14.sp, color: Colors.white);
//
// TextStyle headerTextStyleBlack = TextStyle(
//     fontFamily: 'Poppins-Bold',
//     fontSize: 14.sp,
//     color: Colors.black,
//     fontWeight: FontWeight.w500);
//
// TextStyle headerTextStyleWhite = TextStyle(
//     fontFamily: 'Poppins-Bold',
//     fontSize: 22.sp,
//     color: Colors.white,
//     fontWeight: FontWeight.w500);
//
// TextStyle titleTextStyleWhite = TextStyle(
//     fontFamily: 'Poppins-Bold',
//     fontSize: 12.sp,
//     color: Colors.black,
//     fontWeight: FontWeight.w500);
//
// TextStyle largeTextStyle =
//     TextStyle(fontFamily: 'Poppins', fontSize: 22.sp, color: Colors.white);

SizedBox smallerSizedBox = SizedBox(height: 1.h);
SizedBox smallSizedBox = SizedBox(height: 2.h);
SizedBox mediumSizedBox = SizedBox(height: 4.h);
SizedBox largeSizedBox = SizedBox(height: 8.h);

LinearGradient linearGradientColor = LinearGradient(colors: [
  ColorConstant.backGroundColorOrange,
  ColorConstant.backGroundColorLightPink,
  ColorConstant.backGroundColorDarkPurple,
], begin: Alignment.bottomLeft, end: Alignment.topRight);

LinearGradient drawerLinearColor = LinearGradient(colors: [
  ColorConstant.drawerColor1,
  ColorConstant.drawerColor2,
], begin: Alignment.topCenter, end: Alignment.bottomCenter);

class AppStyles {
  static TextStyle smallerTextStyle = TextStyle(
      fontSize: 10.sp, fontFamily: 'Exo2-Regular', color: Colors.white);

  static TextStyle smallTextStyle = TextStyle(
      fontSize: 12.sp, fontFamily: 'Exo2-Regular', color: Colors.white);

  static TextStyle mediumTextStyle = TextStyle(
      fontSize: 14.sp, fontFamily: 'Exo2-Regular', color: Colors.white);

  static TextStyle largeTextStyle = TextStyle(
      fontSize: 16.sp, fontFamily: 'Exo2-Regular', color: Colors.white);

  static TextStyle extraLargeTextStyle = TextStyle(
      fontSize: 18.sp, fontFamily: 'Exo2-Regular', color: Colors.white);
}
