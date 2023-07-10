import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controller/controller.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Term and Conditions',
              style: AppStyles.mediumTextStyle.copyWith(color: Colors.black)),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: WebViewWidget(
            controller: WebViewController()
              ..loadRequest(
                  Uri.parse('https://bondiomeet.com/term-conditions'))),
      ),
    );
  }
}