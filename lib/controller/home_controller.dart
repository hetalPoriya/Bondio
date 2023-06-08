import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<Text> titleWidget = const Text('').obs;

  //for display personal chat
  RxBool personalChatPage = false.obs;
  RxBool personalGroupChatPage = false.obs;

  //home page 3 tab which one selected
  RxInt selectedIndex = 0.obs;

  //host Event index
  RxInt hostEvent = 0.obs;
  RxInt viewEvent = 0.obs;


  //chat main page (chat and group) which tab selected
  RxInt innerTabSelectedIndex = 0.obs;
  RxInt hostEventTabSelectedIndex = 0.obs;

  //tap on groupMember add
  RxBool onTapOnAddGroupMember = false.obs;

  //tap on group created set name
  RxBool onTapOnGroupCreate = false.obs;

  //when tap on add contact icon
  RxBool onTapOnAddContact = false.obs;

  File? pickedImage;
}
