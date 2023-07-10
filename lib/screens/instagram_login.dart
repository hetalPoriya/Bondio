import 'dart:developer';

import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/utils/instagram_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../model/instagram_model.dart';

class InstagramLogin extends StatelessWidget {
  const InstagramLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final webview = FlutterWebviewPlugin();
      final InstagramModel instagram = InstagramModel();

      buildRedirectToHome(webview, instagram, context);

      return WebviewScaffold(
        url: InstagramConstant.instance.url,
        resizeToAvoidBottomInset: true,
        clearCookies: true,
        initialChild: Container(
            height: 100.h,
            color: Colors.black12,
            child: AppWidget.containerIndicator()),
        appBar: buildAppBar(context),
      );
    });
  }

  Future<void> buildRedirectToHome(FlutterWebviewPlugin webview,
      InstagramModel instagram, BuildContext context) async {
    SocialLoginController socialLoginController =
    Get.put(SocialLoginController());
    webview.onUrlChanged.listen((String url) async {
      log('Utl ${InstagramConstant.redirectUri}');
      if (url.contains(InstagramConstant.redirectUri)) {
        instagram.getAuthorizationCode(url);
        await instagram.getTokenAndUserID().then((isDone) async {
          if (isDone) {
            instagram.getUserProfile().then((isDone) async {
              await webview.close();
              log('INSTA ${instagram.userFields.toString()}');
              print('${instagram.username} logged in!');

              await socialLoginController.signInWithInstagram(
                  userName: instagram.username.toString(),
                  id: instagram?.userID ?? '');

              // await Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => HomeView(
              //       token: instagram.authorizationCode.toString(),
              //       name: instagram.username.toString(),
              //     ),
              //   ),
              // );
            });
          }
        });
      }
    });
  }

  AppBar buildAppBar(BuildContext context) => AppBar(
    centerTitle: true,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    title: Text(
      'Instagram Login',
      style: AppStyles.largeTextStyle.copyWith(color: Colors.white),
    ),
  );
}