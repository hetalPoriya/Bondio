import 'dart:developer';
import 'dart:io';

import 'package:bondio/controller/auth_controller.dart';
import 'package:bondio/controller/chat_controller.dart';
import 'package:bondio/screens/chat/widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import '../../utils/utils.dart';

class SocialLoginScreen extends StatefulWidget {
  const SocialLoginScreen({Key? key}) : super(key: key);

  @override
  State<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  PageController controller = PageController();
  ChatController chatController = Get.put(ChatController());
  late AuthController authController;

  static File? imageValue;

  List<IconData> icons = [
    Icons.account_circle_outlined,
    Icons.phone,
    Icons.cake_outlined,
    Icons.card_giftcard,
  ];

  @override
  void initState() {
    authController = Get.put(AuthController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(gradient: ColorConstant.linearColor),
          child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () => Get.back(),
                )),
            backgroundColor: Colors.transparent,
            body: Padding(
                padding: paddingSymmetric(horizontalPad: 6.w),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mediumSizedBox,
                    Text(
                        'Great, you have logged in via ${authController.isGoogle
                            .value}',
                        style: AppStyles.mediumTextStyle,
                        textAlign: TextAlign.center),
                    smallSizedBox,
                    Text(
                        'Fill additional details to complete sign up via ${authController
                            .isGoogle}',
                        style: AppStyles.smallerTextStyle,
                        textAlign: TextAlign.center),
                    mediumSizedBox,
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Obx(
                              () =>
                              CircleAvatar(
                                minRadius: 5.h,
                                maxRadius: 6.h,
                                backgroundColor: Colors.black12,
                                backgroundImage:
                                authController.imageController.value.text !=
                                    'null'
                                    ? NetworkImage(authController
                                    .imageController
                                    .value.text) as ImageProvider
                                    : chatController.pickedImage?.value == null
                                    ? AssetImage(AppAssets.addContact)
                                as ImageProvider
                                    : FileImage(
                                  chatController.pickedImage!.value!,
                                ),
                                // child: Align(
                                //   alignment: Alignment.bottomRight,
                                //   child: Padding(
                                //     padding: EdgeInsets.only(right: 2.w),
                                //     child: CircleAvatar(
                                //       minRadius: 2.h,
                                //       maxRadius: 2.h,
                                //       backgroundColor: Colors.white,
                                //       child: const Icon(Icons.camera_alt,
                                //           color: Colors.redAccent),
                                //     ),
                                //   ),
                                // ),
                              ),
                        ),
                      ],
                    ),
                    smallSizedBox,
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
                                    .text =
                                    value.dialCode.toString();
                                authController.update();
                                log('Auth ${authController.countryCodeController
                                    .value.text}');
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
                              validator: FormValidation.mobileNumberValidation(
                                  value:
                                  authController.mobileController.value.text),
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.number),
                        ),
                      ],
                    ),
                    smallerSizedBox,
                    Text('Please enter your phone number to find your friends.',
                        style: AppStyles.smallerTextStyle),
                    if (authController.isGoogle.value == 'Twitter' ||
                        authController.isGoogle.value == "Instagram")
                      smallSizedBox,
                    if (authController.isGoogle.value == 'Twitter' ||
                        authController.isGoogle.value == "Instagram")
                      AppWidget.textFormFiledWhite(
                          textEditingController:
                          authController.emailController.value,
                          hintText: AppStrings.emailAddress,
                          validator: FormValidation.emailValidation(
                              value: authController.emailController.value.text),
                          textInputType: TextInputType.emailAddress),
                    smallSizedBox,
                    AppWidget.textFormFiledWhite(
                      textEditingController: authController.dobController.value,
                      onTapReadOnly: () => AppWidget.openCalendar(context),
                      hintText: AppStrings.dob,
                      readOnly: true,
                    ),
                    smallerSizedBox,
                    Text(AppStrings.dobText, style: AppStyles.smallerTextStyle),
                    smallSizedBox,
                    AppWidget.textFormFiledWhite(
                      hintText: AppStrings.inviteCode,
                      textInputAction: TextInputAction.done,
                      textEditingController:
                      authController.referByController.value,
                    ),
                    smallerSizedBox,
                    Text('Optional', style: AppStyles.smallerTextStyle),
                    largeSizedBox,
                    Obx(() =>
                        AppWidget.elevatedButton(
                            text: AppStrings.continueText,
                            onTap: () async => authController.registerApiCall(),
                            loading: authController.isLoading.value))
                  ],
                )
              // child: Column(
              //   children: [
              //
              //
              //     // smallSizedBox,
              //     // Container(
              //     //     width: MediaQuery.of(context).size.width,
              //     //     height: 6.h,
              //     //     alignment: Alignment.center,
              //     //     child: Obx(
              //     //       () => Row(
              //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     //         children: [
              //     //           Row(
              //     //             children: List.generate(icons.length, (index) {
              //     //               return authController.pageViewIndex.value == index
              //     //                   ? CircleAvatar(
              //     //                       backgroundColor: Colors.white30,
              //     //                       radius: 5.w,
              //     //                       child: Icon(icons[index],
              //     //                           color: Colors.white, size: 3.h),
              //     //                     )
              //     //                   : Container(
              //     //                       height: 2.h,
              //     //                       width: 2.w,
              //     //                       decoration: const BoxDecoration(
              //     //                         shape: BoxShape.circle,
              //     //                         color: Colors.white,
              //     //                       ),
              //     //                       margin: paddingSymmetric(
              //     //                         horizontalPad: 3.w,
              //     //                       ),
              //     //                     );
              //     //             }),
              //     //           ),
              //     //           if (authController.pageViewIndex.value >= 2)
              //     //             GestureDetector(
              //     //                 onTap: () async {
              //     //                   if (authController.pageViewIndex.value ==
              //     //                       icons.length - 1) {
              //     //                     await authController.registerOtpApiCall();
              //     //                   } else {
              //     //                     controller.nextPage(
              //     //                         duration: const Duration(milliseconds: 4),
              //     //                         curve: Curves.easeInSine);
              //     //                   }
              //     //                 },
              //     //                 child: Text(
              //     //                   'Skip',
              //     //                   style: AppStyles.smallTextStyle.copyWith(
              //     //                       decoration: TextDecoration.underline),
              //     //                 ))
              //     //         ],
              //     //       ),
              //     //     )),
              //     // Expanded(
              //     //     child: Stack(
              //     //   children: [
              //     //     PageView.builder(
              //     //       physics: NeverScrollableScrollPhysics(),
              //     //       controller: controller,
              //     //       itemCount: 4,
              //     //       onPageChanged: (ind) {
              //     //         authController.pageViewIndex.value = ind;
              //     //         authController.update();
              //     //       },
              //     //       itemBuilder: (context, index) {
              //     //         return Padding(
              //     //           padding: paddingSymmetric(verticalPad: 2.h),
              //     //           child: loginWidget.elementAt(index),
              //     //         );
              //     //       },
              //     //     ),
              //     //     Obx(() => authController.isLoading.value == true
              //     //         ? AppWidgetForNewUi.progressIndicator(color: Colors.white)
              //     //         : Container()),
              //     //   ],
              //     // )),
              //     // Row(
              //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     //   children: [
              //     //     _floatingActionButton(
              //     //       icon: Icons.arrow_back_ios_outlined,
              //     //       onTap: () {
              //     //         controller.previousPage(
              //     //             duration: const Duration(milliseconds: 4),
              //     //             curve: Curves.easeInSine);
              //     //       },
              //     //     ),
              //     //     _floatingActionButton(
              //     //         icon: Icons.arrow_forward_ios,
              //     //         onTap: () async {
              //     //           if (authController.pageViewIndex.value ==
              //     //               icons.length - 1) {
              //     //             await authController.registerOtpApiCall();
              //     //           } else if (authController.pageViewIndex.value >= 2) {
              //     //             controller.nextPage(
              //     //                 duration: const Duration(milliseconds: 4),
              //     //                 curve: Curves.easeInSine);
              //     //           } else {
              //     //             if (textEditingController[
              //     //                     authController.pageViewIndex.value]
              //     //                 .text
              //     //                 .isNotEmpty) {
              //     //               controller.nextPage(
              //     //                   duration: const Duration(milliseconds: 4),
              //     //                   curve: Curves.easeInSine);
              //     //             }
              //     //           }
              //     //         },
              //     //         buttonColor:
              //     //             authController.pageViewIndex.value == icons.length - 1
              //     //                 ? Colors.white
              //     //                 : textEditingController[
              //     //                             authController.pageViewIndex.value]
              //     //                         .text
              //     //                         .isEmpty
              //     //                     ? Colors.white54
              //     //                     : Colors.white,
              //     //         textColor:
              //     //             authController.pageViewIndex.value == icons.length - 1
              //     //                 ? ColorConstant.mainAppColorNew
              //     //                 : textEditingController[
              //     //                             authController.pageViewIndex.value]
              //     //                         .text
              //     //                         .isEmpty
              //     //                     ? Colors.white
              //     //                     : ColorConstant.mainAppColorNew),
              //     //   ],
              //     // ),
              //     // smallSizedBox
              //   ],
              // ),
            ),
          ),
        ));
  }

// phoneNumberWidget() {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         AppStrings.yourMobileNumber,
//         style: AppStyles.largeTextStyle,
//       ),
//       smallSizedBox,
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Container(
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white),
//                   borderRadius: BorderRadius.circular(3.w)),
//               child: CountryCodePicker(
//                 initialSelection: 'US',
//                 onChanged: ((value) {
//                   authController.countryCodeController.value.text =
//                       value.dialCode.toString();
//                   authController.update();
//                   log('Auth ${authController.countryCodeController.value.text}');
//                 }),
//                 textStyle:
//                     AppStyles.smallTextStyle.copyWith(color: Colors.white),
//                 padding: paddingSymmetric(horizontalPad: 00, verticalPad: 2),
//                 showDropDownButton: true,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 2.w,
//           ),
//           Flexible(
//             flex: 2,
//             child: AppWidget.textFormFiledWhite(
//                 textEditingController: authController.mobileController.value,
//                 hintText: AppStrings.mobileNumber,
//                 validator: FormValidation.mobileNumberValidation(
//                     value: authController.mobileController.value.text),
//                 textInputAction: TextInputAction.done,
//                 textInputType: TextInputType.number),
//           ),
//         ],
//       ),
//       smallerSizedBox,
//       Text('Please enter your phone number to find your friends.',
//           style: AppStyles.smallTextStyle),
//       smallSizedBox,
//       AppWidget.textFormFiledWhite(
//         textEditingController: authController.dobController.value,
//         onTapReadOnly: () => AppWidget.openCalendar(context),
//         hintText: AppStrings.dob,
//         readOnly: true,
//       ),
//       smallerSizedBox,
//       Text(
//         'App rewards on birthday',
//         style: AppStyles.smallTextStyle,
//       ),
//       smallSizedBox,
//       AppWidget.textFormFiledWhite(
//         hintText: AppStrings.inviteCode,
//         textInputAction: TextInputAction.done,
//         textEditingController: authController.referByController.value,
//       ),
//       smallerSizedBox,
//       Text(
//         'Optional',
//         style: AppStyles.smallTextStyle,
//       ),
//     ],
//   );
// }
//
// dobWidget() {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         AppStrings.yourBirthday,
//         style: AppStyles.largeTextStyle,
//       ),
//       smallSizedBox,
//       AppWidget.textFormFiledWhite(
//         textEditingController: authController.dobController.value,
//         onTapReadOnly: () => AppWidget.openCalendar(context),
//         hintText: AppStrings.dob,
//         readOnly: true,
//       ),
//       smallerSizedBox,
//       Text(
//         'App rewards on birthday',
//         style: AppStyles.smallTextStyle,
//       ),
//     ],
//   );
// }
//
// profileName() {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         AppStrings.yourName,
//         style: AppStyles.largeTextStyle,
//       ),
//       smallSizedBox,
//       AppWidget.textFormFiledWhite(
//           hintText: AppStrings.firstName,
//           validator: FormValidation.emptyValidation(
//               value: authController.fullNameController.value.text),
//           textInputAction: TextInputAction.done,
//           textEditingController: authController.fullNameController.value),
//     ],
//   );
// }
//
// inviteCode() {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         AppStrings.yourInviteCode,
//         style: AppStyles.largeTextStyle,
//       ),
//       smallSizedBox,
//       AppWidget.textFormFiledWhite(
//         hintText: AppStrings.inviteCode,
//         textInputAction: TextInputAction.done,
//         textEditingController: authController.referCodeController.value,
//       ),
//       smallerSizedBox,
//       Text(
//         'Optional',
//         style: AppStyles.smallTextStyle,
//       ),
//     ],
//   );
// }
//
// showDialogForImage({required BuildContext context}) {
//   return Get.defaultDialog(
//       title: 'From where do you want to take the photo?',
//       titleStyle: AppStyles.mediumTextStyle.copyWith(color: Colors.grey),
//       contentPadding: EdgeInsets.zero,
//       content: Padding(
//         padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 0),
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Get.back();
//                   _pickFromGalley();
//                 },
//                 child: Text(
//                   'Gallery',
//                   style:
//                       AppStyles.smallTextStyle.copyWith(color: Colors.black),
//                 ),
//               ),
//               smallerSizedBox,
//               GestureDetector(
//                 onTap: () {
//                   Get.back();
//                   _pickFromCamera();
//                 },
//                 child: Text(
//                   'Camera',
//                   style:
//                       AppStyles.smallTextStyle.copyWith(color: Colors.black),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ));
// }
//
// static _pickFromGalley() async {
//   ChatController chatController = Get.put(ChatController());
//   AuthController authController = Get.put(AuthController());
//   final image = await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (image == null) return;
//   imageValue = File(image.path);
//   imageValue = File(image.path);
//   log('as ${imageValue}');
//   authController.imageController.value.text = 'null';
//   authController.update();
//   //log(authController.imageController.value.text.toString());
//   chatController.update();
// }
//
// static _pickFromCamera() async {
//   ChatController chatController = Get.put(ChatController());
//   AuthController authController = Get.put(AuthController());
//   final image = await ImagePicker().pickImage(source: ImageSource.camera);
//   if (image == null) return;
//   imageValue = File(image.path);
//   log('as ${imageValue}');
//   authController.imageController.value.clear();
//   authController.update();
//   chatController.update();
// }
}
