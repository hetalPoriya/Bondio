import 'dart:async';
import 'dart:developer';

import 'package:bondio/controller/controller.dart';
import 'package:bondio/screens/host_event/host.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class HostEvent extends StatelessWidget {
  HostEvent({Key? key}) : super(key: key);

  EventController eventController = Get.put(EventController());
  HomeController homeController = Get.put(HomeController());

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeController.hostEvent.value == 1
        ? ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: paddingSymmetric(horizontalPad: 6.w, verticalPad: 2.h),
            children: [
              Material(
                elevation: 1.w,
                borderRadius: BorderRadius.circular(2.w),
                child: Image.asset(
                  height: 20.h,
                  AppAssets.addEvent,
                ),
              ),
              mediumSizedBox,
              Container(
                height: 5.h,
                width: 100.w,
                child: Row(children: [
                  CircleAvatar(
                      maxRadius: 6.w,
                      backgroundColor: Colors.grey.shade300,
                      child: IconButton(
                        onPressed: () {},
                        icon:
                            Icon(Icons.camera_alt_sharp, color: Colors.black38),
                      )),
                  Flexible(
                    child: AppWidget.textFormFiledForEvent(
                      hintText: AppStrings.eventTitle,
                      textEditingController:
                          eventController.eventTitleController.value,
                    ),
                  ),
                ]),
              ),
              smallSizedBox,
              AppWidget.textFormFiledForEvent(
                hintText: AppStrings.description,
                icon: Icons.description,
                textEditingController: eventController.eventDesController.value,
              ),
              smallSizedBox,
              AppWidget.textFormFiledForEvent(
                hintText: AppStrings.location,
                // readOnly: true,
                // onTapReadOnly: () {
                //   showBottomSheet(
                //     context: context,
                //     builder: (context) => GoogleMap(
                //       mapType: MapType.hybrid,
                //       initialCameraPosition: _kGooglePlex,
                //       onMapCreated: (GoogleMapController controller) {
                //         _controller.complete(controller);
                //       },
                //     ),
                //   );
                // },
                icon: Icons.location_on_outlined,
                textEditingController:
                    eventController.eventLocationController.value,
              ),
              smallSizedBox,
              Container(
                height: 7.h,
                width: MediaQuery.of(context).size.width,
                padding: paddingSymmetric(verticalPad: 1.w, horizontalPad: 2.w),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: ColorConstant.backGroundColorOrange)),
                ),
                child: Row(children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () => AppWidget.selectDate(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: Text(AppStrings.date)),
                        Flexible(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Obx(
                              () => Text(
                                eventController.selectedDate.value
                                        .toString()
                                        .isNotEmpty
                                    ? eventController.selectedDate.value
                                    : DateFormat('dd-MM-yyyy')
                                        .format(DateTime.now()),
                                style: AppStyles.smallerTextStyle.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                            SizedBox(
                              width: 2.w,
                            ),
                            Flexible(
                              child: Icon(Icons.calendar_today,
                                  color: ColorConstant.backGroundColorOrange),
                            )
                          ],
                        ))
                      ],
                    ),
                  )),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      eventController.startTime.value = '';
                      eventController.endTime.value = '';
                      eventController.update();
                      AppWidget.selectTime(context: context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: Text(AppStrings.time)),
                        Flexible(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                                flex: 4,
                                child: Obx(
                                  () => Text(
                                    eventController.selectedTime.value
                                            .toString()
                                            .isNotEmpty
                                        ? eventController.selectedTime.value
                                        : '7:00 PM',
                                    style: AppStyles.smallerTextStyle.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9.sp),
                                  ),
                                )),
                            SizedBox(
                              width: 2.w,
                            ),
                            Flexible(
                              flex: 1,
                              child: Icon(Icons.access_time,
                                  color: ColorConstant.backGroundColorOrange),
                            )
                          ],
                        ))
                      ],
                    ),
                  ))
                ]),
              ),
              mediumSizedBox,
              AppWidget.elevatedButton(
                  text: AppStrings.invitePeople,
                  onTap: () {
                    homeController.hostEvent.value = 2;
                    homeController.update();
                  }),
              mediumSizedBox,
            ],
          )
        : InvitePeopleForEvent());
  }
}
