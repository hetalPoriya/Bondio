// import 'dart:developer';
// import 'package:bondio/controller/controller.dart';
// import 'package:bondio/route_helper/route_helper.dart';
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:sizer/sizer.dart';
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);
//
//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   AuthController authController = Get.put(AuthController());
//
//   final _formkey = GlobalKey<FormState>();
//
//   //open calendar
//   _openCalendar() async {
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
//                   primary: ColorConstant.backGroundColorOrange, // <-- SEE HERE
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
//                             AppWidget.textFormFiled(
//                               textEditingController:
//                                   authController.fullNameController.value,
//                               hintText: AppStrings.fullName,
//                               validator: FormValidation.emptyValidation(
//                                   value: authController
//                                       .fullNameController.value.text),
//                               // icon: Icons.person_outline,
//                             ),
//                             smallerSizedBox,
//                             AppWidget.textFormFiled(
//                               textEditingController:
//                                   authController.companyNameController.value,
//                               hintText: AppStrings.companyName,
//                             ),
//                             smallerSizedBox,
//                             Column(
//                               children: [
//                                 AppWidget.textFormFiled(
//                                   textEditingController:
//                                       authController.dobController.value,
//                                   onTapReadOnly: () => _openCalendar(),
//                                   hintText: AppStrings.dob,
//                                   readOnly: true,
//                                 ),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Text(
//                                     'App rewards on birthday',
//                                     style: smallerTextStyle.copyWith(
//                                         fontSize: 8.sp,
//                                         color: ColorConstant.lightOrange),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             // Row(
//                             //   children: [
//                             //     Flexible(
//                             //       child: AppWidget.textFormFiled(
//                             //         textEditingController: dob,
//                             //         onTapReadOnly: () => _openCalendar(),
//                             //         hintText: AppStrings.dob,
//                             //         textStyle: smallerTextStyle,
//                             //         readOnly: true,
//                             //       ),
//                             //     ),
//                             //     SizedBox(
//                             //       width: 3.w,
//                             //     ),
//                             //     Flexible(
//                             //       child: AppWidget.textFormFiled(
//                             //           textEditingController: gender,
//                             //           readOnly: true,
//                             //           onTapReadOnly: () => _showGenderDialog(),
//                             //           hintText: AppStrings.gender,
//                             //           textStyle: smallerTextStyle),
//                             //     )
//                             //   ],
//                             // ),
//                             AppWidget.textFormFiled(
//                                 textEditingController:
//                                     authController.emailController.value,
//                                 hintText: AppStrings.emailAddress,
//                                 validator: FormValidation.emailValidation(
//                                     value: authController
//                                         .emailController.value.text),
//                                 textInputType: TextInputType.emailAddress),
//                             smallerSizedBox,
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Flexible(
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             bottom: BorderSide(
//                                                 color: ColorConstant
//                                                     .backGroundColorOrange))),
//                                     child: CountryCodePicker(
//                                         initialSelection: 'US',
//                                         backgroundColor: Colors.red,
//                                         onChanged: ((value) {
//                                           authController
//                                               .countryCodeController
//                                               .value
//                                               .text = value.dialCode.toString();
//                                           authController.update();
//                                           log('Auth ${authController.countryCodeController.value.text}');
//                                         }),
//                                         padding: paddingSymmetric(
//                                             horizontalPad: 00, verticalPad: 00),
//                                         showDropDownButton: true),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 2.w,
//                                 ),
//                                 Flexible(
//                                   flex: 2,
//                                   child: AppWidget.textFormFiled(
//                                       textEditingController:
//                                           authController.mobileController.value,
//                                       hintText: AppStrings.mobileNumber,
//                                       validator:
//                                           FormValidation.mobileNumberValidation(
//                                               value: authController
//                                                   .mobileController.value.text),
//                                       textInputType: TextInputType.number),
//                                 ),
//                               ],
//                             ),
//
//                             smallerSizedBox,
//                             AppWidget.textFormFiled(
//                               isIconVisible: true,
//                               textEditingController:
//                                   authController.passController.value,
//                               hintText: AppStrings.password,
//                               validator: FormValidation.emptyValidation(
//                                   value:
//                                       authController.passController.value.text),
//                               obscureText: authController.obscure.value,
//                               icon: authController.obscure.value
//                                   ? Icons.remove_red_eye
//                                   : Icons.remove_red_eye_outlined,
//                               suffixOnTap: () {
//                                 setState(() {
//                                   authController.obscure.value =
//                                       !authController.obscure.value;
//                                   authController.update();
//                                 });
//                               },
//                               textInputAction: TextInputAction.next,
//                             ),
//                             smallerSizedBox,
//                             AppWidget.textFormFiled(
//                                 isIconVisible: true,
//                                 textEditingController:
//                                     authController.conPassController.value,
//                                 hintText: AppStrings.confirmPass,
//                                 validator: FormValidation.emptyValidation(
//                                     value: authController
//                                         .conPassController.value.text),
//                                 obscureText:
//                                     authController.obscureForConPass.value,
//                                 textInputAction: TextInputAction.done,
//                                 icon: authController.obscureForConPass.value
//                                     ? Icons.remove_red_eye
//                                     : Icons.remove_red_eye_outlined,
//                                 suffixOnTap: () {
//                                   setState(() {
//                                     authController.obscureForConPass.value =
//                                         !authController.obscureForConPass.value;
//                                     authController.update();
//                                   });
//                                 }),
//
//                             mediumSizedBox,
//                             DottedBorder(
//                               color: ColorConstant.backGroundColorOrange,
//                               radius: Radius.circular(2.w),
//                               borderType: BorderType.RRect,
//                               borderPadding: const EdgeInsets.all(2),
//                               padding: EdgeInsets.zero,
//                               child: TextFormField(
//                                 cursorColor:
//                                     ColorConstant.backGroundColorOrange,
//                                 controller:
//                                     authController.referCodeController.value,
//                                 textInputAction: TextInputAction.done,
//                                 keyboardType: TextInputType.text,
//                                 decoration: InputDecoration(
//                                   hintStyle: smallTextStyleGreyText.copyWith(
//                                       fontWeight: FontWeight.w800,
//                                       decorationStyle:
//                                           TextDecorationStyle.dotted),
//                                   labelStyle: smallTextStyleGreyText,
//                                   contentPadding: paddingAll(paddingAll: 2.w),
//                                   hintText: AppStrings.inviteCode,
//                                   enabledBorder: InputBorder.none,
//                                   focusedBorder: InputBorder.none,
//                                   // enabledBorder: OutlineInputBorder(
//                                   //     borderRadius: BorderRadius.circular(2.w),
//                                   //     borderSide: BorderSide(
//                                   //       color: ColorConstant.w,
//                                   //     )),
//                                   //     gapPadding: 4
//                                   //     // borderSide:
//                                   //     //     BorderSide(color: ColorConstant.lightOrange)
//                                   //     ),
//                                 ),
//                               ),
//                             ),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Text(
//                                 'Optional',
//                                 style: smallerTextStyle.copyWith(
//                                     fontSize: 8.sp,
//                                     color: ColorConstant.lightOrange),
//                               ),
//                             ),
//                             smallerSizedBox,
//                             smallerSizedBox,
//                             Row(
//                               children: [
//                                 Checkbox(
//                                     value: authController.agree.value,
//                                     activeColor:
//                                         ColorConstant.backGroundColorOrange,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         authController.agree.value =
//                                             !authController.agree.value;
//                                         authController.update();
//                                       });
//                                     }),
//                                 Flexible(
//                                   child: RichText(
//                                       text: TextSpan(
//                                           style: smallerTextStyle,
//                                           text: 'I agree to the ',
//                                           children: [
//                                         TextSpan(
//                                             style: smallerTextStyleOrangeText,
//                                             text: 'Terms of services '),
//                                         TextSpan(
//                                             style: smallerTextStyle,
//                                             text: 'and '),
//                                         TextSpan(
//                                             style: smallerTextStyleOrangeText,
//                                             text: 'Privacy policy '),
//                                       ])),
//                                 )
//                               ],
//                             ),
//                             smallerSizedBox,
//                             smallerSizedBox,
//                             AppWidget.elevatedButton(
//                                 progressColor: Colors.white,
//                                 loading: authController.isLoading.value,
//                                 text: AppStrings.signUp,
//                                 onTap: () async {
//                                   log('CountryCOde ${authController.countryCodeController.value.text}');
//                                   if (_formkey.currentState!.validate()) {
//                                     if (authController
//                                             .passController.value.text !=
//                                         authController
//                                             .conPassController.value.text) {
//                                       Fluttertoast.showToast(
//                                           msg: 'Password not match');
//                                     } else {
//                                       log('REFRE ${authController.referCodeController.value.text}');
//
//                                       await authController.registerOtpApiCall();
//                                     }
//                                   }
//                                 }),
//                             smallerSizedBox,
//                             AppWidget.richText(
//                                 text1: AppStrings.alreadyMember,
//                                 text2: AppStrings.submit,
//                                 onTap: () => Get.offNamedUntil(
//                                     RouteHelper.loginPage, (route) => false))
//                           ],
//                         );
//                       },
//                     )))
//           ],
//         ),
//       ),
//     );
//   }
//
// // _showGenderDialog() {
// //   return showDialog(
// //       context: context,
// //       builder: ((context) {
// //         return AlertDialog(
// //           title: Text('Select Your Gender',
// //               style: smallTextStyleGreyText.copyWith(
// //                   color: Colors.black, fontSize: 16.sp)),
// //           content: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 GestureDetector(
// //                   onTap: () {
// //                     authController.genderController.value.text = 'Male';
// //                     authController.update();
// //
// //                     Get.back();
// //                   },
// //                   child: Text(
// //                     'Male',
// //                     style: smallTextStyleGreyText.copyWith(
// //                         color: Colors.black, fontSize: 12.sp),
// //                   ),
// //                 ),
// //                 smallerSizedBox,
// //                 smallerSizedBox,
// //                 GestureDetector(
// //                   onTap: () {
// //                     authController.genderController.value.text = 'Female';
// //                     authController.update();
// //                     Get.back();
// //                   },
// //                   child: Text(
// //                     'Female',
// //                     style: smallTextStyleGreyText.copyWith(
// //                         color: Colors.black, fontSize: 12.sp),
// //                   ),
// //                 ),
// //               ]),
// //         );
// //       }));
// // }
// }

import 'dart:developer';
import 'package:bondio/controller/controller.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  AuthController authController = Get.put(AuthController());

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: ColorConstant.linearColor),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: AppWidget.appbar(text: AppStrings.createAccount),
          body: Form(
              key: _formkey,
              child: Obx(
                () {
                  return ListView(
                    padding:
                        paddingSymmetric(horizontalPad: 6.w, verticalPad: 1.h),
                    children: [
                      mediumSizedBox,
                      Text(
                        AppStrings.createAccount,
                        textAlign: TextAlign.center,
                        style: AppStyles.extraLargeTextStyle,
                      ),
                      mediumSizedBox,
                      Text(AppStrings.yourName,
                          style: AppStyles.mediumTextStyle),
                      smallerSizedBox,
                      AppWidget.textFormFiledWhite(
                        textEditingController:
                            authController.fullNameController.value,
                        hintText: AppStrings.firstName,
                        validator: FormValidation.emptyValidation(
                            value:
                                authController.fullNameController.value.text),
                        // icon: Icons.person_outline,
                      ),
                      // smallerSizedBox,
                      // AppWidget.textFormFiledWhite(
                      //   textEditingController:
                      //       authController.lastNameController.value,
                      //   hintText: AppStrings.lastName,
                      //   validator: FormValidation.emptyValidation(
                      //       value:
                      //           authController.lastNameController.value.text),
                      //   // icon: Icons.person_outline,
                      // ),
                      Text(AppStrings.yourMobileNumber,
                          style: AppStyles.mediumTextStyle),
                      smallerSizedBox,

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(3.w)),
                              child: CountryCodePicker(
                                initialSelection: 'US',
                                onChanged: ((value) {
                                  authController.countryCodeController.value
                                      .text = value.dialCode.toString();
                                  authController.update();
                                  log('Auth ${authController.countryCodeController.value.text}');
                                }),
                                textStyle: AppStyles.smallTextStyle
                                    .copyWith(color: Colors.white),
                                padding: paddingSymmetric(
                                    horizontalPad: 00, verticalPad: 2),
                                showDropDownButton: true,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Flexible(
                            flex: 2,
                            child: AppWidget.textFormFiledWhite(
                                textEditingController:
                                    authController.mobileController.value,
                                hintText: AppStrings.mobileNumber,
                                validator:
                                    FormValidation.mobileNumberValidation(
                                        value: authController
                                            .mobileController.value.text),
                                textInputType: TextInputType.number),
                          ),
                        ],
                      ),

                      // Text(
                      //     'Please enter your phone number to find your friends.',
                      //     style:
                      //         smallerTextStyle.copyWith(color: Colors.white)),

                      Text(AppStrings.yourEmailAddress,
                          style: AppStyles.mediumTextStyle),
                      smallerSizedBox,
                      AppWidget.textFormFiledWhite(
                          textEditingController:
                              authController.emailController.value,
                          hintText: AppStrings.emailAddress,
                          validator: FormValidation.emailValidation(
                              value: authController.emailController.value.text),
                          textInputType: TextInputType.emailAddress),
                      smallSizedBox,
                      Text(AppStrings.yourBirthday,
                          style: AppStyles.mediumTextStyle),
                      smallerSizedBox,
                      AppWidget.textFormFiledWhite(
                        textEditingController:
                            authController.dobController.value,
                        onTapReadOnly: () => AppWidget.openCalendar(context),
                        hintText: AppStrings.dob,
                        readOnly: true,
                      ),

                      Text(AppStrings.dobText,
                          style: AppStyles.smallerTextStyle
                              .copyWith(color: Colors.white)),
                      smallSizedBox,

                      Text(AppStrings.yourPassword,
                          style: AppStyles.mediumTextStyle),
                      smallerSizedBox,
                      AppWidget.textFormFiledWhite(
                          hintText: AppStrings.password,
                          validator: FormValidation.passwordValidation(
                              value: authController.passController.value.text),
                          textEditingController:
                              authController.passController.value,
                          obscureText: authController.obscure.value,
                          isIconVisible: true,
                          icon: authController.obscure.value
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                          suffixOnTap: () {
                            authController.obscure.value =
                                !authController.obscure.value;
                            authController.update();
                          },
                          textInputAction: TextInputAction.done),

                      // Text(
                      //     'Please set to be alphanumeric with 8 characters: one uppercase, one special character needed.',
                      //     style: AppStyles.smallerTextStyle
                      //         .copyWith(color: Colors.white)),
                      smallSizedBox,
                      // AppWidget.textFormFiled(
                      //   textEditingController:
                      //   authController.fullNameController.value,
                      //   hintText: AppStrings.fullName,
                      //   validator: FormValidation.emptyValidation(
                      //       value: authController
                      //           .fullNameController.value.text),
                      //   // icon: Icons.person_outline,
                      // ),
                      // smallerSizedBox,
                      // AppWidget.textFormFiled(
                      //   textEditingController:
                      //   authController.companyNameController.value,
                      //   hintText: AppStrings.companyName,
                      // ),
                      // smallerSizedBox,
                      // Column(
                      //   children: [
                      //     AppWidget.textFormFiled(
                      //       textEditingController:
                      //       authController.dobController.value,
                      //       onTapReadOnly: () => _openCalendar(),
                      //       hintText: AppStrings.dob,
                      //       readOnly: true,
                      //     ),
                      //     Align(
                      //       alignment: Alignment.centerRight,
                      //       child: Text(
                      //         'App rewards on birthday',
                      //         style: smallerTextStyle.copyWith(
                      //             fontSize: 8.sp,
                      //             color: ColorConstant.lightOrange),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // // Row(
                      // //   children: [
                      // //     Flexible(
                      // //       child: AppWidget.textFormFiled(
                      // //         textEditingController: dob,
                      // //         onTapReadOnly: () => _openCalendar(),
                      // //         hintText: AppStrings.dob,
                      // //         textStyle: smallerTextStyle,
                      // //         readOnly: true,
                      // //       ),
                      // //     ),
                      // //     SizedBox(
                      // //       width: 3.w,
                      // //     ),
                      // //     Flexible(
                      // //       child: AppWidget.textFormFiled(
                      // //           textEditingController: gender,
                      // //           readOnly: true,
                      // //           onTapReadOnly: () => _showGenderDialog(),
                      // //           hintText: AppStrings.gender,
                      // //           textStyle: smallerTextStyle),
                      // //     )
                      // //   ],
                      // // ),
                      // AppWidget.textFormFiled(
                      //     textEditingController:
                      //     authController.emailController.value,
                      //     hintText: AppStrings.emailAddress,
                      //     validator: FormValidation.emailValidation(
                      //         value: authController
                      //             .emailController.value.text),
                      //     textInputType: TextInputType.emailAddress),
                      // smallerSizedBox,
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment:
                      //   MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Flexible(
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //             border: Border(
                      //                 bottom: BorderSide(
                      //                     color: ColorConstant
                      //                         .backGroundColorOrange))),
                      //         child: CountryCodePicker(
                      //             initialSelection: 'IN',
                      //             onChanged: ((value) {
                      //               authController.countryCodeController
                      //                   .value.text =
                      //                   value.dialCode.toString();
                      //               authController.update();
                      //               log('Auth ${authController
                      //                   .countryCodeController.value
                      //                   .text}');
                      //             }),
                      //             padding: paddingSymmetric(
                      //                 horizontalPad: 00,
                      //                 verticalPad: 2),
                      //             showDropDownButton: true),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 2.w,
                      //     ),
                      //     Flexible(
                      //       flex: 2,
                      //       child: AppWidget.textFormFiled(
                      //           textEditingController: authController
                      //               .mobileController.value,
                      //           hintText: AppStrings.mobileNumber,
                      //           validator: FormValidation
                      //               .mobileNumberValidation(
                      //               value: authController
                      //                   .mobileController
                      //                   .value
                      //                   .text),
                      //           textInputType: TextInputType.number),
                      //     ),
                      //   ],
                      // ),
                      //
                      // smallerSizedBox,
                      // AppWidget.textFormFiled(
                      //   isIconVisible: true,
                      //   textEditingController:
                      //   authController.passController.value,
                      //   hintText: AppStrings.password,
                      //   validator: FormValidation.emptyValidation(
                      //       value: authController
                      //           .passController.value.text),
                      //   obscureText: authController.obscure.value,
                      //   icon: authController.obscure.value
                      //       ? Icons.remove_red_eye
                      //       : Icons.remove_red_eye_outlined,
                      //   suffixOnTap: () {
                      //     setState(() {
                      //       authController.obscure.value =
                      //       !authController.obscure.value;
                      //       authController.update();
                      //     });
                      //   },
                      //   textInputAction: TextInputAction.next,
                      // ),
                      // smallerSizedBox,
                      // AppWidget.textFormFiled(
                      //     isIconVisible: true,
                      //     textEditingController:
                      //     authController.conPassController.value,
                      //     hintText: AppStrings.confirmPass,
                      //     validator: FormValidation.emptyValidation(
                      //         value: authController
                      //             .conPassController.value.text),
                      //     obscureText:
                      //     authController.obscureForConPass.value,
                      //     textInputAction: TextInputAction.done,
                      //     icon: authController.obscureForConPass.value
                      //         ? Icons.remove_red_eye
                      //         : Icons.remove_red_eye_outlined,
                      //     suffixOnTap: () {
                      //       setState(() {
                      //         authController.obscureForConPass.value =
                      //         !authController
                      //             .obscureForConPass.value;
                      //         authController.update();
                      //       });
                      //     }),
                      //
                      // smallerSizedBox,
                      Row(
                        children: [
                          Checkbox(
                              value: authController.agree.value,
                              activeColor: Colors.white,
                              checkColor: ColorConstant.backGroundColorOrange,
                              onChanged: (value) {
                                setState(() {
                                  authController.agree.value =
                                      !authController.agree.value;
                                  authController.update();
                                });
                              }),
                          Flexible(
                            child: RichText(
                                text: TextSpan(
                                    style: AppStyles.smallerTextStyle,
                                    text: 'I agree to the ',
                                    children: [
                                  TextSpan(
                                      style: AppStyles.smallerTextStyle,
                                      text: 'Terms of services '),
                                  const TextSpan(text: 'and '),
                                  TextSpan(
                                      style: AppStyles.smallerTextStyle,
                                      text: 'Privacy policy '),
                                ])),
                          )
                        ],
                      ),
                      // smallerSizedBox,
                      mediumSizedBox,
                      AppWidget.elevatedButton(
                          loading: authController.isLoading.value,
                          text: AppStrings.signUp,
                          onTap: () async {
                            log('CountryCOde ${authController.countryCodeController.value.text}');
                            if (_formkey.currentState!.validate()) {
                              log('REFRE ${authController.referCodeController.value.text}');

                              await authController.registerOtpApiCall();
                            }
                          }),
                      smallerSizedBox,
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }

// _showGenderDialog() {
//   return showDialog(
//       context: context,
//       builder: ((context) {
//         return AlertDialog(
//           title: Text('Select Your Gender',
//               style: smallTextStyleGreyText.copyWith(
//                   color: Colors.black, fontSize: 16.sp)),
//           content: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     authController.genderController.value.text = 'Male';
//                     authController.update();
//
//                     Get.back();
//                   },
//                   child: Text(
//                     'Male',
//                     style: smallTextStyleGreyText.copyWith(
//                         color: Colors.black, fontSize: 12.sp),
//                   ),
//                 ),
//                 smallerSizedBox,
//                 smallerSizedBox,
//                 GestureDetector(
//                   onTap: () {
//                     authController.genderController.value.text = 'Female';
//                     authController.update();
//                     Get.back();
//                   },
//                   child: Text(
//                     'Female',
//                     style: smallTextStyleGreyText.copyWith(
//                         color: Colors.black, fontSize: 12.sp),
//                   ),
//                 ),
//               ]),
//         );
//       }));
// }
}
