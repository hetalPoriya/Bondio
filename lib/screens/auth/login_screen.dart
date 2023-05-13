// import 'package:bondio/controller/auth_controller.dart';
// import 'package:bondio/utils/app_widget_new.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../route_helper/route_helper.dart';
// import '../../utils/utils.dart';
//
// class LoginScreen extends StatefulWidget {
//   LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final AuthController authController = Get.put(AuthController());
//   final _formkey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Container(
//       height: double.infinity,
//       width: double.infinity,
//       decoration: BoxDecoration(gradient: AppWidgetForNewUi.linearColor),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//             leading: Container(),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             title: Image.asset(AppAssets.bondioText, width: 30.w, height: 5.h),
//             centerTitle: true),
//         body: DefaultTabController(
//             length: 2,
//             child: Column(
//               children: [
//                 TabBar(
//                     unselectedLabelStyle: AppStyles.smallTextStyle
//                         .copyWith(color: Colors.grey.shade400),
//                     labelStyle: AppStyles.smallTextStyle,
//                     indicatorColor: Colors.white,
//                     tabs: [
//                       Tab(
//                         child: Text(
//                           AppStrings.newAccount,
//                         ),
//                       ),
//                       Tab(
//                         child: Text(
//                           AppStrings.login,
//                         ),
//                       ),
//                     ]),
//                 Expanded(
//                     child: TabBarView(
//                   children: [
//                     signUpForm(context: context),
//                     loginForm(context: context)
//                   ],
//                 ))
//               ],
//             )),
//       ),
//     ));
//   }
//
//   loginForm({
//     required BuildContext context,
//   }) {
//     return Form(
//       //key: _formkey,
//       child: Obx(
//         () => ListView(
//           padding: paddingSymmetric(
//             verticalPad: 2.h,
//             horizontalPad: 6.w,
//           ),
//           physics: const ClampingScrollPhysics(),
//           shrinkWrap: true,
//           children: [
//             AppWidgetForNewUi.textFormFiled(
//                 validator: FormValidation.emailValidation(
//                     value: authController.emailLoginController.value.text),
//                 textEditingController:
//                     authController.emailLoginController.value,
//                 hintText: AppStrings.emailAddress,
//                 icon: Icons.email,
//                 textInputType: TextInputType.emailAddress),
//             smallSizedBox,
//
//             AppWidgetForNewUi.textFormFiled(
//                 textEditingController: authController.passLoginController.value,
//                 hintText: AppStrings.password,
//                 obscureText: authController.obscure.value,
//                 isIconVisible: true,
//                 textInputType: TextInputType.text,
//                 textInputAction: TextInputAction.done,
//                 icon: authController.obscure.value
//                     ? Icons.remove_red_eye_outlined
//                     : Icons.remove_red_eye,
//                 suffixOnTap: () {
//                   authController.obscure.value = !authController.obscure.value;
//                   authController.update();
//                 }),
//             SizedBox(
//               height: 40.h,
//             ),
//             Obx(() => Align(
//                   alignment: Alignment.bottomCenter,
//                   child: AppWidgetForNewUi.elevatedButton(
//                       loading: authController.isLoading.value,
//                       text: AppStrings.signIn,
//                       onTap: () async {
//                         if (authController
//                                 .emailLoginController.value.text.isNotEmpty &&
//                             authController
//                                 .passLoginController.value.text.isNotEmpty) {
//                           await authController.loginApiCall();
//                         }
//                       }),
//                 )),
//             smallSizedBox,
//             GestureDetector(
//               onTap: () {
//                 Get.toNamed(RouteHelper.forgotPassword);
//               },
//               child: Center(
//                 child: Text(
//                   AppStrings.forgotPass,
//                   style: AppStyles.smallTextStyle,
//                 ),
//               ),
//             ),
//             smallerSizedBox,
//           ],
//         ),
//       ),
//     );
//   }
//
//   signUpForm({required BuildContext context}) {
//     return Form(
//         key: _formkey,
//         child: Obx(
//           () {
//             return ListView(
//               padding: paddingSymmetric(
//                 verticalPad: 2.h,
//                 horizontalPad: 6.w,
//               ),
//               physics: const ClampingScrollPhysics(),
//               shrinkWrap: true,
//               children: [
//                 AppWidgetForNewUi.textFormFiled(
//                     textEditingController: authController.emailController.value,
//                     hintText: AppStrings.emailAddress,
//                     validator: FormValidation.emailValidation(
//                         value: authController.emailController.value.text),
//                     textInputType: TextInputType.emailAddress),
//                 smallSizedBox,
//                 AppWidgetForNewUi.textFormFiled(
//                   isIconVisible: true,
//                   textEditingController: authController.passController.value,
//                   hintText: AppStrings.password,
//                   validator: FormValidation.emptyValidation(
//                       value: authController.passController.value.text),
//                   obscureText: authController.obscure.value,
//                   icon: authController.obscure.value
//                       ? Icons.remove_red_eye
//                       : Icons.remove_red_eye_outlined,
//                   suffixOnTap: () {
//                     authController.obscure.value =
//                         !authController.obscure.value;
//                     authController.update();
//                   },
//                   textInputAction: TextInputAction.next,
//                 ),
//                 smallSizedBox,
//                 AppWidgetForNewUi.textFormFiled(
//                     isIconVisible: true,
//                     textEditingController:
//                         authController.conPassController.value,
//                     hintText: AppStrings.confirmPass,
//                     validator: FormValidation.emptyValidation(
//                         value: authController.conPassController.value.text),
//                     obscureText: authController.obscureForConPass.value,
//                     icon: authController.obscureForConPass.value
//                         ? Icons.remove_red_eye
//                         : Icons.remove_red_eye_outlined,
//                     suffixOnTap: () {
//                       authController.obscureForConPass.value =
//                           !authController.obscureForConPass.value;
//                       authController.update();
//                     },
//                     textInputAction: TextInputAction.done),
//                 SizedBox(
//                   height: 30.h,
//                 ),
//                 AppWidgetForNewUi.elevatedButton(
//                     loading: authController.isLoading.value,
//                     text: AppStrings.signUp,
//                     onTap: () async {
//                       if (_formkey.currentState!.validate()) {
//                         if (authController.passController.value.text !=
//                             authController.conPassController.value.text) {
//                           AppWidgetForNewUi.toast(
//                             text: 'Password not match',
//                           );
//                         } else {
//                           Get.toNamed(RouteHelper.socialSignUpPage);
//                         }
//                       }
//                     }),
//               ],
//             );
//           },
//         ));
//   }
// }
import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/screens/auth/bigPolygon_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //contoller
  AuthController authController = Get.put(AuthController());
  SocialLoginController socialLoginController =
      Get.put(SocialLoginController());

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BigPolygonBackground(
        showingBackIconOrNot: false,
        widget: Center(
            child: Obx(
          () => Form(
            key: _formkey,
            child: Padding(
              padding: paddingSymmetric(horizontalPad: 10.w, verticalPad: 2.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppWidget.textFormFiled(
                      validator: FormValidation.emailValidation(
                          value:
                              authController.emailLoginController.value.text),
                      textEditingController:
                          authController.emailLoginController.value,
                      hintText: AppStrings.emailAddress,
                      icon: Icons.email,
                      textInputType: TextInputType.emailAddress),
                  smallSizedBox,
                  AppWidget.textFormFiled(
                      textEditingController:
                          authController.passLoginController.value,
                      hintText: AppStrings.password,
                      obscureText: authController.obscure.value,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      icon: authController.obscure.value
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye,
                      suffixOnTap: () {
                        authController.obscure.value =
                            !authController.obscure.value;
                        authController.update();
                      }),
                  Obx(
                    () => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: authController.rememberOrNot.value,
                      activeColor: ColorConstant.backGroundColorOrange,
                      title:
                          Text(AppStrings.rememberMe, style: smallerTextStyle),
                      onChanged: (bool? value) {
                        authController.rememberOrNot.value = value!;
                        authController.update();
                      },
                    ),
                  ),
                  smallerSizedBox,
                  Obx(() => AppWidget.elevatedButton(
                      progressColor: Colors.white,
                      loading: authController.isLoading.value,
                      text: AppStrings.signIn,
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          await authController.loginApiCall();
                        }
                      })),
                  smallerSizedBox,
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Get.toNamed(RouteHelper.forgotPassword),
                        child: Text(
                          AppStrings.forgotPass,
                          style: smallerTextStyleOrangeText,
                        ),
                      )),
                  SizedBox(height: 10.h),
                  AppWidget.richText(
                      text1: AppStrings.notHaveAccount,
                      text2: AppStrings.signUp,
                      onTap: () => Get.toNamed(RouteHelper.signUpPage))
                ],
              ),
            ),
          ),
        )));
  }
}
