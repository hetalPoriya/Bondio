import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:cross_file/src/types/interface.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

import '../model/model.dart';
import '../screens/chat/chat.dart';

class AuthController extends GetxController {
  //token
  RxString facebookToken = ''.obs;
  RxString googleToken = ''.obs;
  RxString twitterToken = ''.obs;
  RxString outlookToken = ''.obs;
  RxString linkedinToken = ''.obs;
  RxString instagramToken = ''.obs;

  //for otp
  RxString otpValue = ''.obs;
  RxString enterOtpByUser = ''.obs;

  //userInfo
  Rx<LoginData> userModel = LoginData().obs;
  RxString isGoogle = ''.obs;
  var token = ''.obs;

  // //for login remember
  // var emailLoginController = TextEditingController().obs;
  // var passLoginController = TextEditingController().obs;

  var fullNameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var imageController = TextEditingController().obs;
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
  var aboutMeController = TextEditingController().obs;

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

      log('Email ${emailController.value.text}');
      log('Email ${fullNameController.value.text}');
      log('Email ${countryCodeController.value.text}${mobileController.value.text}');

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
        //options: NetworkHandler.options,
      );
      log('OtpResponse ${response.data}');
      if (response.data['Status'] == true) {
        OtpModel data = OtpModel.fromMap(response.data);
        otpValue.value = data.data!.service.toString();
        AppWidget.toast(text: data.msg.toString());
        Get.toNamed(RouteHelper.verifyEmail);
      } else {
        AppWidget.toast(text: 'Please enter valid phone number');
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
      log('Token $token');
      log(' otpValue.value ${otpValue.value}');
      log(' otpValue.value ${enterOtpByUser.value}');

      SignUpBody signUpBody = SignUpBody(
          email: emailController.value.text.toString(),
          mobile:
              '${countryCodeController.value.text}${mobileController.value.text}',
          name: fullNameController.value.text,
          company: companyNameController.value.text,
          dob: dobController.value.text,
          password: passController.value.text.isNotEmpty
              ? passController.value.text
              : 'Synram@125',
          referBy: referCodeController.value.text,
          deviceToken: token ?? (await FirebaseMessaging.instance.getToken())!,
          aboutMe: ' ',
          city: ' ',
          country: ' ',
          photo: imageController.value.text.toString(),
          state: ' ',
          zipCode: ' ',
          outlookToken: outlookToken.value,
          instagramToken: instagramToken.value,
          linkedinToken: linkedinToken.value,
          twitterToken: twitterToken.value,
          facebookToken: facebookToken.value,
          googleToken: googleToken.value,
          otp: enterOtpByUser.value,
          service: otpValue.value,
          gender: ' ',
          referCode: ' ');

      log('API ${ApiConstant.buildUrl(ApiConstant.registerApi)}');
      log('API ${signUpBodyToMap(signUpBody)}');
      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.registerApi),
        data: signUpBodyToMap(signUpBody),
        options: Options(headers: {
          'Accept': 'application/json',
        }),
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
        email: emailController.value.text.toString(),
        password: passController.value.text.toString(),
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

  userExistOrNotApi({required String tokenType, required String token}) async {
    try {
      isLoading(true);
      log('tokenType ${fullNameController.value.text}');

      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.isRegisterApi),
        data: {'type': tokenType, 'value': token},
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

  checkInviteCodeApi() async {
    try {
      isLoading(true);
      log('refercode ${referCodeController.value.text}');
      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.customerDetailApi),
        data: {'refer_code': referCodeController.value.text},
      );

      log('refer code response $response');
      if (response.data['Status'] == true) {
        AppWidget.toast(text: 'Code applied successfully');
        Timer(const Duration(seconds: 2),
            () => Get.toNamed(RouteHelper.signUpPage));
      } else {
        AppWidget.toast(text: 'Entered invite code is not valid');
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

  updateProfileApiCall({File? imagePath}) async {
    try {
      isLoading(true);

      log('TOKEN ${userModel.value.token.toString()}');
      log('API ${ApiConstant.buildUrl(ApiConstant.updateProfileApi)}');
      log('API ${imagePath.toString()}');
      String fileName = imagePath?.path.split('/').last ?? '';

      log('fileName ${fileName.toString()}');
      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.updateProfileApi),
        data: FormData.fromMap({
          "photo": fileName.isNotEmpty
              ? await MultipartFile.fromFile(imagePath?.path ?? '',
                  filename: fileName)
              : userModel.value.user!.photo.toString(),
          "name": fullNameController.value.text,
          "zip_code": zipCodeController.value.text,
          "country": countryValue.value,
          "state": stateValue.value,
          "city": cityValue.value,
          "about_me": aboutMeController.value.text,
        }),
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userModel.value.token.toString()}'
        }),
      );
      log('RegisterResponse ${response.data}');
      if (response.data['Status'] == true) {
        LoginModel data = LoginModel.fromMap(response.data);
        SharedPrefClass.setUserData(json.encode(response.data['Data']));
        AppWidget.toast(text: data.msg.toString());
        SharedPrefClass.setBool(SharedPrefStrings.isLogin, true);
        SharedPrefClass.setString(
            SharedPrefStrings.userId, data.data?.user?.id.toString() ?? '');
        SharedPrefClass.setString(
            SharedPrefStrings.userName, data.data?.user?.name.toString() ?? '');
        await ChatWidget.getUserInfo();

        chatController.userCollection
            .doc(data.data?.user?.id.toString())
            .update({
          "photo": data.data?.user?.photo.toString() ?? '',
          "name": data.data?.user?.name.toString() ?? '',
          "zip_code": data.data?.user?.zipCode.toString() ?? '',
          "country": data.data?.user?.country.toString() ?? '',
          "state": data.data?.user?.state.toString() ?? '',
          "city": data.data?.user?.city.toString() ?? '',
          "about_me": data.data?.user?.aboutMe.toString() ?? '',
        });

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
}
