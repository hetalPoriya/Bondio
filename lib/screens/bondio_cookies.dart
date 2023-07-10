import 'package:bondio/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BondioCookies extends StatelessWidget {
  const BondioCookies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Bondio Cookies',
              style: AppStyles.mediumTextStyle.copyWith(color: Colors.black)),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: WebViewWidget(
            controller: WebViewController()
              ..loadRequest(
                  Uri.parse('https://bondiomeet.com/cookies-policy'))),
      ),
    );
  }
}