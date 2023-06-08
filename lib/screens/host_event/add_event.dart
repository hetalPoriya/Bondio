import 'package:bondio/controller/controller.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:bondio/screens/host_event/host.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent>
    with SingleTickerProviderStateMixin {
  HomeController homeController = Get.put(HomeController());
  AuthController authController = Get.put(AuthController());
  EventController eventController = Get.put(EventController());

  TabController? tabController;

  List<Widget> displayPage = [
    HostEvent(),
    ViewEvent(),
  ];

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChatBackground(
        onBackButtonPressed: () {
          eventController.startTime.value = '';
          eventController.endTime.value = '';
          eventController.update();
          if (homeController.hostEventTabSelectedIndex.value == 0) {
            if (homeController.hostEvent.value != 1) {
              homeController.hostEvent.value =
                  homeController.hostEvent.value - 1;
              homeController.update();
            } else {
              homeController.hostEvent.value = 0;
              homeController.update();
            }
          } else {
            if (homeController.viewEvent.value != 0) {
              homeController.viewEvent.value =
                  homeController.viewEvent.value - 1;
              homeController.update();
            } else {
              homeController.hostEvent.value = 0;
              homeController.update();
            }
          }
        },
        appBarWidget: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallSizedBox,
                Text(
                  'Hello ${authController.userModel.value.user?.name ?? ''},',
                  style: AppStyles.mediumTextStyle,
                ),
                Text(
                  AppStrings.inviteMemberForParty,
                  style: AppStyles.smallerTextStyle
                      .copyWith(fontWeight: FontWeight.w300),
                ),
              ]),
        ),
        bodyWidget: Container(
          //color: Colors.redAccent,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            children: [
              mediumSizedBox,
              DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: TabBar(
                    controller: tabController,
                    onTap: (int) {
                      homeController.hostEventTabSelectedIndex.value = int;
                      if (int == 0) {
                        eventController.startTime.value = '';
                        eventController.endTime.value = '';
                        eventController.update();
                        homeController.hostEvent.value = 1;
                        homeController.update();
                      } else {
                        homeController.viewEvent.value = 0;
                        homeController.update();
                      }
                    },
                    unselectedLabelColor: Colors.grey.shade500,
                    indicatorSize: TabBarIndicatorSize.label,
                    padding: EdgeInsets.zero,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.w),
                        gradient: LinearGradient(colors: [
                          ColorConstant.lightRed,
                          ColorConstant.darkRed,
                        ]),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.white,
                              blurRadius: 4,
                              spreadRadius: 4)
                        ]),
                    tabs: [
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.w),
                              border:
                              Border.all(color: Colors.black12, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(AppStrings.hostEvent),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.w),
                              border:
                              Border.all(color: Colors.black12, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(AppStrings.viewEvent),
                          ),
                        ),
                      ),
                    ]),
              ),
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .60,
                //color: Colors.black38,
                child: TabBarView(
                    controller: tabController, children: displayPage),
              )
            ],
          ),
        ));
  }
}
