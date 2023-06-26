import 'dart:developer';

import 'package:bondio/controller/controller.dart';
import 'package:bondio/model/get_event.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:bondio/screens/host_event/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ViewEvent extends StatefulWidget {
  ViewEvent({Key? key}) : super(key: key);

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  ChatController chatController = Get.put(ChatController());
  AuthController authController = Get.put(AuthController());
  HomeController homeController = Get.put(HomeController());
  EventController eventController = Get.put(EventController());

  @override
  void initState() {
    if (SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) == true) {
      eventController.getEventApiCall();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeController.viewEvent.value == 0
        ? (SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) == false)
            ? noEventFound()
            : eventController.isLoading.value == true
                ? AppWidget.progressIndicator()
                : (eventController.getEventList.value.data == [] ||
                        eventController.getEventList.value.data?.length == 0)
                    ? noEventFound()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            eventController.getEventList.value.data?.length,
                        itemBuilder: (context, index) {
                          log('Lengh ${eventController.getEventList.value.data?.length}');
                          var response =
                              eventController.getEventList.value.data?[index];

                          return Padding(
                            padding: paddingSymmetric(
                                horizontalPad: 5.w, verticalPad: 1.h),
                            child: GestureDetector(
                              onTap: () {
                                homeController.viewEvent.value = 1;
                                var value = eventController
                                    .getEventList.value.data?[index].customers
                                    ?.map((e) => e.id.toString())
                                    .toList();
                                eventController.memberList.value =
                                    value!.join(',');

                                eventController.update();
                                eventController.customerList.value =
                                    response ?? GetEventList();

                                eventController.customerList.refresh();
                                eventController.update();
                                homeController.update();
                              },
                              child: ChatWidget.eventContainer(
                                  title: response?.name ?? '',
                                  description: response?.description ?? '',
                                  date: response?.date ?? '',
                                  time: response?.time ?? '',
                                  memberList:
                                      response?.customers?.length.toString() ??
                                          '0',
                                  imageString: '',
                                  invitedBy: response?.customerId ==
                                          authController
                                              .userModel.value.user?.id
                                      ? 'Invited By You'
                                      : ''),
                            ),
                          );
                        },
                        padding: paddingSymmetric(
                            horizontalPad: 0.w, verticalPad: 2.h),
                      )
        : EventDetails());
  }
}

noEventFound() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppAssets.noEvent,
            height: 10.h, width: 40.w, color: Colors.black),
        smallSizedBox,
        Text(
          'No Event Found',
          style: AppStyles.smallTextStyle.copyWith(color: Colors.black),
        ),
      ],
    ),
  );
}