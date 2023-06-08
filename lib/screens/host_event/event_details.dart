import 'package:bondio/controller/controller.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:bondio/screens/host_event/host.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../utils/utils.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventController eventController = Get.put(EventController());
    AuthController authController = Get.put(AuthController());
    HomeController home = Get.put(HomeController());
    return Obx(() => home.viewEvent.value == 1
        ? ListView(
            padding: paddingSymmetric(horizontalPad: 6.w),
            children: [
              smallSizedBox,
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(2.w),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white10,
                        spreadRadius: 1,
                      )
                    ],
                    border: Border.all(color: Colors.grey.shade300)),
                child: Row(children: [
                  SizedBox(
                    width: 4.w,
                  ),
                  CircleAvatar(
                    maxRadius: 6.w,
                    backgroundImage: ChatWidget.displayImage(image: ''),
                  ),
                  VerticalDivider(thickness: 1, color: Colors.grey.shade300),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          eventController.customerList.value.name ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.smallTextStyle.copyWith(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: ColorConstant.backGroundColorOrange,
                            size: 5.w,
                          ),
                          Text(
                            eventController.customerList.value.time ?? '',
                            style: AppStyles.smallerTextStyle
                                .copyWith(color: Colors.grey, fontSize: 9.sp),
                          ),
                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  if (eventController.customerList.value.customerId ==
                      authController.userModel.value.user?.id)
                    IconButton(
                        onPressed: () {
                          home.viewEvent.value = 2;
                          eventController.eventId.value =
                              eventController.customerList.value.id.toString();
                          eventController.eventTitleController.value.text =
                              eventController.customerList.value.name ?? '';
                          eventController.eventDesController.value.text =
                              eventController.customerList.value.description ??
                                  '';
                          eventController.selectedTime.value =
                              eventController.customerList.value.time ?? '';
                          eventController.selectedDate.value =
                              eventController.customerList.value.date ?? '';
                          eventController.eventLocationController.value.text =
                              eventController.customerList.value.location ?? '';

                          eventController.update();
                          home.update();

                          // home.hostEvent.value = 0;
                          //
                          //
                          //
                          // home.update();
                        },
                        icon: Icon(
                          Icons.edit,
                          color: ColorConstant.backGroundColorOrange,
                        )),
                ]),
              ),
              smallSizedBox,
              Image.asset(AppAssets.addEvent, height: 20.h),
              mediumSizedBox,
              Container(
                height: 10.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.w),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 10)
                    ]),
                child: Row(children: [
                  SizedBox(
                    width: 4.w,
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Image.asset(
                        AppAssets.eventMembers,
                        height: 5.h,
                      ),
                      CircleAvatar(
                        maxRadius: 5.w,
                        backgroundColor: ColorConstant.backGroundColorOrange,
                        child: Text(
                            eventController.customerList.value.customers?.length
                                    .toString() ??
                                '0',
                            style: AppStyles.smallTextStyle),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Text('Will come',
                      style: AppStyles.smallerTextStyle
                          .copyWith(color: Colors.black)),
                ]),
              ),
              smallSizedBox,
              Container(
                //color: Colors.red,
                padding: paddingSymmetric(verticalPad: 2.h),
                alignment: Alignment.center,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            rowText(
                                title: eventController
                                        .customerList.value.location ??
                                    '',
                                icon: Icons.location_on_outlined),
                            smallSizedBox,
                            rowText(
                                title: '6PM - 12PM', icon: Icons.access_time)
                          ],
                        ),
                      ),
                      VerticalDivider(thickness: 1),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            rowText(
                                title:
                                    eventController.customerList.value.date ??
                                        '',
                                icon: Icons.calendar_today),
                            smallSizedBox,
                            rowText(
                                title:
                                    eventController.customerList.value.name ??
                                        '',
                                icon: Icons.event)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              smallSizedBox,
              Text(
                eventController.customerList.value.description ?? '',
                style: AppStyles.smallTextStyle.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              mediumSizedBox,
              Text('Invited user email list:',
                  style:
                      AppStyles.smallTextStyle.copyWith(color: Colors.black)),
              smallerSizedBox,
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: eventController.customerList.value.customers?.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: paddingSymmetric(verticalPad: 1.w),
                      child: Row(
                        children: [
                          Text('${(index + 1).toString()}. ',
                              style: AppStyles.smallTextStyle
                                  .copyWith(color: Colors.black)),
                          Text(
                              eventController.customerList.value
                                      .customers?[index].email ??
                                  '',
                              style: AppStyles.smallTextStyle
                                  .copyWith(color: Colors.black)),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade400),
                  ],
                ),
              ),
              mediumSizedBox,
            ],
          )
        : UpdateEvent());
  }

  rowText({required String title, required IconData icon}) => Container(
        // color: Colors.red,
        // alignment: Alignment.center,
        padding: paddingSymmetric(horizontalPad: 2.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: ColorConstant.backGroundColorOrange, size: 6.w),
            SizedBox(
              width: 1.w,
            ),
            Flexible(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.smallerTextStyle.copyWith(color: Colors.black),
              ),
            )
          ],
        ),
      );
}
