import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AppWidget {
  // static appBarMenu(
  //         {bool? backIcon = true,
  //         String? backgroundImage,
  //         TextStyle? textStyle,
  //         required VoidCallback onBackButtonPressed,
  //         required String title}) =>
  //     Container(
  // height: 24.h,
  // alignment: Alignment.centerLeft,
  // padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 00),
  // decoration: BoxDecoration(
  // image: DecorationImage(
  // image: AssetImage(backgroundImage ?? AppAssets.normalBackground),
  // fit: BoxFit.fill),
  // ),
  // child: Column(
  // mainAxisAlignment: MainAxisAlignment.spaceAround,
  // crossAxisAlignment: CrossAxisAlignment.start,
  // children: [
  // Row(
  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  // children: [
  // Visibility(
  // visible: backIcon!,
  // child: AppWidget.backIcon(onTap: onBackButtonPressed),
  // ),
  // Image.asset(AppAssets.menu, height: 2.h),
  // ],
  // ),
  // Text(title, style: textStyle ?? headerTextStyleWhite),
  // smallerSizedBox
  // ],
  // ),
  // );

  static AuthController authController = Get.put(AuthController());

  static SocialLoginController socialLoginController =
      Get.put(SocialLoginController());

  static backIcon(
      {required VoidCallback onTap,
      Color? backIconColor,
      AlignmentGeometry? alignment}) {
    return Align(
      alignment: alignment ?? Alignment.topLeft,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 4.h,
          width: 8.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: backIconColor ?? Colors.white)),
          child: Icon(Icons.arrow_back_sharp,
              color: backIconColor ?? Colors.white),
        ),
      ),
    );
  }

  static openCalendar(BuildContext context) async {
    AuthController authController = Get.put(AuthController());
    authController.pickedDate.value = (await showDatePicker(
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2100),
        keyboardType: TextInputType.phone,
        initialEntryMode: DatePickerEntryMode.input,
        selectableDayPredicate: (day) => day.isBefore(DateTime.now()),
        context: context,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: ColorConstant.mainAppColorNew, // <-- SEE HERE
                  onPrimary: Colors.white, // <-- SEE HERE
                  onSurface: Colors.black, // <-- SEE HERE
                ),
              ),
              child: child!);
        }))!;

    if (authController.pickedDate.value.toString().isNotEmpty) {
      // log(authController.pickedDate.value
      //     .toString()); //pickedDate output format => 2021-03-10 00:00:00.000

      authController.dobController.value.text =
          DateFormat('MM-dd-yyyy').format(authController.pickedDate.value);

      // log(authController.dobController.value.text);
      authController.update();
      //formatted date output using intl package =>  2021-03-16
    } else {
      // log('error');
    }
  }

  static textFormFiledWhite(
          {String? hintText,
          IconData? icon,
          TextInputAction? textInputAction,
          TextInputType? textInputType,
          bool? obscureText,
          void Function()? suffixOnTap,
          void Function()? onTapReadOnly,
          TextStyle? textStyle,
          bool? readOnly,
          bool isIconVisible = false,
          TextEditingController? textEditingController,
          String? Function(String?)? validator}) =>
      TextFormField(
        style: AppStyles.smallTextStyle.copyWith(color: Colors.white),
        textInputAction: textInputAction ?? TextInputAction.next,
        keyboardType: textInputType ?? TextInputType.text,
        obscureText: obscureText ?? false,
        readOnly: readOnly ?? false,
        onTap: onTapReadOnly,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textEditingController,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textStyle ??
              AppStyles.smallTextStyle.copyWith(color: Colors.white),
          labelStyle: textStyle ??
              AppStyles.smallTextStyle.copyWith(color: Colors.white),
          errorStyle: textStyle ??
              AppStyles.smallTextStyle
                  .copyWith(color: Colors.white, fontSize: 10.sp),
          errorMaxLines: 2,
          suffixIcon: Visibility(
            visible: isIconVisible,
            child: GestureDetector(
              onTap: suffixOnTap,
              child: Icon(icon, color: Colors.white),
            ),
          ),
          contentPadding: paddingAll(paddingAll: 4.w),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: const BorderSide(color: Colors.white),
              gapPadding: 00),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: const BorderSide(color: Colors.white),
              gapPadding: 00),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: const BorderSide(color: Colors.white),
              gapPadding: 00),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: const BorderSide(color: Colors.white),
              gapPadding: 00),
        ),
        cursorColor: Colors.white,
      );

  static textFormFiled(
          {String? hintText,
          IconData? icon,
          TextInputAction? textInputAction,
          TextInputType? textInputType,
          bool? obscureText,
          void Function()? suffixOnTap,
          void Function()? onTapReadOnly,
          TextStyle? textStyle,
          bool? readOnly,
          bool isIconVisible = false,
          TextEditingController? textEditingController,
          String? Function(String?)? validator}) =>
      TextFormField(
        textInputAction: textInputAction ?? TextInputAction.next,
        keyboardType: textInputType ?? TextInputType.text,
        obscureText: obscureText ?? false,
        readOnly: readOnly ?? false,
        onTap: onTapReadOnly,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textEditingController,
        validator: validator,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.smallTextStyle,
            labelStyle: AppStyles.smallTextStyle,
            labelText: hintText,
            suffix: Visibility(
              visible: isIconVisible,
              child: GestureDetector(
                onTap: suffixOnTap,
                child: Icon(icon, color: const Color(0xffFFB574)),
              ),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w),
                borderSide: const BorderSide(color: Colors.white),
                gapPadding: 00),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w),
                borderSide: const BorderSide(color: Colors.white),
                gapPadding: 00),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w),
                borderSide: const BorderSide(color: Colors.white),
                gapPadding: 00),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w),
                borderSide: const BorderSide(color: Colors.white),
                gapPadding: 00),
            errorStyle: AppStyles.smallTextStyle.copyWith(fontSize: 9.sp)),
        cursorColor: ColorConstant.backGroundColorOrange,
      );

  static textFormFiledProfilePage(
          {String? hintText,
          IconData? icon,
          TextInputAction? textInputAction,
          TextInputType? textInputType,
          bool? obscureText,
          void Function()? suffixOnTap,
          void Function()? onTapReadOnly,
          TextStyle? textStyle,
          Color? color,
          bool? readOnly,
          TextEditingController? textEditingController,
          String? Function(String?)? validator}) =>
      TextFormField(
        textInputAction: textInputAction ?? TextInputAction.next,
        keyboardType: textInputType ?? TextInputType.text,
        obscureText: obscureText ?? false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        readOnly: readOnly ?? false,
        onTap: onTapReadOnly,
        controller: textEditingController,
        validator: validator,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: textStyle ?? AppStyles.smallTextStyle,
            labelStyle: textStyle ?? AppStyles.smallTextStyle,
            contentPadding: paddingAll(paddingAll: 3.w),
            labelText: hintText,
            suffixIcon: GestureDetector(
              onTap: suffixOnTap,
              child: Icon(icon, color: const Color(0xffFFB574)),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: color ?? ColorConstant.backGroundColorOrange)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: color ?? ColorConstant.backGroundColorOrange)),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: color ?? ColorConstant.backGroundColorOrange))),
        cursorColor: color ?? ColorConstant.backGroundColorOrange,
      );

  static elevatedButton(
          {required String text,
          required void Function()? onTap,
          bool? loading,
          Color? progressColor}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100.w,
          height: 6.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4)
              ],
              gradient: LinearGradient(colors: [
                ColorConstant.backGroundColorOrange,
                ColorConstant.backGroundColorLightPink,
              ])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: AppStyles.smallTextStyle,
              ),
              Visibility(
                  visible: loading ?? false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 4.w,
                      ),
                      progressIndicator(color: progressColor ?? Colors.white)
                    ],
                  )),
            ],
          ),
        ),
      );

  static List<String?> socialMedia = [
    // AppAssets.outlook,
    AppAssets.linkedIn,
    AppAssets.google,
    AppAssets.instagram,
    AppAssets.facebook,
    AppAssets.twitter,
  ];

  static socialLogin() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: paddingSymmetric(horizontalPad: 3.w),
          height: 7.h,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                socialMedia.length,
                (index) => GestureDetector(
                  onTap: () async {
                    authController.fullNameController.value.text = '';
                    authController.mobileController.value.text = '';
                    authController.dobController.value.text = '';
                    authController.referCodeController.value.text = '';
                    Get.back();
                    // if (index == 0) {
                    //   authController.isGoogle.value = 'Outlook';
                    //   authController.update();
                    //
                    //   await FirebaseAuth.instance.signOut();
                    //   socialLoginController.signInWithOutlook();
                    // } else

                    if (index == 0) {
                      authController.isGoogle.value = 'LinkedIn';
                      authController.update();
                      socialLoginController.signInWithLinkedIn();
                    } else if (index == 1) {
                      authController.isGoogle.value = 'Google';
                      authController.update();
                      socialLoginController.signInWithGoogle();
                    } else if (index == 2) {
                      authController.isGoogle.value = 'Instagram';
                      Get.toNamed(RouteHelper.instagramLogin);
                      authController.update();
                    } else if (index == 3) {
                      authController.isGoogle.value = 'Facebook';
                      authController.update();
                      socialLoginController.signInWithFacebook();
                    } else {
                      authController.isGoogle.value = 'Twitter';
                      socialLoginController.signInWithTwitter();
                      authController.update();
                    }
                  },
                  child: Container(
                    width: 15.w,
                    height: 6.h,
                    padding: paddingAll(paddingAll: 2.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(2, 1), // changes position of shadow
                          ),
                        ],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Image.asset(socialMedia[index].toString(),
                        alignment: Alignment.center),
                  ),
                ),
              )),
        ),
      );

  static elevatedWhiteButton({
    required String text,
    required void Function()? onTap,
    bool? loading,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100.w,
          height: 6.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
            boxShadow: const [BoxShadow(color: Colors.white10, blurRadius: 4)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: AppStyles.mediumTextStyle
                    .copyWith(color: ColorConstant.backGroundColorOrange),
              ),
              Visibility(
                  visible: loading ?? false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 4.w,
                      ),
                      progressIndicator()
                    ],
                  )),
            ],
          ),
        ),
      );

  static toast({required String text}) => Fluttertoast.showToast(
      msg: text,
      backgroundColor: ColorConstant.mainAppColorNew,
      textColor: Colors.white);

  static containerIndicator() => Container(
        color: Colors.black45,
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(2.w),
            child: Container(
              height: 12.h,
              width: 24.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.w),
                color: Colors.white,
              ),
              child: AppWidget.progressIndicator(color: Colors.black),
            ),
          ),
        ),
      );

  static richText(
          {required String text1,
          required String text2,
          void Function()? onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                  style: AppStyles.smallTextStyle,
                  text: text1,
                  children: [
                    TextSpan(text: text2, style: AppStyles.smallTextStyle)
                  ]),
            )
          ],
        ),
      );

  static bihPolygon({required BuildContext context}) => Container(
        padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 0.0),
        height: 38.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            AppAssets.bigPolygon,
          ),
          fit: BoxFit.fill,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              AppAssets.bondioText,
              width: 50.w,
            ),
            smallSizedBox,
            smallSizedBox
          ],
        ),
      );

  static searchField(
          {required TextEditingController controller,
          void Function(String?)? onChanged,
          void Function(String?)? onFieldSubmitted}) =>
      TextFormField(
        cursorColor: ColorConstant.backGroundColorLightPink,
        controller: controller,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.black45),
            contentPadding: paddingAll(paddingAll: 1.0),
            //🔍
            hintText: 'Search..',
            hintStyle: AppStyles.smallerTextStyle,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
                borderSide: const BorderSide(color: Colors.black)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
                borderSide: BorderSide(color: Colors.grey.shade400))),
      );

  static bondioTextAndMenu(
          {VoidCallback? onTapOnMenu, required BuildContext context}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            width: 30.w,
            height: 5.h,
            AppAssets.bondioText,
            color: ColorConstant.backGroundColorOrange,
          ),
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Image.asset(
              width: 10.w,
              height: 3.h,
              AppAssets.menu,
              color: ColorConstant.backGroundColorOrange,
            ),
          ),
        ],
      );

  static containerWithLinearColor(
          {double? height, required Widget widget, VoidCallback? onTap}) =>
      Container(
          height: height ?? 10.h,
          decoration: BoxDecoration(
              gradient: linearGradientColor,
              borderRadius: BorderRadius.circular(4.w)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: onTap ?? () => Get.back(),
                child: Container(
                  //color: Colors.red,
                  height: 8.h,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.white,
                    size: 10.w,
                  ),
                ),
              )),
              Expanded(flex: 5, child: widget),
            ],
          ));

  static progressIndicator({Color? color}) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? ColorConstant.backGroundColorOrange,
            //<-- SEE HERE
          ),
        ),
      );

  static List<DrawerText> drawerText = [
    DrawerText(text: 'Events / Party', routeString: ''),
    DrawerText(text: 'Privacy', routeString: ''),
    DrawerText(text: 'Help & Support', routeString: ''),
    DrawerText(text: 'About Us', routeString: ''),
    DrawerText(text: 'Sign Out', routeString: ''),
  ];

  static appbar({required String text, Widget? widget}) => AppBar(
        centerTitle: true,
        title: Text(
          text,
          style: AppStyles.mediumTextStyle.copyWith(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          widget ?? Container(),
        ],
        leading: widget != null
            ? Container()
            : IconButton(
                padding: EdgeInsets.only(left: 8.w),
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios)),
      );

  static drawerWidget() => Drawer(
      width: 80.w,
      child: Container(
        decoration: BoxDecoration(gradient: ColorConstant.linearColor),
        child: ListView(children: [
          Padding(
            padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 00),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  smallerSizedBox,
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close, color: Colors.white)),
                  ),
                  const CircleAvatar(
                    minRadius: 12,
                    maxRadius: 50,
                    backgroundColor: Colors.white54,
                  ),
                  smallerSizedBox,
                  Padding(
                    padding:
                        paddingSymmetric(horizontalPad: 1.w, verticalPad: 00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) == false ? 'Guest' : authController.userModel.value.user?.name.toString()}',
                          style: AppStyles.mediumTextStyle,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            Get.toNamed(RouteHelper.profilePage);
                          },
                          child: Container(
                            padding: paddingAll(paddingAll: 1.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.w),
                              color: const Color(0xffE42F3B),
                            ),
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          smallerSizedBox,
          Container(
            color: const Color(0xffF0747F),
            height: 4.h,
          ),
          mediumSizedBox,
          ListView.builder(
              itemCount: drawerText.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    if (drawerText[index].text == 'About Us') {
                      Get.back();
                      Get.toNamed(RouteHelper.aboutUs);
                    }
                    if (index == drawerText.length - 1) {
                      Get.back();
                      _showSignOutDialog();
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(drawerText[index].text.toString(),
                            style: AppStyles.mediumTextStyle),
                      ),
                      smallerSizedBox,
                      Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: const Divider(color: Colors.white),
                      ),
                      smallerSizedBox,
                    ],
                  ),
                );
              })),
          largeSizedBox,
          mediumSizedBox,
          SizedBox(
            height: 10.h,
            child: Image.asset(
              AppAssets.bondioText,
            ),
          ),
          largeSizedBox,
        ]),
      ));

  static _showSignOutDialog() {
    AuthController authController = Get.put(AuthController());
    return Get.defaultDialog(
        title: 'Alert!!',
        titleStyle: AppStyles.mediumTextStyle,
        content: Padding(
          padding: paddingSymmetric(horizontalPad: 8.w, verticalPad: 00),
          child: Text(
            'Are you sure you want to sign out?',
            textAlign: TextAlign.center,
            style: AppStyles.smallTextStyle.copyWith(color: Colors.black),
          ),
        ),
        actions: [
          Padding(
            padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 00),
            child:
                AppWidget.elevatedButton(text: 'No', onTap: () => Get.back()),
          ),
          Padding(
            padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 00),
            child: AppWidget.elevatedButton(
                text: 'Yes',
                onTap: () async {
                  Get.back();
                  // await SocialLoginController.googleLogOut();
                  await authController.logOutApiCall();
                }),
          ),
        ]);
  }

  static cscPiker({required AuthController authController}) =>
      Obx(() => CSCPicker(
            showCities: true,
            showStates: true,
            layout: Layout.vertical,
            currentCity: authController.cityValue.value.isNotEmpty
                ? authController.cityValue.value
                : 'Select City',
            currentCountry: authController.countryValue.value.isNotEmpty
                ? authController.countryValue.value
                : 'Select Country',
            currentState: authController.stateValue.value.isNotEmpty
                ? authController.stateValue.value
                : 'Select State',
            cityDropdownLabel: 'Select City',
            countryDropdownLabel: 'Select Country',
            stateDropdownLabel: 'Select State',

            // cityDropdownLabel: authController.cityValue.value,
            // countryDropdownLabel: authController.countryValue.value,
            // stateDropdownLabel: authController.stateValue.value,
            dropdownHeadingStyle: AppStyles.smallTextStyle,
            dropdownItemStyle: AppStyles.smallTextStyle,
            selectedItemStyle: AppStyles.smallTextStyle,
            dropdownDecoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: ColorConstant.backGroundColorOrange))),
            disabledDropdownDecoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: ColorConstant.greyBorder))),
            onCountryChanged: (value) {
              authController.countryValue.value = value;
              // SharedPrefClass.setString(SharedPrefStrings.userCountry, value);
              authController.update();
            },
            onStateChanged: (value) {
              authController.stateValue.value = value.toString();
              // SharedPrefClass.setString(
              //     SharedPrefStrings.userState, value.toString());
              authController.update();
            },
            onCityChanged: (value) {
              authController.cityValue.value = value.toString();
              // SharedPrefClass.setString(
              //     SharedPrefStrings.userCity, value.toString());
              authController.update();
            },
          ));

// static progressBar() => CircularProgressIndicator(
//       valueColor: AlwaysStoppedAnimation<Color>(
//         ColorConstant.backGroundColorOrange,
//         //<-- SEE HERE
//       ),
//     );
}

class DrawerText {
  String? text;
  String? routeString;

  DrawerText({this.text, this.routeString});
}
