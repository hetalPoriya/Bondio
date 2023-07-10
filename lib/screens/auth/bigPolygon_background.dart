import 'package:bondio/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BigPolygonBackground extends StatelessWidget {
  final Widget widget;
  final Widget? aboveText;
  final bool? showingBackIconOrNot;

  const BigPolygonBackground({Key? key,
    required this.widget,
    this.aboveText,
    this.showingBackIconOrNot = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height -
              MediaQuery
                  .of(context)
                  .viewPadding
                  .top,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 0.0),
                height: 38.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        AppAssets.bigPolygon,
                      ),
                      fit: BoxFit.fill,
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    smallerSizedBox,
                    showingBackIconOrNot == true
                        ? AppWidget.backIcon(onTap: () => Get.back())
                        : mediumSizedBox,
                    smallerSizedBox,
                    aboveText ??
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            AppAssets.bondioText,
                            width: 50.w,
                          ),
                        ),
                    largeSizedBox,
                    largeSizedBox,
                  ],
                ),
              ),
              widget
            ],
          ),
        ),
      ),
    );
  }
}