import 'package:bondio/controller/controller.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RewardsScreen extends StatefulWidget {
  final VoidCallback? onTap;

  const RewardsScreen({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  //controller
  HomeController homeController = Get.put(HomeController());
  AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> containerList = [
      {
        'backgroundImage': AppAssets.orangeContainer,
        'topImage': AppAssets.hostEvent,
        'text': 'Host an Event'
      },
      {
        'backgroundImage': AppAssets.purpleContainer,
        'topImage': AppAssets.connectWithFriend,
        'text': 'Connect with Friends'
      },
      {
        'backgroundImage': AppAssets.blueContainer,
        'topImage': AppAssets.inviteFriend,
        'text': 'Invite Friends'
      }
    ];

    // List<Map<String, dynamic>> gridViewList = [
    //   {'imageString': AppAssets.gold, 'text': 'Earned', 'count': 0},
    //   {'imageString': AppAssets.chatMessage, 'text': 'Friends', 'count': 0},
    //   {
    //     'imageString': AppAssets.partyAttendance,
    //     'text': 'Party Attendance',
    //     'count': 0
    //   },
    //   {
    //     'imageString': AppAssets.upcomingEvent,
    //     'text': 'Upcoming Events',
    //     'count': 0
    //   },
    // ];

    return ChatBackground(
        onBackButtonPressed: () {
          homeController.selectedIndex.value = 0;
          homeController.update();
        },
        backIcon: false,
        backgroundImage: AppAssets.rewardBackground,
        appBarWidget: Text(
            'Welcome \n${SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) == false ? 'as a Guest' : authController.userModel.value.user?.name.toString()}',
            style: headerTextStyleWhite.copyWith(fontSize: 18.sp)),
        bodyWidget: Column(
          children: [
            smallSizedBox,
            Padding(
              padding: paddingSymmetric(horizontalPad: 10.w, verticalPad: 00),
              child: Container(
                height: 9.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(color: ColorConstant.greyBorder),
                    color: ColorConstant.lightGrey),
                child: Row(children: [
                  Expanded(
                      child: Container(
                    padding: paddingAll(paddingAll: 3.w),
                    child: Image.asset(
                      AppAssets.hand,
                    ),
                  )),
                  Padding(
                    padding:
                        paddingSymmetric(horizontalPad: 00, verticalPad: 2.w),
                    child: VerticalDivider(
                      color: ColorConstant.greyBorder,
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.referAndEarn,
                            style: titleTextStyleWhite,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            AppStrings.referAndEarnDec,
                            style: smallerTextStyle.copyWith(fontSize: 7.sp),
                          )
                        ],
                      )),
                ]),
              ),
            ),
            smallerSizedBox,
            Padding(
              padding: paddingSymmetric(horizontalPad: 2.w, verticalPad: 00),
              child: SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 15.h
                        : 20.h,
                width: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                        containerList.length,
                        (index) => Expanded(
                                child: InkWell(
                              onTap: () {
                                homeController.selectedIndex.value = index;
                                homeController.update();
                              },
                              child: Container(
                                  height: MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? 15.h
                                      : 20.h,
                                  margin: paddingSymmetric(
                                      horizontalPad: 2.w, verticalPad: 00),
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                      //color: Colors.red,
                                      image: DecorationImage(
                                          image: AssetImage(
                                            containerList[index]
                                                ['backgroundImage'],
                                          ),
                                          fit: BoxFit.contain)),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 3.w),
                                    child: Text(
                                      containerList[index]['text'],
                                      textAlign: TextAlign.center,
                                      style: smallTextStyleWhiteText.copyWith(
                                          fontSize: 9.sp),
                                    ),
                                  )),
                            )))),
              ),
            ),
            smallSizedBox,
            Padding(
              padding: paddingSymmetric(horizontalPad: 3.w, verticalPad: 00),
              child: Container(
                  height: 35.h,
                  padding:
                      paddingSymmetric(horizontalPad: 1.w, verticalPad: 1.h),
                  decoration: BoxDecoration(
                      color: ColorConstant.lightGrey,
                      border: Border.all(color: ColorConstant.greyBorder),
                      borderRadius: BorderRadius.circular(4.w)),
                  child: Column(
                    children: [
                      smallerSizedBox,
                      containerListWidget(
                          image1: AppAssets.dollar,
                          count1: '0',
                          text1: 'Earned',
                          text2: 'Friends',
                          count2: '0',
                          image2: AppAssets.chatMessage),
                      smallerSizedBox,
                      containerListWidget(
                          image1: AppAssets.partyAttendance,
                          count1: '0',
                          text1: 'Party Attendance',
                          text2: 'Upcoming Events',
                          count2: '0',
                          image2: AppAssets.upcomingEvent),
                      smallerSizedBox,
                    ],
                  )),
            ),
            smallSizedBox,
            Container(
              height: 14.h,
              color: ColorConstant.faceLightColor,
              padding: paddingSymmetric(
                horizontalPad: 7.w,
                verticalPad: 4.w,
              ),
              child: DottedBorder(
                  color: Colors.black,
                  radius: Radius.circular(4.w),
                  borderType: BorderType.RRect,
                  child: Padding(
                    padding: paddingSymmetric(
                      horizontalPad: 2.w,
                      verticalPad: 2.w,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.w),
                        color: Colors.white,
                      ),
                      child: Row(children: [
                        Expanded(
                            child: Image.asset(AppAssets.surprise,
                                fit: BoxFit.contain)),
                        Expanded(
                            flex: 3,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      'Surprise gift',
                                      style: headerTextStyleWhite.copyWith(
                                          color: ColorConstant.darkPink,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      'Get a free pass for a party',
                                      style: smallTextStyleGreyText,
                                    ),
                                  )
                                ])),
                      ]),
                    ),
                  )),
            ),
            smallSizedBox,
          ],
        ));
  }

  Widget containerListWidget(
      {String? text1,
      String? image1,
      String? count1,
      String? text2,
      String? image2,
      String? count2}) {
    return Expanded(
        child: Row(children: [
      SizedBox(
        width: 2.w,
      ),
      commanContainer(text: text1, image: image1, count: count1),
      SizedBox(
        width: 4.w,
      ),
      commanContainer(text: text2, image: image2, count: count2),
      SizedBox(
        width: 2.w,
      ),
    ]));
  }

  Widget commanContainer({String? text, String? image, String? count}) {
    return Expanded(
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(2.w),
        child: Container(
          decoration: BoxDecoration(
              color: ColorConstant.lightGreyContainer,
              borderRadius: BorderRadius.circular(2.w)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              image.toString(),
              height: 5.h,
              width: 10.w,
              fit: BoxFit.fill,
            ),
            Text(
              text.toString(),
              style: smallTextStyleGreyText.copyWith(
                  color: Colors.black, fontSize: 11.sp),
            ),
            Text(
              count.toString(),
              style: headerTextStyleBlack.copyWith(fontSize: 16.sp),
            )
          ]),
        ),
      ),
    );
  }
}
