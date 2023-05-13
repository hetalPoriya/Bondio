import 'package:bondio/route_helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:bondio/utils/utils.dart';

class DashBoard extends StatelessWidget {
  DashBoard({Key? key}) : super(key: key);

  List<String> containerImage = [
    AppAssets.hostEventContainer,
    AppAssets.connectWithFriendContainer,
    AppAssets.inviteFriendContainer,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.top,
            child: ListView(
              children: [
                Container(
                  padding:
                      paddingSymmetric(horizontalPad: 4.w, verticalPad: 0.0),
                  height: 38.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                      AppAssets.dashboardBackground,
                    ),
                    fit: BoxFit.fill,
                  )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      containerImage.length,
                      (index) => Column(
                            children: [
                              smallSizedBox,
                              GestureDetector(
                                onTap: index == 0
                                    ? () {}
                                    : () {
                                        Get.toNamed(RouteHelper.homeScreen,
                                            arguments: [index]);
                                      },
                                child: Container(
                                  height: 15.h,
                                  width: MediaQuery.of(context).size.width,
                                  padding: paddingSymmetric(
                                      horizontalPad:
                                          MediaQuery.of(context).orientation ==
                                                  Orientation.portrait
                                              ? 6.w
                                              : 20.w,
                                      verticalPad: 0),
                                  child: Image.asset(containerImage[index],
                                      fit: BoxFit.fill),
                                ),
                              ),
                              smallerSizedBox,
                            ],
                          )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
