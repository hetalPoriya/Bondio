import 'dart:developer';
import 'dart:io';
import 'package:bondio/controller/controller.dart';
import 'package:bondio/model/model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';

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
  RxString addMembers = ''.obs;

  Rx<File?>? pickedImageForEvent;

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
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${authController.userModel.value.token.toString()}'
        }),
      );

      if (response.data['Status'] == true) {
        getEventList.value.data = [];
        GetEvent data = GetEvent.fromMap(response.data);
        getEventList(data);
        log(getEventList.value.data!.length.toString());
      } else {
        AppWidget.toast(text: response.data['Msg'].toString());
      }
    } on DioError catch (e) {
      AppWidget.toast(text: e.toString());
    } finally {
      isLoading(false);
    }
  }

  updateEventApiCall() async {
    try {
      isLoading(true);

      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.updateEventApi),
        data: FormData.fromMap({
          "name": eventTitleController.value.text.toString(),
          "description": eventDesController.value.text.toString(),
          "date": selectedDate.toString(),
          "time": selectedTime.value.toString(),
          "location": eventLocationController.value.text.toString(),
          "id": eventId.value,
        }),
        options: NetworkHandler.options,
      );

      if (response.data['Status'] == true) {
        UpdateEventModel updateEvent = UpdateEventModel.fromMap(response.data);

        chatController.groupChatRoomCollection
            .doc(updateEvent.data?.id.toString())
            .update({
          ApiConstant.groupName: updateEvent.data?.name ?? '',
          ApiConstant.eventDescription: updateEvent.data?.description ?? '',
          ApiConstant.eventDate: updateEvent.data?.date ?? '',
          ApiConstant.eventTimeChat: updateEvent.data?.time ?? '',
          ApiConstant.eventLocation: updateEvent.data?.location ?? '',
        });
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

  updateEventNameApiCall(
      {required String eventId, required String name}) async {
    try {
      isLoading(true);

      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.updateEventApi),
        data: FormData.fromMap({
          "name": name,
          "id": eventId,
        }),
        options: NetworkHandler.options,
      );

      if (response.data['Status'] == true) {
        UpdateEventModel updateEvent = UpdateEventModel.fromMap(response.data);

        chatController.groupChatRoomCollection
            .doc(chatController.groupInfo.value.groupId.toString())
            .update({ApiConstant.groupName: updateEvent.data?.name.toString()});
      } else {
        AppWidget.toast(text: response.data['Msg'].toString());
      }
    } finally {
      isLoading(false);
    }
  }

  updateEventMembersApiCall(
      {required String eventMembers, required String eventId}) async {
    try {
      isLoading(true);
      log(ApiConstant.buildUrl(ApiConstant.updateEventApi));
      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.updateEventApi),
        data:
            FormData.fromMap({'id': eventId, 'users': eventMembers.toString()}),
        options: NetworkHandler.options,
      );

      if (response.data['Status'] == true) {
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
      String members = '';
      var value = eventPeopleList.map((e) => e.id.toString()).toList();
      members = value.join(',');

      log('Memerrs ${members}');
      var response = await dio.post(
        ApiConstant.buildUrl(ApiConstant.createEventApi),
        data: FormData.fromMap({
          'name': eventTitleController.value.text.toString(),
          'description': eventDesController.value.text.toString(),
          'date': selectedDate.toString().isEmpty
              ? DateFormat('dd-MM-yyyy').format(DateTime.now())
              : selectedDate.value.toString(),
          'time': selectedTime.value.isEmpty
              ? '7:00 PM'
              : selectedTime.value.toString(),
          'location': eventLocationController.value.text.toString(),
          'photo': ' ',
          'users': members.toString()
        }),
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${authController.userModel.value.token.toString()}'
        }),
      );

      if (response.data['Status'] == true) {
        AppWidget.toast(text: 'Event added successfully');
        UpdateEventModel updateEvent = UpdateEventModel.fromMap(response.data);
        log("Update Event ${updateEvent.data?.id}");
        log("Update Event ${updateEvent.data?.toMap()}");
        chatController
            .createGroupEvent(
                userName: authController.userModel.value.user?.name ?? '',
                eventTitle: updateEvent.data?.name ?? '',
                eventDes: updateEvent.data?.description ?? '',
                isEvent: true,
                eventLocation: updateEvent.data?.location ?? '',
                eventId: updateEvent.data?.id.toString(),
                eventTime: updateEvent.data?.time ?? '',
                eventDate: updateEvent.data?.date ?? '')
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