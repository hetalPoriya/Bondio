import 'dart:developer';
import 'package:bondio/controller/controller.dart';
import 'package:bondio/model/get_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';

import '../model/contact_list.dart';

class EventController extends GetxController {
  RxBool isLoading = false.obs;
  final eventTitleController = TextEditingController().obs;
  final eventDesController = TextEditingController().obs;
  final eventLocationController = TextEditingController().obs;
  final selectedDate = ''.obs;
  final selectedTime = ''.obs;
  final startTime = ''.obs;
  final endTime = ''.obs;
  final eventId = ''.obs;
  RxString memberList = ''.obs;

  Rx<GetEvent> getEventList = GetEvent().obs;
  Rx<GetEventList> customerList = GetEventList().obs;

  Dio dio = Dio();

  RxList<ContactListModel> eventPeopleList = <ContactListModel>[].obs;
  AuthController authController = Get.put(AuthController());
  HomeController homeController = Get.put(HomeController());
  ChatController chatController = Get.put(ChatController());

  getEventApiCall() async {
    try {
      isLoading(true);

      var response = await dio.get(
        ApiConstant.buildUrl(ApiConstant.getEventApi),
        options: NetworkHandler.options,
      );

      log('GetEvents ${response.data.toString()}');
      if (response.data['Status'] == true) {
        getEventList.value.data = [];
        GetEvent data = GetEvent.fromMap(response.data);
        getEventList(data);
      } else {
        AppWidget.toast(text: response.data['Msg'].toString());
      }
    } finally {
      isLoading(false);
    }
  }

  updateEventApiCall() async {
    try {
      isLoading(true);
      CreateEventBody createEvent = CreateEventBody(
          name: eventTitleController.value.text.toString(),
          description: eventDesController.value.text.toString(),
          date: selectedDate.toString(),
          time: selectedTime.value.toString(),
          location: eventLocationController.value.text.toString(),
          photo: '',
          id: eventId.toString() ?? '',
          users: memberList.toString());

      log(ApiConstant.buildUrl(ApiConstant.updateEventApi));
      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.updateEventApi),
        data: createEventToMap(createEvent),
        options: NetworkHandler.options,
      );

      if (response.data['Status'] == true) {
        AppWidget.toast(text: 'Event update successfully');
        homeController.hostEvent.value = 0;
        eventId.value = '';
        eventTitleController.value.clear();
        eventDesController.value.clear();
        eventLocationController.value.clear();

        homeController.update();
      } else {
        AppWidget.toast(text: response.data['Msg'].toString());
      }
    } finally {
      isLoading(false);
    }
  }

  createEventApiCall() async {
    try {
      isLoading(true);
      CreateEventBody createEvent = CreateEventBody(
          name: eventTitleController.value.text.toString(),
          description: eventDesController.value.text.toString(),
          date: selectedDate.toString(),
          time: selectedTime.value.toString(),
          location: eventLocationController.value.text.toString(),
          photo: '',
          users: memberList.toString());

      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.createEventApi),
        data: createEventToMap(createEvent),
        options: NetworkHandler.options,
      );

      if (response.data['Status'] == true) {
        AppWidget.toast(text: 'Event added successfully');

        chatController
            .createGroup(
                userName: authController.userModel.value.user?.name ?? '',
                groupName: eventTitleController.value.text,
                eventDes: eventDesController.value.text,
                isEvent: true,
                eventDate: selectedDate.value.toString())
            .then((value) {
          homeController.selectedIndex.value = 1;
          homeController.innerTabSelectedIndex.value = 1;
          homeController.update();
        });

        eventId.value = '';
        eventTitleController.value.clear();
        eventDesController.value.clear();
        eventLocationController.value.clear();
      } else {
        AppWidget.toast(text: response.data['Msg'].toString());
      }
    } finally {
      isLoading(false);
    }
  }
}
