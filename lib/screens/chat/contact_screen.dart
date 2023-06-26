import 'dart:convert';
import 'dart:developer';
import 'package:bondio/model/contact_list.dart';

import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:bondio/controller/controller.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ChatController chatController = Get.put(ChatController());
  HomeController homeController = Get.put(HomeController());
  AuthController authController = Get.put(AuthController());

  //  Future fetchContacts() async {
  //   chatController.searchControllerForContact.value.clear();
  //   chatController.contacts.value = [];
  //   chatController.contacts.refresh();
  //   chatController.searchContactListModel.value = [];
  //   chatController.searchContactListModel.refresh();
  //   chatController.availableChatPersonFromContacts.value = [];
  //   chatController.availableChatPersonFromContacts.refresh();
  //   chatController.update();
  //
  //   // List<Contact> loadedList =
  //   //     await SharedPrefClass.getListFromSharedPreferences();
  //   //
  //   // // chatController.contacts.value = loadedList;
  //   // // chatController.update();
  //   // //
  //   // // log(loadedList.length.toString());
  //   // // log('${chatController.contacts.length}');
  //   // // log('${chatController.contacts.toString()}');
  //   // if (!await FlutterContacts.requestPermission(readonly: true)) {
  //   // } else {
  //   //   FlutterContacts.getContacts(withProperties: true, withPhoto: true)
  //   //       .then((contacts) {
  //   //     chatController.contacts.addAll(contacts);
  //   //     chatController.contacts.asMap().entries.map((e) async {
  //   //       if (chatController.contacts[e.key].phones.isNotEmpty) {
  //   //         await chatController.contactCollection
  //   //             .doc(chatController
  //   //                 .contacts[e.key].phones.first.normalizedNumber
  //   //                 .toString())
  //   //             .get()
  //   //             .then((value) {
  //   //           if (value.exists) {
  //   //             chatController.contacts[e.key].status = value.get('status');
  //   //             chatController.contacts[e.key].loginId = value.get('id');
  //   //             chatController.contacts.refresh();
  //   //             chatController.update();
  //   //             if (chatController.contacts[e.key].status == 'Chat') {
  //   //               chatController.availableChatPersonFromContacts
  //   //                   .add(chatController.contacts[e.key]);
  //   //               chatController.availableChatPersonFromContacts.refresh();
  //   //             }
  //   //             chatController.contacts.refresh();
  //   //           }
  //   //         });
  //   //       }
  //   //     }).toList();
  //   //   }).then((value) async {
  //   //     SharedPrefClass.saveListToSharedPreferences(
  //   //         chatController.contacts.value);
  //   //
  //   //     // List<Contact> loadedList = await SharedPrefClass.getListFromSharedPreferences();
  //   //     // setState(() {
  //   //     //   persons = loadedList;
  //   //     // });
  //   //   });
  //   // }
  //
  //   List<ContactListModel> loadedList =
  //       await SharedPrefClass.getListFromSharedPreferences(
  //           sharedPrefString: SharedPrefStrings.myContacts);
  //   List<ContactListModel> availableList =
  //       await SharedPrefClass.getListFromSharedPreferences(
  //           sharedPrefString: SharedPrefStrings.availableContacts);
  //
  //   //log('MY SHERED ${loadedList.first.toMap()}');
  //
  //   if (!await FlutterContacts.requestPermission(readonly: true)) {
  //   } else {
  //     if (loadedList.isNotEmpty) {
  //       chatController.contacts.value = loadedList;
  //       chatController.availableChatPersonFromContacts.value = availableList;
  //       chatController.update();
  //       chatController.contacts.refresh();
  //       chatController.availableChatPersonFromContacts.refresh();
  //     } else {
  //       FlutterContacts.getContacts(withProperties: true, withPhoto: true)
  //           .then((contacts) async {
  //
  //         contacts.map((data) {
  //           String phone = data.phones.isNotEmpty
  //               ? data.phones.first.normalizedNumber.toString().isNotEmpty
  //                   ? data.phones.first.normalizedNumber.toString()
  //                   : 'none'
  //               : 'none';
  //
  //           chatController.contactCollection.doc(phone).get().then((value) {
  //             if (value.exists) {
  //               chatController.contacts.value.add(ContactListModel(
  //                   id: value.get('id'),
  //                   name: data.displayName,
  //                   phoneNumber: phone,
  //                   status: value.get('status')));
  //               chatController.contacts.refresh();
  //               chatController.update();
  //               SharedPrefClass.saveListToSharedPreferences(
  //                   con: chatController.contacts.value,
  //                   sharedPrefString: SharedPrefStrings.myContacts);
  //               if (value.get('status') == 'Chat') {
  //                 chatController.availableChatPersonFromContacts.add(
  //                     ContactListModel(
  //                         id: value.get('id'),
  //                         name: data.displayName,
  //                         phoneNumber: phone,
  //                         status: value.get('status')));
  //                 chatController.availableChatPersonFromContacts.refresh();
  //                 chatController.update();
  //                 SharedPrefClass.saveListToSharedPreferences(
  //                     con: chatController.availableChatPersonFromContacts.value,
  //                     sharedPrefString: SharedPrefStrings.availableContacts);
  //
  //               }
  //             } else {
  //               chatController.contacts.value.add(ContactListModel(
  //                   id: data.loginId,
  //                   name: data.displayName,
  //                   phoneNumber: phone,
  //                   status: data.status.toString()));
  //               chatController.contacts.refresh();
  //               chatController.update();
  //               SharedPrefClass.saveListToSharedPreferences(
  //                   con: chatController.contacts.value,
  //                   sharedPrefString: SharedPrefStrings.myContacts);
  //
  //             }
  //           });
  //           // SharedPrefClass.saveListToSharedPreferences(
  //           //     chatController.contacts.value);
  //
  //           //log('contactList ${chatController.contacts.value.first.toMap()}');
  //           // log('ISEXITS ${isExits}');
  //           // return ContactListModel(
  //           //     id: data.loginId,
  //           //     name: data.displayName,
  //           //     phoneNumber: phone,
  //           //     status: data.status.toString());
  //         }).toList();
  //
  //         // SharedPrefClass.saveListToSharedPreferences(
  //         //     chatController.contacts.value);
  //         // log('contactList ${chatController.contacts.value.length}');
  //         // log('contactList ${chatController.contacts.value.first.toMap()}');
  //
  //         // chatController.contacts.asMap().entries.map((data) async {
  //         //   if (chatController.contacts[data.key].phoneNumber
  //         //       .toString()
  //         //       .isNotEmpty) {
  //         //     await chatController.contactCollection
  //         //         .doc(chatController.contacts[data.key].phoneNumber
  //         //                 .toString()
  //         //                 .isNotEmpty
  //         //             ? chatController.contacts[data.key].phoneNumber
  //         //             : 'none')
  //         //         .get()
  //         //         .then((value) {
  //         //       log('ENter');
  //         //       if (value.exists) {
  //         //         log('MYNUMBER ${chatController.contacts[data.key].phoneNumber}');
  //         //         chatController.contacts[data.key].status = value.get('status');
  //         //         chatController.contacts[data.key].id = value.get('id');
  //         //
  //         //         chatController.contacts.refresh();
  //         //         chatController.update();
  //         //         SharedPrefClass.saveListToSharedPreferences(
  //         //             chatController.contacts.value);
  //         //
  //         //         if (chatController.contacts[data.key].status == 'Chat') {
  //         //           chatController.availableChatPersonFromContacts.add(data);
  //         //           chatController.availableChatPersonFromContacts.refresh();
  //         //           chatController.update();
  //         //         }
  //         //         chatController.contacts.refresh();
  //         //       }
  //         //     });
  //         //     SharedPrefClass.saveListToSharedPreferences(
  //         //         chatController.contacts.value);
  //         //   }
  //         // });
  //       });
  //       // }
  //
  //       // chatController.contacts.addAll(contacts);
  //       // chatController.contacts.asMap().entries.map((e) async {
  //       //   if (chatController.contacts[e.key].phones.isNotEmpty) {
  //       //     await chatController.contactCollection
  //       //         .doc(chatController
  //       //             .contacts[e.key].phones.first.normalizedNumber
  //       //             .toString())
  //       //         .get()
  //       //         .then((value) {
  //       //       if (value.exists) {
  //       //         chatController.contacts[e.key].status = value.get('status');
  //       //         chatController.contacts[e.key].loginId = value.get('id');
  //       //         chatController.contacts.refresh();
  //       //         chatController.update();
  //       //         if (chatController.contacts[e.key].status == 'Chat') {
  //       //           chatController.availableChatPersonFromContacts
  //       //               .add(chatController.contacts[e.key]);
  //       //           chatController.availableChatPersonFromContacts.refresh();
  //       //         }
  //       //         chatController.contacts.refresh();
  //       //       }
  //       //     });
  //     }
  //     // }).toList();
  //   }
  // }

  @override
  void initState() {
    ChatWidget.fetchContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 00),
            child: Column(children: [
              smallSizedBox,
              AppWidget.bondioTextAndMenu(context: context),
              smallSizedBox,
              AppWidget.containerWithLinearColor(
                  onTap: () {
                    homeController.onTapOnAddContact.value = false;
                    homeController.update();
                  },
                  height: 11.h,
                  widget: Padding(
                    padding:
                        paddingSymmetric(horizontalPad: 2.w, verticalPad: 00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.inviteYourFriend,
                          textAlign: TextAlign.start,
                          style: AppStyles.smallTextStyle
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () => AppWidget.toast(text: 'Coming soon'),
                          child: Container(
                            width: 15.w,
                            height: 5.h,
                            alignment: Alignment.center,
                            // padding: paddingSymmetric(
                            //     horizontalPad: 3.w, verticalPad: 2.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.w),
                                color: Colors.white),
                            child: Text(
                              'Host',
                              style: AppStyles.smallerTextStyle
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              smallSizedBox,
              Obx(() => AppWidget.searchField(
                    controller: chatController.searchControllerForContact.value,
                    onChanged: (v) => _searchData(searchString: v),
                    onFieldSubmitted: (v) => _searchData(searchString: v),
                  )),
              smallerSizedBox,
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.contact_page_outlined,
                          size: 5.w, color: Colors.grey.shade400),
                      Text(
                        'From contact',
                        style: AppStyles.smallerTextStyle
                            .copyWith(fontSize: 8.sp, color: Colors.grey),
                      )
                    ]),
              ),
              smallerSizedBox,
              Expanded(
                  child: Obx(
                () => (chatController.contacts.isNotEmpty &&
                        chatController.contacts != [])
                    ? Obx(
                        () => (chatController
                                    .searchContactListModel.isNotEmpty &&
                                chatController.searchContactListModel != [])
                            ? Obx(
                                () => listViewBuilder(
                                    listModel:
                                        chatController.searchContactListModel),
                              )
                            : Obx(
                                () => listViewBuilder(
                                    listModel: chatController.contacts),
                              ),
                      )
                    : AppWidget.progressIndicator(),
              ))
            ]),
          ),
        ),
      ),
    );
  }

  listViewBuilder({required List? listModel}) {
    log('Model A${listModel?.first.toString()}');

    return chatController.isLoading.value == true
        ? AppWidget.progressIndicator()
        : listModel!.isEmpty
            ? Center(
                child: Text(
                  'No Contact Found',
                  style: AppStyles.smallTextStyle.copyWith(color: Colors.grey),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: listModel.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  ContactListModel contactListModel = listModel[index];

                  return Column(
                    children: [
                      SizedBox(
                        height: 7.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ChatWidget.imageCircleAvatar(
                                  context: context),
                            ),
                            Expanded(
                              flex: 4,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            contactListModel.name ?? '',
                                            style: AppStyles.smallTextStyle
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            contactListModel.phoneNumber ??
                                                '(none)',
                                            style: AppStyles.smallTextStyle
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: contactListModel.status == 'Invite'
                                          ? inviteButton(
                                              index: index,
                                              phoneNumber: contactListModel
                                                      .phoneNumber ??
                                                  '',
                                              userName:
                                                  contactListModel.name ?? '')
                                          : contactListModel.status == 'Invited'
                                              ? invitedButton()
                                              : chatButton(
                                                  phoneNumber: contactListModel
                                                          .phoneNumber ??
                                                      ' ',
                                                ),
                                    )
                                  ]),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 15.w,
                        ),
                        child: const Divider(),
                      )
                    ],
                  );
                }));
  }

  String createRoom({
    required String userId,
    required String peerId,
  }) {
    if (userId.hashCode <= peerId.hashCode) {
      chatController.createRoomAndAddToList(
        userId: userId,
        peerId: peerId,
        roomId: '$userId-$peerId',
      );
      return "$userId-$peerId";
    } else {
      chatController.createRoomAndAddToList(
        userId: userId,
        peerId: peerId,
        roomId: '$peerId-$userId',
      );
      return "$peerId-$userId";
    }
  }

  inviteButton(
          {required int index,
          required String phoneNumber,
          required userName}) =>
      GestureDetector(
        onTap: SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) ==
                false
            ? () {
                AppWidget.toast(text: 'Please sign up first');
                Get.toNamed(RouteHelper.signUpPage);
              }
            : () async {
                log('Pe ${await Permission.sms.status.isDenied}');
                log('Pe ${await Permission.sms.status.isPermanentlyDenied}');
                // await Permission.sms.request();
                if (await Permission.sms.status.isDenied == true) {
                  await Permission.sms.request();
                  openAppSettings();
                } else if (await Permission.sms.status.isPermanentlyDenied ==
                    true) {
                  await Permission.sms.request();
                  AppWidget.toast(
                      text: 'Please grant SMS permission',
                      toastLength: Toast.LENGTH_LONG);
                  openAppSettings();
                } else if (await Permission.sms.status.isGranted) {
                  if (chatController.searchContactListModel.isEmpty) {
                    chatController.contacts[index].status = 'Invited';
                    chatController.contacts.refresh();
                    SharedPrefClass.saveListToSharedPreferences(
                        con: chatController.contacts.value,
                        sharedPrefString: SharedPrefStrings.myContacts);
                  } else {
                    chatController.searchContactListModel[index].status =
                        'Invited';
                    chatController.contacts.where((p0) =>
                        p0.status ==
                        chatController.searchContactListModel[index].status);
                    chatController.contacts.refresh();
                    SharedPrefClass.saveListToSharedPreferences(
                        con: chatController.contacts.value,
                        sharedPrefString: SharedPrefStrings.myContacts);
                    chatController.searchContactListModel.refresh();
                  }

                  chatController.searchContactListModel.refresh();
                  chatController.update();
                  await sendSMS(
                          message:
                              'Bondio app  \nPlease use this invite code to get points ${authController.userModel.value.user?.referCode.toString()} \nhttps://play.google.com/store/apps/details?id=com.app.bondiomeet',
                          recipients: [phoneNumber.toString()],
                          sendDirect: false)
                      .then((value) {
                    chatController.addContactToFirebase(
                        mobileNumber: phoneNumber,
                        userName: userName,
                        status: 'Invited',
                        id: '',
                        fcmToken: '');
                    AppWidget.toast(text: 'Invited');

                    /*
        }).catchError((onError) {
          log(onError.toString());
        });*/
                  });
                }
                // if (await Permission.sms.status) {
                // await FlutterContacts.requestPermission(readonly: true);
                // AppWidget.toast(
                // text: 'Please give contact permission to find you friends',
                // toastLength: Toast.LENGTH_LONG);
                // openAppSettings();
                // } else {
              },
        child: Container(
          width: 20.w,
          height: 4.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.w),
              color: ColorConstant.backGroundColorOrange),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Icon(Icons.person_add_alt_1_outlined,
                color: Colors.white, size: 5.w),
            Text(
              'Invite',
              style: AppStyles.smallerTextStyle,
            )
          ]),
        ),
      );

  invitedButton() => Container(
      width: 20.w,
      height: 4.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.w),
          color: ColorConstant.greyBorder),
      child: Text(
        'Invited',
        style: AppStyles.smallerTextStyle.copyWith(color: Colors.grey),
      ));

  chatButton({required phoneNumber}) => ElevatedButton(
      onPressed: SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) ==
              false
          ? () {
              AppWidget.toast(text: 'Please sign up first');
              Get.toNamed(RouteHelper.signUpPage);
            }
          : () async {
              DocumentSnapshot<Map<String, dynamic>> data =
                  await chatController.contactCollection.doc(phoneNumber).get();

              log("pp ${data.get(ApiConstant.id)}");
              String peerId = data.get(ApiConstant.id);
              chatController.peerId.value = peerId;
              chatController.update();

              if (authController.userModel.value.user!.id.toString() ==
                  peerId.toString()) {
                AppWidget.toast(
                    text:
                        'Sorry, you can\'t create chat room with same phone number you add at login time');
              } else {
                String roomId = createRoom(
                  userId: authController.userModel.value.user!.id.toString(),
                  peerId: peerId,
                );

                chatController.personalChatListCollection
                    .doc(authController.userModel.value.user!.id.toString())
                    .collection(
                        authController.userModel.value.user!.id.toString())
                    .doc(roomId)
                    .set({
                  ApiConstant.id: roomId,
                  ApiConstant.peerId: peerId,
                  ApiConstant.timestamp:
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  ApiConstant.isPinned: false
                });

                chatController.personalChatListCollection
                    .doc(peerId.toString())
                    .collection(peerId.toString())
                    .doc(roomId)
                    .set({
                  ApiConstant.id: roomId,
                  ApiConstant.peerId:
                      authController.userModel.value.user!.id.toString(),
                  ApiConstant.timestamp:
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  ApiConstant.isPinned: false
                });

                chatController.collectionId.value = roomId.toString();
                chatController.peerId.value = peerId.toString();

                chatController.update();
                log('AAA ${chatController.peerId.toString()}');
                Get.toNamed(RouteHelper.chatPage);
              }
            },
      style: ButtonStyle(
        maximumSize: MaterialStateProperty.all(Size(20.w, 4.h)),
        minimumSize: MaterialStateProperty.all(Size(20.w, 4.h)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.w),
              side: BorderSide(color: ColorConstant.lightOrange)),
        ),
        backgroundColor: MaterialStateProperty.all(
          Color(0xffFFEFE0),
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return ColorConstant.lightOrange; //<-- SEE HERE
            return null; // Defer to the widget's default.
          },
        ),
      ),
      child: Text(
        'Chat',
        style: AppStyles.smallerTextStyle
            .copyWith(color: ColorConstant.darkOrange),
      ));

  _searchData({String? searchString}) {
    log('Search String ${searchString.toString()}');
    if (searchString.toString().isEmpty) {
      chatController.searchContactListModel.value = [];
      chatController.searchContactListModel.refresh();
    } else {
      if (searchString.toString().length >= 3) {
        chatController.searchContactListModel.value = [];
        chatController.searchContactListModel.refresh();

        for (var contactList in chatController.contacts) {
          if (contactList.name
                  .toString()
                  .toLowerCase()
                  .contains(searchString.toString()) ||
              contactList.name
                  .toString()
                  .toUpperCase()
                  .contains(searchString.toString())) {
            chatController.searchContactListModel.add(contactList);
            chatController.searchContactListModel.refresh();
            chatController.update();
          }
        }
      }
    }
  }
}