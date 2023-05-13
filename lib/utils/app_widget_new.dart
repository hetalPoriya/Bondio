// import 'dart:developer';
//
// import 'package:bondio/controller/auth_controller.dart';
// import 'package:bondio/utils/app_assets.dart';
// import 'package:bondio/utils/utils.dart';
// import 'package:csc_picker/csc_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:sizer/sizer.dart';
// import '../route_helper/route_helper.dart';
//
// class AppWidgetForNewUi {
//   static AuthController authController = Get.put(AuthController());
//
//   static Gradient linearColor = LinearGradient(
//       colors: ColorConstant.gradientColor,
//       begin: Alignment.centerLeft,
//       end: Alignment.bottomRight);
//
//   static textFormFiled(
//           {String? hintText,
//           IconData? icon,
//           TextInputAction? textInputAction,
//           TextInputType? textInputType,
//           bool? obscureText,
//           void Function()? suffixOnTap,
//           void Function()? onTapReadOnly,
//           TextStyle? textStyle,
//           bool? readOnly,
//           bool isIconVisible = false,
//           TextEditingController? textEditingController,
//           String? Function(String?)? validator}) =>
//       TextFormField(
//         style: AppStyles.smallTextStyle.copyWith(color: Colors.white),
//         textInputAction: textInputAction ?? TextInputAction.next,
//         keyboardType: textInputType ?? TextInputType.text,
//         obscureText: obscureText ?? false,
//         readOnly: readOnly ?? false,
//         onTap: onTapReadOnly,
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         controller: textEditingController,
//         validator: validator,
//         decoration: InputDecoration(
//           hintText: hintText,
//           hintStyle: textStyle ??
//               AppStyles.smallTextStyle.copyWith(color: Colors.white),
//           labelStyle: textStyle ??
//               AppStyles.smallTextStyle.copyWith(color: Colors.white),
//           errorStyle: textStyle ??
//               AppStyles.smallTextStyle
//                   .copyWith(color: Colors.white, fontSize: 10.sp),
//           suffixIcon: Visibility(
//             visible: isIconVisible,
//             child: GestureDetector(
//               onTap: suffixOnTap,
//               child: Icon(icon, color: Colors.white),
//             ),
//           ),
//           contentPadding: paddingAll(paddingAll: 4.w),
//           enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(3.w),
//               borderSide: BorderSide(color: Colors.white),
//               gapPadding: 00),
//           focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(3.w),
//               borderSide: BorderSide(color: Colors.white),
//               gapPadding: 00),
//           errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(3.w),
//               borderSide: BorderSide(color: Colors.white),
//               gapPadding: 00),
//           focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(3.w),
//               borderSide: BorderSide(color: Colors.white),
//               gapPadding: 00),
//         ),
//         cursorColor: Colors.white,
//       );
//
//   static elevatedButton({
//     Color? color,
//     required String text,
//     required void Function()? onTap,
//     required bool loading,
//   }) =>
//       GestureDetector(
//         onTap: onTap,
//         child: Container(
//           margin: paddingSymmetric(horizontalPad: 10.w),
//           width: 100.w,
//           height: 6.h,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4.w), color: Colors.white),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 text,
//                 style: AppStyles.mediumTextStyle
//                     .copyWith(color: ColorConstant.mainAppColorNew),
//               ),
//               Visibility(
//                   visible: loading,
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: 4.w,
//                       ),
//                       progressIndicator()
//                     ],
//                   )),
//             ],
//           ),
//         ),
//       );
//
//   static progressIndicator({Color? color}) => Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(
//             color ?? ColorConstant.mainAppColorNew,
//
//             //<-- SEE HERE
//           ),
//         ),
//       );
//
//   static openCalendar(BuildContext context) async {
//     AuthController authController = Get.put(AuthController());
//     authController.pickedDate.value = (await showDatePicker(
//         initialDate: DateTime.now(),
//         firstDate: DateTime(1950),
//         lastDate: DateTime(2100),
//         keyboardType: TextInputType.phone,
//         initialEntryMode: DatePickerEntryMode.input,
//         selectableDayPredicate: (day) => day.isBefore(DateTime.now()),
//         context: context,
//         builder: (context, child) {
//           return Theme(
//               data: Theme.of(context).copyWith(
//                 colorScheme: ColorScheme.light(
//                   primary: ColorConstant.mainAppColorNew, // <-- SEE HERE
//                   onPrimary: Colors.white, // <-- SEE HERE
//                   onSurface: Colors.black, // <-- SEE HERE
//                 ),
//               ),
//               child: child!);
//         }))!;
//
//     if (authController.pickedDate.value != null) {
//       log(authController.pickedDate.value
//           .toString()); //pickedDate output format => 2021-03-10 00:00:00.000
//
//       authController.dobController.value.text =
//           DateFormat('yyyy-MM-dd').format(authController.pickedDate.value);
//
//       log(authController.dobController.value.text);
//       authController.update();
//       //formatted date output using intl package =>  2021-03-16
//     } else {
//       log('error');
//     }
//   }
//
//   static toast({required String text}) => Fluttertoast.showToast(
//       msg: text,
//       backgroundColor: Colors.white,
//       textColor: ColorConstant.mainAppColorNew);
//
//   static textFormFiledProfilePage(
//           {String? hintText,
//           IconData? icon,
//           TextInputAction? textInputAction,
//           TextInputType? textInputType,
//           bool? obscureText,
//           void Function()? suffixOnTap,
//           void Function()? onTapReadOnly,
//           TextStyle? textStyle,
//           bool? readOnly,
//           TextEditingController? textEditingController,
//           String? Function(String?)? validator}) =>
//       TextFormField(
//         textInputAction: textInputAction ?? TextInputAction.next,
//         keyboardType: textInputType ?? TextInputType.text,
//         obscureText: obscureText ?? false,
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         readOnly: readOnly ?? false,
//         onTap: onTapReadOnly,
//         controller: textEditingController,
//         validator: validator,
//         decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: textStyle ?? AppStyles.smallTextStyle,
//             labelStyle: textStyle ?? AppStyles.smallTextStyle,
//             contentPadding: paddingAll(paddingAll: 3.w),
//             labelText: hintText,
//             suffixIcon: GestureDetector(
//               onTap: suffixOnTap,
//               child: Icon(icon, color: const Color(0xffFFB574)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white),
//             ),
//             border: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white),
//             )),
//         cursorColor: Colors.white,
//       );
//
//   static bondioTextAndMenu(
//           {VoidCallback? onTapOnMenu, required BuildContext context}) =>
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Image.asset(
//             AppAssets.bondioText,
//             width: 30.w,
//             height: 5.h,
//             color: Colors.white,
//           ),
//           GestureDetector(
//             onTap: () => Scaffold.of(context).openDrawer(),
//             child: Image.asset(
//               AppAssets.menu,
//               width: 10.w,
//               height: 3.h,
//               color: ColorConstant.mainAppColorNew,
//             ),
//           ),
//         ],
//       );
//
//   static List<DrawerText> drawerText = [
//     DrawerText(text: 'Events / Party', routeString: ''),
//     DrawerText(text: 'Privacy', routeString: ''),
//     DrawerText(text: 'Help & Support', routeString: ''),
//     DrawerText(text: 'About Us', routeString: ''),
//     DrawerText(text: 'Sign Out', routeString: ''),
//   ];
//
//   static drawerWidget() => Drawer(
//       width: 80.w,
//       child: Container(
//         decoration: BoxDecoration(color: Colors.white),
//         child: ListView(children: [
//           Padding(
//             padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 00),
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   smallerSizedBox,
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: GestureDetector(
//                         onTap: () => Get.back(),
//                         child: const Icon(Icons.close, color: Colors.white)),
//                   ),
//                   const CircleAvatar(
//                     minRadius: 12,
//                     maxRadius: 50,
//                   ),
//                   smallerSizedBox,
//                   Padding(
//                     padding:
//                         paddingSymmetric(horizontalPad: 1.w, verticalPad: 00),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           authController.userInfo.value.user?.name.toString() ??
//                               '',
//                           style: AppStyles.mediumTextStyle,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Get.back();
//                             Get.toNamed(RouteHelper.profilePage);
//                           },
//                           child: Container(
//                             padding: paddingAll(paddingAll: 1.w),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(2.w),
//                               color: const Color(0xffE42F3B),
//                             ),
//                             child: const Icon(Icons.edit, color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ]),
//           ),
//           smallerSizedBox,
//           Container(
//             color: const Color(0xffF0747F),
//             height: 4.h,
//           ),
//           mediumSizedBox,
//           ListView.builder(
//               itemCount: drawerText.length,
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemBuilder: ((context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     if (drawerText[index].text == 'About Us') {
//                       Get.back();
//                       Get.toNamed(RouteHelper.aboutUs);
//                     }
//                     if (index == drawerText.length - 1) {
//                       Get.back();
//                       _showSignOutDialog();
//                     }
//                   },
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(left: 10.w),
//                         child: Text(drawerText[index].text.toString(),
//                             style: AppStyles.mediumTextStyle),
//                       ),
//                       smallerSizedBox,
//                       Padding(
//                         padding: EdgeInsets.only(right: 15.w),
//                         child: const Divider(color: Colors.white),
//                       ),
//                       smallerSizedBox,
//                     ],
//                   ),
//                 );
//               })),
//           largeSizedBox,
//           mediumSizedBox,
//           SizedBox(
//             height: 10.h,
//             child: Image.asset(
//               AppAssets.bondioText,
//             ),
//           ),
//           largeSizedBox,
//         ]),
//       ));
//
//   static _showSignOutDialog() {
//     AuthController authController = Get.put(AuthController());
//     return Get.defaultDialog(
//         title: 'Alert!!',
//         titleStyle: AppStyles.largeTextStyle,
//         content: Padding(
//           padding: paddingSymmetric(horizontalPad: 8.w, verticalPad: 00),
//           child: Text(
//             'Are you sure you want to sign out?',
//             textAlign: TextAlign.center,
//             style: AppStyles.smallTextStyle,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 00),
//             child: AppWidget.elevatedButton(
//                 text: 'No', onTap: () => Get.back(), loading: false),
//           ),
//           Padding(
//             padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 00),
//             child: AppWidget.elevatedButton(
//                 text: 'Yes',
//                 onTap: () async {
//                   Get.back();
//                   // await SocialLoginController.googleLogOut();
//                   await authController.logOutApiCall();
//                 },
//                 loading: false),
//           ),
//         ]);
//   }
//
//   static cscPiker({required AuthController authController}) =>
//       Obx(() => CSCPicker(
//             showCities: true,
//             showStates: true,
//             layout: Layout.vertical,
//             currentCity: authController.cityValue.value.isNotEmpty
//                 ? authController.cityValue.value
//                 : 'Select City',
//             currentCountry: authController.countryValue.value.isNotEmpty
//                 ? authController.countryValue.value
//                 : 'Select Country',
//             currentState: authController.stateValue.value.isNotEmpty
//                 ? authController.stateValue.value
//                 : 'Select State',
//             cityDropdownLabel: 'Select City',
//             countryDropdownLabel: 'Select Country',
//             stateDropdownLabel: 'Select State',
//
//             // cityDropdownLabel: authController.cityValue.value,
//             // countryDropdownLabel: authController.countryValue.value,
//             // stateDropdownLabel: authController.stateValue.value,
//             dropdownHeadingStyle: AppStyles.smallTextStyle,
//             dropdownItemStyle: AppStyles.smallTextStyle,
//             selectedItemStyle: AppStyles.smallTextStyle,
//             dropdownDecoration: BoxDecoration(
//                 border: Border(bottom: BorderSide(color: Colors.white))),
//             disabledDropdownDecoration: BoxDecoration(
//                 border: Border(bottom: BorderSide(color: Colors.grey))),
//             onCountryChanged: (value) {
//               authController.countryValue.value = value;
//               // SharedPrefClass.setString(SharedPrefStrings.userCountry, value);
//               authController.update();
//             },
//             onStateChanged: (value) {
//               authController.stateValue.value = value.toString();
//               // SharedPrefClass.setString(
//               //     SharedPrefStrings.userState, value.toString());
//               authController.update();
//             },
//             onCityChanged: (value) {
//               authController.cityValue.value = value.toString();
//               // SharedPrefClass.setString(
//               //     SharedPrefStrings.userCity, value.toString());
//               authController.update();
//             },
//           ));
//
//   static appbar({required String text, Widget? widget}) => AppBar(
//         centerTitle: true,
//         title: Text(
//           text,
//           style: AppStyles.mediumTextStyle.copyWith(color: Colors.white),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         actions: [
//           widget ?? Container(),
//         ],
//         leading: widget != null
//             ? Container()
//             : IconButton(
//                 padding: EdgeInsets.only(left: 8.w),
//                 onPressed: () => Get.back(),
//                 icon: Icon(Icons.arrow_back_ios)),
//       );
// }
//
// class DrawerText {
//   String? text;
//   String? routeString;
//
//   DrawerText({this.text, this.routeString});
// }
