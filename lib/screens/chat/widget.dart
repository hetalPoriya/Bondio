import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bondio/controller/controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../model/contact_list.dart';
import '../../model/model.dart';

class ChatWidget {
  static ChatController chatController = Get.put(ChatController());
  static AuthController authController = Get.put(AuthController());
  static HomeController homeController = Get.put(HomeController());
  static EventController eventController = Get.put(EventController());

  static Future<void> getUserInfo() async {
    AuthController authController = Get.put(AuthController());
    var response = await SharedPrefClass.getUserData();
    if (response.toString().isNotEmpty) {
      authController
          .userModel(LoginData.fromMap(jsonDecode(response.toString())));
      authController.userModel.refresh();
      authController.fullNameController.value.text =
          authController.userModel.value.user?.name.toString() ?? '';
      authController.lastNameController.value.text =
          authController.userModel.value.user?.lName.toString() ?? '';
      authController.zipCodeController.value.text =
          authController.userModel.value.user?.zipCode.toString() ?? '';
      authController.countryValue.value =
          authController.userModel.value.user?.country.toString() ?? '';
      authController.cityValue.value =
          authController.userModel.value.user?.city.toString() ?? '';
      authController.stateValue.value =
          authController.userModel.value.user?.state.toString() ?? '';
      authController.aboutMeController.value.text =
          authController.userModel.value.user?.aboutMe.toString() ?? '';
      authController.imageController.value.text =
          authController.userModel.value.user?.photoSocial.toString() ?? '';
      authController.update();
      chatController.userCollection
          .doc(authController.userModel.value.user?.id.toString())
          .update({
        ApiConstant.deviceToken:
            await chatController.getFirebaseMessagingToken()
      });
      log('UserResponse ${authController.userModel.value.toMap()}');
    }
  }

  static Widget chatContainer(
          {String? imageString,
          String? photoSocial,
          String? titleText,
          String? subText,
          String? time,
          int? chatCount,
          bool? isNotRead,
          bool? isPinned}) =>
      Material(
        elevation: 2.w,
        borderRadius: BorderRadius.circular(4.w),
        child: Container(
          height: 10.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            color: Colors.white,
          ),
          child: Row(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: paddingAll(paddingAll: 4.w),
                    height: 6.h,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: ChatWidget.displayImage(
                                image: imageString, socialImage: photoSocial),
                            fit: BoxFit.contain)),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 4,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(titleText ?? ' ',
                                  style: AppStyles.mediumTextStyle
                                      .copyWith(color: Colors.black))),
                          Expanded(
                              child: Text(
                                  DateFormat('kk:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(time.toString()))),
                                  style: AppStyles.smallerTextStyle.copyWith(
                                      fontSize: 8.sp, color: Colors.black))),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 2.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subText ?? ' ',
                              maxLines: 2,
                              style: AppStyles.smallerTextStyle
                                  .copyWith(color: Colors.grey.shade800),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                if (isNotRead == false)
                                  CircleAvatar(
                                      minRadius: 12,
                                      maxRadius: 12,
                                      backgroundColor: Colors.green,
                                      child: Text(
                                        chatCount.toString(),
                                        style: AppStyles.smallTextStyle,
                                      )),
                                if (isPinned == true)
                                  Icon(
                                    Icons.archive,
                                    color: ColorConstant.greyBorder,
                                  ),
                              ],
                            )
                          ],
                        ),
                      )
                    ])),
          ]),
        ),
      );

  static Widget eventContainer(
          {String? imageString,
          required String title,
          required String description,
          required String date,
          required String time,
          required String invitedBy,
          required String memberList}) =>
      Material(
        elevation: 2.w,
        borderRadius: BorderRadius.circular(4.w),
        child: Container(
          height: 10.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  padding: paddingAll(paddingAll: 4.w),
                  height: 6.h,
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: ChatWidget.displayImage(image: imageString),
                          fit: BoxFit.cover)),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: AppStyles.smallTextStyle.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                          ),
                          // Text(
                          //   '($memberList)Invited',
                          //   style: AppStyles.smallerTextStyle
                          //       .copyWith(fontSize: 8.sp, color: Colors.black),
                          //   maxLines: 2,
                          // ),
                        ],
                      ),
                      Text(
                        description,
                        style: AppStyles.smallerTextStyle
                            .copyWith(color: Colors.black, fontSize: 9.sp),
                        maxLines: 2,
                      )
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    // color: Colors.grey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            date,
                            style: AppStyles.smallerTextStyle
                                .copyWith(fontSize: 9.sp, color: Colors.black),
                          ),
                          SizedBox(height: 1.w),
                          Text(
                            time,
                            style: AppStyles.smallerTextStyle.copyWith(
                                fontSize: 7.sp,
                                color: ColorConstant.backGroundColorOrange),
                          ),
                          SizedBox(height: 1.w),
                          if (invitedBy.toString().isNotEmpty)
                            Text(
                              invitedBy,
                              style: AppStyles.smallerTextStyle.copyWith(
                                  fontSize: 7.sp,
                                  color: ColorConstant.backGroundColorOrange),
                            )
                        ]),
                  )),
            ],
          ),
        ),
      );

  static Widget customDrawer() => Container();

  static Widget appBarWidget({String? userName, String? status}) => SizedBox(
        height: 10.h,
        child: Row(
          children: [
            Expanded(
                child: CircleAvatar(
              maxRadius: 4.h,
              minRadius: 4.h,
              backgroundColor: Colors.black38,
            )),
            Expanded(
                flex: 4,
                child: Padding(
                    padding:
                        paddingSymmetric(horizontalPad: 2.w, verticalPad: 00),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userName ?? 'Jack hem',
                          style: AppStyles.mediumTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(status ?? 'Online',
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.smallerTextStyle)
                      ],
                    ))),
          ],
        ),
      );

  static Widget imageCircleAvatar(
          {Uint8List? imageString, required BuildContext context}) =>
      SizedBox(
        height: 6.h,
        width: MediaQuery.of(context).size.width,
        child: (imageString != null && imageString.isNotEmpty)
            ? CircleAvatar(
                backgroundImage: MemoryImage(imageString),
              )
            : CircleAvatar(
                backgroundColor: ColorConstant.backGroundColorOrange,
                child: Image.asset(AppAssets.user,
                    height: 3.h, color: Colors.white),
              ),
      );

  static Widget noConversionFound() => Column(
        children: [
          largeSizedBox,
          largeSizedBox,
          largeSizedBox,
          Center(
            child: Text(
              'No Conversion found',
              style: AppStyles.smallTextStyle.copyWith(color: Colors.grey),
            ),
          ),
        ],
      );

  static showDialogForImage({required BuildContext context}) {
    return Get.defaultDialog(
        title: 'From where do you want to take the photo?',
        titleStyle: AppStyles.mediumTextStyle.copyWith(color: Colors.grey),
        contentPadding: EdgeInsets.zero,
        content: Padding(
          padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    pickFromGalley();
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
                    pickFromCamera();
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

  static pickFromGalley() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    chatController.pickedImage?.value = File(image.path);
    authController.imageController.value.clear();
    authController.update();
    await authController.updateProfileApiCall(imagePath: File(image.path));
    // firebaseController.uploadPic(image: File(image.path));
    chatController.update();
  }

  static pickFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    chatController.pickedImage?.value = File(image.path);
    authController.imageController.value.clear();
    authController.update();
    await authController.updateProfileApiCall(imagePath: File(image.path));
    // firebaseController.uploadPic(image: File(image.path));
    chatController.update();
  }

  static displayImage({String? image, String? socialImage}) {
    return (socialImage?.isNotEmpty == true && socialImage.toString() != 'null')
        ? NetworkImage(socialImage.toString())
        : ((image.toString().isEmpty || image.toString() == ' '))
            ? AssetImage(AppAssets.addContact) as ImageProvider
            : NetworkImage('${ApiConstant.imageBaseUrl}${image.toString()}');
  }

  static Future fetchContacts() async {
    chatController.searchControllerForContact.value.clear();
    chatController.contacts.value = [];
    chatController.contacts.refresh();
    chatController.searchContactListModel.value = [];
    chatController.searchContactListModel.refresh();
    chatController.availableChatPersonFromContacts.value = [];
    eventController.eventPeopleList.value = [];
    chatController.availableChatPersonFromContacts.refresh();
    chatController.update();

    // List<Contact> loadedList =
    //     await SharedPrefClass.getListFromSharedPreferences();
    //
    // // chatController.contacts.value = loadedList;
    // // chatController.update();
    // //
    // // log(loadedList.length.toString());
    // // log('${chatController.contacts.length}');
    // // log('${chatController.contacts.toString()}');
    // if (!await FlutterContacts.requestPermission(readonly: true)) {
    // } else {
    //   FlutterContacts.getContacts(withProperties: true, withPhoto: true)
    //       .then((contacts) {
    //     chatController.contacts.addAll(contacts);
    //     chatController.contacts.asMap().entries.map((e) async {
    //       if (chatController.contacts[e.key].phones.isNotEmpty) {
    //         await chatController.contactCollection
    //             .doc(chatController
    //                 .contacts[e.key].phones.first.normalizedNumber
    //                 .toString())
    //             .get()
    //             .then((value) {
    //           if (value.exists) {
    //             chatController.contacts[e.key].status = value.get('status');
    //             chatController.contacts[e.key].loginId = value.get('id');
    //             chatController.contacts.refresh();
    //             chatController.update();
    //             if (chatController.contacts[e.key].status == 'Chat') {
    //               chatController.availableChatPersonFromContacts
    //                   .add(chatController.contacts[e.key]);
    //               chatController.availableChatPersonFromContacts.refresh();
    //             }
    //             chatController.contacts.refresh();
    //           }
    //         });
    //       }
    //     }).toList();
    //   }).then((value) async {
    //     SharedPrefClass.saveListToSharedPreferences(
    //         chatController.contacts.value);
    //
    //     // List<Contact> loadedList = await SharedPrefClass.getListFromSharedPreferences();
    //     // setState(() {
    //     //   persons = loadedList;
    //     // });
    //   });
    // }
    // List<Contact> loadedList =
    //     await SharedPrefClass.getListFromSharedPreferences();
    //
    // // chatController.contacts.value = loadedList;
    // // chatController.update();
    // //
    // // log(loadedList.length.toString());
    // // log('${chatController.contacts.length}');
    // // log('${chatController.contacts.toString()}');
    // if (!await FlutterContacts.requestPermission(readonly: true)) {
    // } else {
    //   FlutterContacts.getContacts(withProperties: true, withPhoto: true)
    //       .then((contacts) {
    //     chatController.contacts.addAll(contacts);
    //     chatController.contacts.asMap().entries.map((e) async {
    //       if (chatController.contacts[e.key].phones.isNotEmpty) {
    //         await chatController.contactCollection
    //             .doc(chatController
    //                 .contacts[e.key].phones.first.normalizedNumber
    //                 .toString())
    //             .get()
    //             .then((value) {
    //           if (value.exists) {
    //             chatController.contacts[e.key].status = value.get('status');
    //             chatController.contacts[e.key].loginId = value.get('id');
    //             chatController.contacts.refresh();
    //             chatController.update();
    //             if (chatController.contacts[e.key].status == 'Chat') {
    //               chatController.availableChatPersonFromContacts
    //                   .add(chatController.contacts[e.key]);
    //               chatController.availableChatPersonFromContacts.refresh();
    //             }
    //             chatController.contacts.refresh();
    //           }
    //         });
    //       }
    //     }).toList();
    //   }).then((value) async {
    //     SharedPrefClass.saveListToSharedPreferences(
    //         chatController.contacts.value);
    //
    //     // List<Contact> loadedList = await SharedPrefClass.getListFromSharedPreferences();
    //     // setState(() {
    //     //   persons = loadedList;
    //     // });
    //   });
    // }

    List<ContactListModel> loadedList =
        await SharedPrefClass.getListFromSharedPreferences(
            sharedPrefString: SharedPrefStrings.myContacts);
    List<ContactListModel> availableList =
        await SharedPrefClass.getListFromSharedPreferences(
            sharedPrefString: SharedPrefStrings.availableContacts);

    log(' RERRERERER ${await FlutterContacts.requestPermission(readonly: true)}');

    if (await FlutterContacts.requestPermission(readonly: true) == false) {
      await FlutterContacts.requestPermission(readonly: true);
      AppWidget.toast(
          text: 'Please give contact permission to find you friends',
          toastLength: Toast.LENGTH_LONG);
      openAppSettings();
    } else {
      chatController.isLoading.value = true;
      chatController.update();
      log('Contact Get');

      if (loadedList.isNotEmpty) {
        chatController.contacts.value = loadedList;
        chatController.availableChatPersonFromContacts.value = availableList;
        chatController.update();
        chatController.contacts.refresh();
        chatController.availableChatPersonFromContacts.refresh();
      } else {
        FlutterContacts.getContacts(withProperties: true, withPhoto: true)
            .then((contacts) async {
          contacts.map((data) {
            String phone = data.phones.isNotEmpty
                ? data.phones.first.normalizedNumber.toString().isNotEmpty
                    ? data.phones.first.normalizedNumber.toString()
                    : 'none'
                : 'none';

            chatController.contactCollection.doc(phone).get().then((value) {
              if (value.exists) {
                chatController.contacts.add(ContactListModel(
                    id: value.get('id'),
                    name: data.displayName,
                    phoneNumber: phone,
                    status: value.get('status')));
                chatController.contacts.refresh();
                chatController.update();
                SharedPrefClass.saveListToSharedPreferences(
                    con: chatController.contacts,
                    sharedPrefString: SharedPrefStrings.myContacts);
                if (value.get('status') == 'Chat') {
                  chatController.availableChatPersonFromContacts.add(
                      ContactListModel(
                          id: value.get('id'),
                          name: data.displayName,
                          phoneNumber: phone,
                          status: value.get('status')));
                  chatController.availableChatPersonFromContacts.refresh();
                  chatController.update();
                  SharedPrefClass.saveListToSharedPreferences(
                      con: chatController.availableChatPersonFromContacts,
                      sharedPrefString: SharedPrefStrings.availableContacts);
                }
              } else {
                chatController.contacts.add(ContactListModel(
                    id: data.loginId,
                    name: data.displayName,
                    phoneNumber: phone,
                    status: data.status.toString()));
                chatController.contacts.refresh();
                chatController.update();
                SharedPrefClass.saveListToSharedPreferences(
                    con: chatController.contacts,
                    sharedPrefString: SharedPrefStrings.myContacts);
              }
            });
            // SharedPrefClass.saveListToSharedPreferences(
            //     chatController.contacts.value);

            //log('contactList ${chatController.contacts.value.first.toMap()}');
            // log('ISEXITS ${isExits}');
            // return ContactListModel(
            //     id: data.loginId,
            //     name: data.displayName,
            //     phoneNumber: phone,
            //     status: data.status.toString());
          }).toList();

          // SharedPrefClass.saveListToSharedPreferences(
          //     chatController.contacts.value);
          // log('contactList ${chatController.contacts.value.length}');
          // log('contactList ${chatController.contacts.value.first.toMap()}');

          // chatController.contacts.asMap().entries.map((data) async {
          //   if (chatController.contacts[data.key].phoneNumber
          //       .toString()
          //       .isNotEmpty) {
          //     await chatController.contactCollection
          //         .doc(chatController.contacts[data.key].phoneNumber
          //                 .toString()
          //                 .isNotEmpty
          //             ? chatController.contacts[data.key].phoneNumber
          //             : 'none')
          //         .get()
          //         .then((value) {
          //       log('ENter');
          //       if (value.exists) {
          //         log('MYNUMBER ${chatController.contacts[data.key].phoneNumber}');
          //         chatController.contacts[data.key].status = value.get('status');
          //         chatController.contacts[data.key].id = value.get('id');
          //
          //         chatController.contacts.refresh();
          //         chatController.update();
          //         SharedPrefClass.saveListToSharedPreferences(
          //             chatController.contacts.value);
          //
          //         if (chatController.contacts[data.key].status == 'Chat') {
          //           chatController.availableChatPersonFromContacts.add(data);
          //           chatController.availableChatPersonFromContacts.refresh();
          //           chatController.update();
          //         }
          //         chatController.contacts.refresh();
          //       }
          //     });
          //     SharedPrefClass.saveListToSharedPreferences(
          //         chatController.contacts.value);
          //   }
          // });
        });
        // }

        // chatController.contacts.addAll(contacts);
        // chatController.contacts.asMap().entries.map((e) async {
        //   if (chatController.contacts[e.key].phones.isNotEmpty) {
        //     await chatController.contactCollection
        //         .doc(chatController
        //             .contacts[e.key].phones.first.normalizedNumber
        //             .toString())
        //         .get()
        //         .then((value) {
        //       if (value.exists) {
        //         chatController.contacts[e.key].status = value.get('status');
        //         chatController.contacts[e.key].loginId = value.get('id');
        //         chatController.contacts.refresh();
        //         chatController.update();
        //         if (chatController.contacts[e.key].status == 'Chat') {
        //           chatController.availableChatPersonFromContacts
        //               .add(chatController.contacts[e.key]);
        //           chatController.availableChatPersonFromContacts.refresh();
        //         }
        //         chatController.contacts.refresh();
        //       }
        //     });
      }

      chatController.isLoading.value = false;
      chatController.update();
    }
  }

  static tabContainer(
          {required String text,
          required int index,
          required List<Color> color,
          required Color textColor,
          required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
            height: 3.h,
            width: 21.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.w),
                color: Colors.white,
                gradient: LinearGradient(colors: color),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, spreadRadius: 1, blurRadius: 6)
                ]),
            child: Text(
              text,
              style: AppStyles.smallerTextStyle.copyWith(color: textColor),
            )),
      );
}