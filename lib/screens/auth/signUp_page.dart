import 'package:bondio/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                        validator: FormValidation.firstNameVlidation(
                            value:
                                authController.fullNameController.value.text),
                        // icon: Icons.person_outline,
                      ),
                      smallerSizedBox,
                      AppWidget.textFormFiledWhite(
                        textEditingController:
                            authController.lastNameController.value,
                        hintText: AppStrings.lastName,
                        validator: FormValidation.lastNameValidation(
                            value:
                                authController.lastNameController.value.text),
                        // icon: Icons.person_outline,
                      ),
                      Text(AppStrings.yourMobileNumber,
                          style: AppStyles.mediumTextStyle),
                      smallerSizedBox,

                      AppWidget.phoneNumberTextField(),

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

                      smallSizedBox,
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
                            if (_formkey.currentState!.validate()) {
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