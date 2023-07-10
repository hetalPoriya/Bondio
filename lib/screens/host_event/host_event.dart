import 'dart:io';
import 'package:bondio/controller/controller.dart';
import 'package:bondio/screens/host_event/host.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class HostEvent extends StatefulWidget {
  HostEvent({Key? key}) : super(key: key);

  @override
  State<HostEvent> createState() => _HostEventState();
}

class _HostEventState extends State<HostEvent> {
  EventController eventController = Get.put(EventController());

  HomeController homeController = Get.put(HomeController());
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
    homeController.hostEvent.value == 1
        ? Form(
      key: _formkey,
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
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
          AppWidget.textFormFiledForEvent(
              hintText: AppStrings.eventTitle,
              iconWidget: IconButton(
                onPressed: () {
                  // showDialogForImage(
                  //     context: context, eventController: eventController);
                },
                icon: const Icon(Icons.camera_alt_sharp,
                    color: Color(0xffFFB574)),
              ),
              textEditingController:
              eventController.eventTitleController.value,
              validator: FormValidation.emptyValidation(
                  value:
                  eventController.eventTitleController.value.text)),
          smallSizedBox,
          AppWidget.textFormFiledForEvent(
            hintText: AppStrings.description,
            validator: FormValidation.emptyValidation(
                value: eventController.eventDesController.value.text),
            iconWidget:
            const Icon(Icons.description, color: Color(0xffFFB574)),
            textEditingController:
            eventController.eventDesController.value,
          ),

          smallSizedBox,
          Container(
            height: 7.h,
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding:
            paddingSymmetric(verticalPad: 1.w, horizontalPad: 2.w),
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
                                          () =>
                                          Text(
                                            eventController.selectedDate.value
                                                .toString()
                                                .isNotEmpty
                                                ? eventController.selectedDate
                                                .value
                                                : DateFormat('dd-MM-yyyy')
                                                .format(DateTime.now()),
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
                                      color: ColorConstant
                                          .backGroundColorOrange),
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
                                      color: ColorConstant
                                          .backGroundColorOrange),
                                )
                              ],
                            ))
                      ],
                    ),
                  ))
            ]),
          ),
          smallSizedBox,
          AppWidget.textFormFiledForEvent(
            hintText: AppStrings.location,
            validator: FormValidation.emptyValidation(
                value:
                eventController.eventLocationController.value.text),
            iconWidget: const Icon(Icons.location_on_outlined,
                color: Color(0xffFFB574)),
            textEditingController:
            eventController.eventLocationController.value,
          ),
          mediumSizedBox,
          AppWidget.elevatedButton(
              text: AppStrings.invitePeople,
              onTap: () {
                if (SharedPrefClass.getBool(
                    SharedPrefStrings.isLogin, false) ==
                    false) {
                  AppWidget.toast(
                      text: 'Please log in first to host an event');
                } else {
                  if (_formkey.currentState!.validate()) {
                    homeController.hostEvent.value = 2;
                    homeController.update();
                  }
                }
              }),
          mediumSizedBox,
        ],
      ),
    )
        : const InvitePeopleForEvent());
  }

  static showDialogForImage({required BuildContext context,
    required EventController eventController}) {
    return Get.defaultDialog(
        title: 'From where do you want to take the photo?',
        titleStyle: AppStyles.mediumTextStyle.copyWith(color: Colors.grey),
        contentPadding: EdgeInsets.zero,
        content: Padding(
          padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 0),
          child: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    pickFromGalley(eventController);
                  },
                  child: Text(
                    'Gallery',
                    style:
                    AppStyles.smallTextStyle.copyWith(color: Colors.black),
                  ),
                ),
                smallerSizedBox,
                GestureDetector(
                  onTap: () {
                    Get.back();
                    pickFromCamera(eventController);
                  },
                  child: Text(
                    'Camera',
                    style:
                    AppStyles.smallTextStyle.copyWith(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  static pickFromGalley(EventController eventController) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    eventController.pickedImageForEvent?.value = File(image.path);

    eventController.update();
  }

  static pickFromCamera(EventController eventController) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    eventController.pickedImageForEvent?.value = File(image.path);
    eventController.update();
  }
}