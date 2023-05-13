import 'dart:convert';
import 'dart:developer';
import 'package:bondio/controller/controller.dart';
import 'package:bondio/model/user_info.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/model.dart';
import '../screens/chat/chat.dart';

class AuthController extends GetxController {
  //token
  RxString facebookToken = ''.obs;
  RxString googleToken = ''.obs;

  //for otp
  RxString otpValue = ''.obs;
  RxString enterOtpByUser = ''.obs;

  //userInfo
  Rx<LoginData> userModel = LoginData().obs;
  RxString isGoogle = ''.obs;
  var token = ''.obs;

  //for login remember
  var emailLoginController = TextEditingController().obs;
  var passLoginController = TextEditingController().obs;

  var fullNameController = TextEditingController().obs;
  var companyNameController = TextEditingController().obs;
  var dobController = TextEditingController().obs;
  var genderController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var countryCodeController = TextEditingController().obs;
  var passController = TextEditingController().obs;
  var mobileController = TextEditingController().obs;
  var conPassController = TextEditingController().obs;
  var referCodeController = TextEditingController().obs;
  var zipCodeController = TextEditingController().obs;

  //for date picker
  RxString formattedDate = ''.obs;
  var pickedDate = DateTime.now().obs;

  //for password
  RxBool obscure = true.obs;
  RxBool obscureForConPass = true.obs;

  //for api
  RxBool isLoading = false.obs;

  //Dio
  Dio dio = Dio();

  //country
  RxString countryValue = "".obs;
  RxString stateValue = "".obs;
  RxString cityValue = "".obs;

  //pageview index
  RxInt pageViewIndex = 0.obs;

  RxBool rememberOrNot = true.obs;
  RxBool agree = false.obs;

  FirebaseController firebaseController = Get.put(FirebaseController());
  ChatController chatController = Get.put(ChatController());

  registerOtpApiCall() async {
    try {
      isLoading(true);

      if (countryCodeController.value.text.isEmpty) {
        countryCodeController.value.text = '+1';
      }
      OtpMap otpMap = OtpMap(
          email: emailController.value.text,
          name: fullNameController.value.text,
          mobile:
              '${countryCodeController.value.text}${mobileController.value.text}');

      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.registerOtpApi),
        data: otpModelToMap(otpMap),
        options: NetworkHandler.options,
      );
      log('OtpResponse ${response.data}');
      if (response.data['Status'] == true) {
        OtpModel data = OtpModel.fromMap(response.data);
        otpValue.value = data.data!.otp.toString();
        AppWidget.toast(text: data.msg.toString());
        Get.toNamed(RouteHelper.verifyEmail);
      } else {
        AppWidget.toast(text: response.data['Data'][0].toString());
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }

  registerApiCall() async {
    try {
      isLoading(true);
      String? token = await FirebaseMessaging.instance.getToken();
      log('Token $token');
      SignUpBody signUpBody = SignUpBody(
        email: emailController.value.text.toString(),
        mobile:
            '${countryCodeController.value.text}${mobileController.value.text}',
        name: fullNameController.value.text.toString(),
        company: companyNameController.value.text.toString(),
        dob: dobController.value.text.toString(),
        password: passController.value.text.toString(),
        referBy: referCodeController.value.text.toString(),
        deviceToken: token ?? (await FirebaseMessaging.instance.getToken())!,
        facebookToken: facebookToken.value.toString(),
        googleToken: googleToken.value.toString(),
        aboutMe: ' ',
        city: ' ',
        country: ' ',
        photo: ' ',
        state: ' ',
        zipCode: ' ',
      );

      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.registerApi),
        data: signUpBodyToMap(signUpBody),
        options: NetworkHandler.options,
      );
      log('RegisterResponse ${response.data}');
      if (response.data['Status'] == true) {
        LoginModel data = LoginModel.fromMap(response.data);
        SharedPrefClass.setUserData(json.encode(response.data['Data']));
        AppWidget.toast(text: data.msg.toString());
        SharedPrefClass.setBool(SharedPrefStrings.isLogin, true);
        SharedPrefClass.setString(
            SharedPrefStrings.userId, data.data!.user!.id.toString());
        SharedPrefClass.setString(
            SharedPrefStrings.userName, data.data!.user!.name.toString());
        await ChatWidget.getUserInfo();

        chatController
            .addContactToFirebase(
                mobileNumber:
                    '${countryCodeController.value.text}${mobileController.value.text}',
                userName: data.data!.user!.name.toString(),
                status: 'Chat',
                id: data.data!.user!.id.toString(),
                fcmToken: data.data!.user!.deviceToken.toString())
            .then((value) => log('Edded'));

        chatController.addUserInfoToFirebase(userInfo: data.data?.user);
        fullNameController.value.clear();
        companyNameController.value.clear();
        dobController.value.clear();
        genderController.value.clear();
        emailController.value.clear();
        countryCodeController.value.clear();
        passController.value.clear();
        mobileController.value.clear();
        conPassController.value.clear();
        referCodeController.value.clear();
        zipCodeController.value.clear();
        Get.offNamedUntil(RouteHelper.homeScreen, (route) => false);
      } else {
        AppWidget.toast(text: response.data['Data'][0].toString());
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }

  loginApiCall() async {
    try {
      isLoading(true);
      LoginBody loginBody = LoginBody(
        email: emailLoginController.value.text.toString(),
        password: passLoginController.value.text.toString(),
      );

      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.loginApi),
        data: loginBodyToMap(loginBody),
        options: NetworkHandler.options,
      );

      log('LoginResponse ${response.data.toString()}');
      if (response.data['Status'] == true) {
        LoginModel data = LoginModel.fromMap(response.data);
        SharedPrefClass.setUserData(json.encode(response.data['Data']));
        AppWidget.toast(text: data.msg.toString());
        SharedPrefClass.setBool(SharedPrefStrings.isLogin, true);
        SharedPrefClass.setString(
            SharedPrefStrings.userId, data.data!.user!.id.toString());
        SharedPrefClass.setString(
            SharedPrefStrings.userName, data.data!.user!.name.toString());
        await ChatWidget.getUserInfo();

        Get.offNamedUntil(RouteHelper.homeScreen, (route) => false);
      } else {
        AppWidget.toast(text: response.data['Msg'].toString());
      }
    } finally {
      isLoading(false);
    }
  }

  userExistOrNotApi() async {
    try {
      isLoading(true);
      log('Email ${emailController.value.text}');
      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.isRegisterApi),
        data: {'email': emailController.value.text},
      );

      log('UserExistOrNot $response');
      if (response.data['Status'] == true) {
        LoginModel data = LoginModel.fromMap(response.data);
        SharedPrefClass.setUserData(json.encode(response.data['Data']));
        AppWidget.toast(text: data.msg.toString());
        SharedPrefClass.setBool(SharedPrefStrings.isLogin, true);
        await ChatWidget.getUserInfo();
        Get.offNamedUntil(RouteHelper.homeScreen, (route) => false);
      } else {
        Get.toNamed(RouteHelper.socialSignUpPage);
      }
    } finally {
      isLoading(false);
    }
  }

  logOutApiCall() async {
    if (SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) == false) {
      Get.offNamedUntil(RouteHelper.introScreen, (route) => false);
    } else {
      try {
        isLoading(true);
        var response =
            await dio.post(ApiConstant.buildUrl(ApiConstant.logoutApi),
                options: Options(headers: {
                  'Accept': 'application/json',
                  'Authorization': 'Bearer ${userModel.value.token.toString()}'
                }));

        if (response.data['Status'] == true) {
          SharedPrefClass.setBool(SharedPrefStrings.isLogin, false);
          SharedPrefClass.remove(SharedPrefStrings.userName);
          SharedPrefClass.remove(SharedPrefStrings.userId);
          userModel.value = LoginData();

          SharedPrefClass.clear();
          Get.offNamedUntil(RouteHelper.introScreen, (route) => false);
        }
      } on DioError catch (e) {
        if (e.response?.statusCode == 401) {
          AppWidget.toast(text: 'Unauthenticated');
        }
      } finally {
        isLoading(false);
      }
    }
  }
}
