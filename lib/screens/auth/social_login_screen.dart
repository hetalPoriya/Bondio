import 'package:bondio/controller/auth_controller.dart';
import 'package:bondio/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              children: [
                mediumSizedBox,
                Text(
                    'Great, you have logged in via ${authController.isGoogle.value}',
                    style: AppStyles.mediumTextStyle,
                    textAlign: TextAlign.center),
                smallSizedBox,
                Text(
                    'Fill additional details to complete sign up via ${authController.isGoogle}',
                    style: AppStyles.smallerTextStyle,
                    textAlign: TextAlign.center),
                mediumSizedBox,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Obx(
                      () => CircleAvatar(
                        minRadius: 5.h,
                        maxRadius: 6.h,
                        backgroundColor: Colors.black12,
                        backgroundImage:
                            authController.imageController.value.text != 'null'
                                ? NetworkImage(
                                    authController.imageController.value.text)
                                : chatController.pickedImage?.value == null
                                    ? AssetImage(AppAssets.addContact)
                                        as ImageProvider
                                    : FileImage(
                                        chatController.pickedImage!.value!,
                                      ),
                      ),
                    ),
                  ],
                ),
                smallSizedBox,
                AppWidget.phoneNumberTextField(),
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
                  textEditingController: authController.referByController.value,
                ),
                smallerSizedBox,
                Text('Optional', style: AppStyles.smallerTextStyle),
                largeSizedBox,
                Obx(() => AppWidget.elevatedButton(
                    text: AppStrings.continueText,
                    onTap: () async => authController.registerApiCall(),
                    loading: authController.isLoading.value))
              ],
            )),
      ),
    ));
  }
}