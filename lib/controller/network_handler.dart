export 'package:bondio/utils/utils.dart';
import 'dart:developer';

import 'package:bondio/controller/auth_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class NetworkHandler {
  static Dio dio = Dio();
  static AuthController authController = Get.put(AuthController());

  static String buildUrl(String endpoint) {
    String host =
        'http://sh021.hostgator.tempwebhost.net/~synraiar/bondio/api/v1/';
    final apiPath = host + endpoint;
    return apiPath;
  }

  static Options options = Options(headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${authController.userModel.value.token.toString()}'
  });

  // static Future<String> getApi(String endpoint) async {
  //   print('Token');
  //   try {
  //     var response = await dio.get(buildUrl(endpoint));
  //     print('StatusCode ${response.statusCode}');
  //     print('Body ${response.data}');
  //     return response.data;
  //   } catch (e) {
  //     var response = await dio.get(buildUrl(endpoint));
  //     print('StatusCode ${response.statusCode}');
  //     print('Body ${response.data}');
  //     return response.data;
  //   }
  // }
  //
  // static Future postAPi(var body, String endpoint) async {
  //   // String token = SharedPrefClass.getString(SharedPrefStrings.token);
  //   String token = '';
  //   print('Token $token');
  //   print('Url ${buildUrl(endpoint)}');
  //   try {
  //     var response = await dio.post(
  //       buildUrl(endpoint),
  //       data: body,
  //       options: Options(headers: {
  //         'content-Type': 'application/json',
  //         if (token.isNotEmpty) 'Authorization': 'Bearer $token',
  //       }),
  //     );
  //     log('StatusCode ${response}');
  //     log('StatusCode ${response.statusCode}');
  //     log('Body ${response.data}');
  //     return response.data;
  //   } catch (e) {
  //     var response = await dio.post(
  //       buildUrl(endpoint),
  //       data: body,
  //       options: Options(headers: {
  //         'content-Type': 'application/json',
  //         // 'Authorization': 'Bearer ',
  //       }),
  //     );
  //     print('StatusCode1 ${response.statusCode}');
  //     print('Body1 ${response.data}');
  //     return response.data;
  //   }
  // }

  Future<bool> checkConnectivity() async {
    try {
      var connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.mobile) {
      } else if (connectivity == ConnectivityResult.wifi) {
      } else {}

      // if (isConnected) {
      //   try {
      //     final result = await InternetAddress.lookup('google.com');
      //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //       isConnected = true;
      //     }
      //   } on SocketException catch (_) {
      //     isConnected = false;
      //   }
      // }
    } catch (e) {
      log('Exception - NetworkHandler.dart - checkConnectivity(): $e');
    }
    return false;
  }
}
