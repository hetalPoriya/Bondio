import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../utils/utils.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: false,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.top,
            child: ListView(
              children: [
                Container(
                  padding:
                      paddingSymmetric(horizontalPad: 5.w, verticalPad: 0.h),
                  height: 34.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                      AppAssets.smallPolygon,
                    ),
                    fit: BoxFit.fill,
                  )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 1),
                      AppWidget.backIcon(onTap: () => Get.back()),
                      Text('About Us',
                          style: largeTextStyle.copyWith(
                              fontFamily: 'Poppins-Bold'),
                          textAlign: TextAlign.center),
                      largeSizedBox,
                      mediumSizedBox
                    ],
                  ),
                ),
                Padding(
                  padding:
                      paddingSymmetric(horizontalPad: 4.w, verticalPad: 00),
                  child: Text(
                      'Welcome to Bondio: A virtual gathering place for colleagues and friends',
                      textAlign: TextAlign.center,
                      style: mediumTextStyleWhiteText.copyWith(
                          color: Colors.black)),
                ),
                mediumSizedBox,
                Padding(
                  padding:
                      paddingSymmetric(horizontalPad: 4.w, verticalPad: 00),
                  child: Text(
                      'We offer a fun and safe way to connect with those you know and love, and professional friends and colleagues, even if miles away. Let Bondio host your next meal with a friend, group celebration, or work gathering. There’s no FOMO here. We make it possible to still have a fun sit-down meal with a friend, whether going dutch or someone is picking up the tab 500 miles away.',
                      textAlign: TextAlign.center,
                      style: smallTextStyleWhiteText.copyWith(
                          color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
