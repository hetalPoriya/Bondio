import 'package:bondio/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class UpdateEvent extends StatelessWidget {
  const UpdateEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventController eventController = Get.put(EventController());
    return ListView(
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
                  icon: Icon(Icons.camera_alt_sharp, color: Colors.black38),
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
          iconWidget: Icon(Icons.description, color: const Color(0xffFFB574)),

          textEditingController: eventController.eventDesController.value,
        ),
        smallSizedBox,
        AppWidget.textFormFiledForEvent(
          hintText: AppStrings.location,
          iconWidget: Icon(
              Icons.location_on_outlined, color: const Color(0xffFFB574)),

          textEditingController: eventController.eventLocationController.value,
        ),
        smallSizedBox,
        Container(
          height: 7.h,
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: paddingSymmetric(verticalPad: 1.w, horizontalPad: 2.w),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: ColorConstant.backGroundColorOrange)),
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
                                        () =>
                                        Text(
                                          eventController.selectedDate.value
                                              .toString()
                                              .isNotEmpty
                                              ? eventController.selectedDate
                                              .value
                                              : DateFormat('dd-MM-yyyy').format(
                                              DateTime.now()),
                                          style: AppStyles.smallerTextStyle
                                              .copyWith(
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
                                        () =>
                                        Text(
                                          eventController.selectedTime.value
                                              .toString()
                                              .isNotEmpty
                                              ? eventController.selectedTime
                                              .value
                                              : '7:00 PM',
                                          style: AppStyles.smallerTextStyle
                                              .copyWith(
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
        Obx(() =>
            AppWidget.elevatedButton(
                text: AppStrings.update,
                loading: eventController.isLoading.value,
                onTap: () async {
                  await eventController.updateEventApiCall();
                }),),
        mediumSizedBox,
      ],
    );
  }
}