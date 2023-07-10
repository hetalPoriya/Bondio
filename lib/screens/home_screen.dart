import 'package:bondio/controller/controller.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:bondio/screens/reward_and_share/reward_and_share.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  List<Widget>? homeWidget;

  //controller
  HomeController homeController = Get.put(HomeController());
  ChatController chatController = Get.put(ChatController());


  @override
  void initState() {
    homeWidget = [
      const RewardsScreen(),
      const ChatMainPage(),
      InviteFriend(),
    ];

    if (Get.arguments != null) {
      homeController.selectedIndex.value = Get.arguments[0];
      homeController.update();
    } else {
      homeController.selectedIndex.value = 0;
      homeController.update();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: true,
        child: Scaffold(
            drawer: AppWidget.drawerWidget(),

            backgroundColor: ColorConstant.lightGrey,
            body: Obx(
                  () {
                return homeWidget!
                    .elementAt(homeController.selectedIndex.value);
              },
            ),
            bottomNavigationBar: Obx(
                  () {
                return Material(
                  elevation: 4,
                  shadowColor: Colors.black,
                  color: Colors.black,
                  child: Container(
                    color: Colors.white,
                    padding: paddingAll(paddingAll: 2.w),
                    height: 9.h,
                    child: BottomNavyBar(
                      backgroundColor: Colors.white,
                      //containerHeight: 6.h,
                      selectedIndex: homeController.selectedIndex.value,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      showElevation: false,
                      itemCornerRadius: 6.w,
                      curve: Curves.easeIn,
                      onItemSelected: (index) {
                        homeController.selectedIndex.value = index;
                        homeController.hostEvent.value = 0;
                        homeController.innerTabSelectedIndex.value = 0;
                        homeController.onTapOnAddContact.value = false;
                        homeController.personalChatPage.value = false;
                        homeController.personalGroupChatPage.value = false;
                        homeController.update();
                      },
                      items: <BottomNavyBarItem>[
                        bottomItem(
                            text: 'Home',
                            imageString: AppAssets.home,
                            index: 0),
                        bottomItem(
                            text:
                            'Chat ${SharedPrefClass.getInt(
                                SharedPrefStrings.totalChatCount) != 0
                                ? '(${SharedPrefClass.getInt(SharedPrefStrings
                                .totalChatCount)})'
                                : ''}',
                            imageString: AppAssets.chat,
                            index: 1),
                        bottomItem(
                            text: 'Invite',
                            imageString: AppAssets.invite,
                            index: 2),
                      ],
                    ),
                  ),
                );
              },
            )));
  }

  BottomNavyBarItem bottomItem({required String text,
    required String imageString,
    required int index}) =>
      BottomNavyBarItem(
        title: Text(
          text,
        ),
        activeColor: Colors.purple.withOpacity(0.8),
        inactiveColor: Colors.grey,
        textAlign: TextAlign.center,
        icon: Image.asset(imageString,
            height: 6.w,
            color: homeController.selectedIndex.value == index
                ? Colors.purple.withOpacity(0.8)
                : Colors.grey),
      );
}