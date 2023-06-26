import 'package:bondio/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../chat.dart';

class ChatProfilePage extends StatefulWidget {
  const ChatProfilePage({Key? key}) : super(key: key);

  @override
  State<ChatProfilePage> createState() => _ChatProfilePageState();
}

class _ChatProfilePageState extends State<ChatProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: ListView(
              children: [
                Stack(children: [
                  Obx(
                        () =>
                        Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                              color: ColorConstant.extraLightPink,
                              image: DecorationImage(
                                  image:
                                  ChatWidget.displayImage(
                                      image: '', socialImage: ''),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      ColorConstant.extraLightPink,
                                      BlendMode.modulate))),
                        ),
                  ),
                  Padding(
                    padding: paddingSymmetric(
                        horizontalPad: 6.w, verticalPad: 2.h),
                    child: AppWidget.backIcon(onTap: () => Get.back()),
                  ),
                  Obx(
                        () =>
                        Container(
                          height: 16.h,
                          width: 33.w,
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(top: 26.h, left: 6.w),
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(18.w),
                              image: DecorationImage(
                                  image:
                                  ChatWidget.displayImage(
                                      image: '', socialImage: ''),
                                  fit: BoxFit.cover)),

                        ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 30.h, left: 50.w),
                      child: Text(
                        '',
                        style: AppStyles.largeTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ))
                ]),
              ],
            )));
  }
}