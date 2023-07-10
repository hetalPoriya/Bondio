export 'package:bondio/utils/utils.dart';
import 'dart:developer';

import 'package:bondio/controller/auth_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class NetworkHandler {
  static Dio dio = Dio();
  static AuthController authController = Get.put(AuthController());

  static Options options = Options(headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${authController.userModel.value.token.toString()}'
  });


  Future<bool> checkConnectivity() async {
    try {
      var connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.mobile) {} else
      if (connectivity == ConnectivityResult.wifi) {} else {}
    } catch (e) {
      log('Exception - NetworkHandler.dart - checkConnectivity(): $e');
    }
    return false;
  }
}