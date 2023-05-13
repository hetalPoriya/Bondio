import 'dart:developer';
import 'package:bondio/model/user_info.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:bondio/utils/app_widget_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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

  Future fetchContacts() async {
    chatController.searchControllerForContact.value.clear();
    chatController.contacts.value = [];
    chatController.contacts.refresh();
    chatController.searchContactListModel.value = [];
    chatController.searchContactListModel.refresh();
    chatController.availableChatPersonFromContacts.value = [];
    chatController.availableChatPersonFromContacts.refresh();
    chatController.update();


    // log('${FlutterContacts.requestPermission()}');
    if (!await FlutterContacts.requestPermission(readonly: true)) {} else {
      FlutterContacts.getContacts(withProperties: true, withPhoto: true)
          .then((contacts) {
        chatController.contacts.addAll(contacts);
        chatController.contacts
            .asMap()
            .entries
            .map((e) async {
          if (chatController.contacts[e.key].phones.isNotEmpty) {
            await chatController.contactCollection.doc(chatController
                .contacts[e.key].phones.first.normalizedNumber
                .toString())
                .get()
                .then((value) {
              if (value.exists) {
                chatController.contacts[e.key].status = value.get('status');
                chatController.contacts[e.key].loginId = value.get('id');
                chatController.contacts.refresh();
                chatController.update();
                if (chatController.contacts[e.key].status == 'Chat') {
                  chatController.availableChatPersonFromContacts
                      .add(chatController.contacts[e.key]);
                  chatController.availableChatPersonFromContacts.refresh();
                }
                chatController.contacts.refresh();
              }
            });
          }
        }).toList();
      });
    }
  }


  @override
  void initState() {
    fetchContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.inviteYourFriend,
                          textAlign: TextAlign.start,
                          style: smallTextStyleWhiteText.copyWith(
                              fontWeight: FontWeight.w500),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 15.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.w),
                                color: Colors.white),
                            child: Text('Host', style: smallerTextStyle),
                          ),
                        )
                      ],
                    ),
                  )),
              smallSizedBox,
              Obx(() =>
                  AppWidget.searchField(
                    controller:
                    chatController.searchControllerForContact.value,
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
                        style: smallerTextStyle.copyWith(
                            fontSize: 8.sp, color: Colors.grey),
                      )
                    ]),
              ),
              smallerSizedBox,
              Expanded(
                  child: Obx(
                        () =>
                    (chatController.contacts.isNotEmpty &&
                        chatController.contacts != [])
                        ? Obx(
                          () =>
                      (chatController
                          .searchContactListModel.isNotEmpty &&
                          chatController.searchContactListModel != [])
                          ? Obx(
                            () =>
                            listViewBuilder(
                                listModel: chatController
                                    .searchContactListModel),
                      )
                          : Obx(
                            () =>
                            listViewBuilder(
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
    return listModel!.isEmpty
        ? Center(
      child: Text(
        'No Contact Found',
        style: smallTextStyleGreyText,
      ),
    )
        : ListView.builder(
        shrinkWrap: true,
        itemCount: listModel.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return Column(
            children: [
              SizedBox(
                height: 7.h,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ChatWidget.imageCircleAvatar(
                          imageString: listModel[index].photo,
                          context: context),
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listModel[index].displayName ?? '',
                                    style: smallTextStyleGreyText.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (listModel[index].phones.isNotEmpty ==
                                      true)
                                    Text(
                                      listModel[index]
                                          .phones
                                          .first
                                          .normalizedNumber ??
                                          '(none)',
                                      style:
                                      smallTextStyleGreyText.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: listModel[index].status == 'Invite'
                                  ? inviteButton(
                                  index: index,
                                  phoneNumber: (listModel[index]
                                      .phones
                                      .isNotEmpty ==
                                      true)
                                      ? listModel[index]
                                      .phones
                                      .first
                                      .normalizedNumber
                                      : '(none)',
                                  userName:
                                  listModel[index].displayName ??
                                      '')
                                  : listModel[index].status == 'Invited'
                                  ? invitedButton()
                                  : chatButton(
                                phoneNumber: (listModel[index]
                                    .phones
                                    .isNotEmpty ==
                                    true)
                                    ? listModel[index]
                                    .phones
                                    .first
                                    .normalizedNumber
                                    : '(none)',
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

  inviteButton({required int index,
    required String phoneNumber,
    required userName}) =>
      GestureDetector(
        onTap:
        SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) == false
            ? () {
          log("AAasas");
          AppWidget.toast(text: 'Please sign up first');
          Get.toNamed(RouteHelper.signUpPage);
        }
            : () async {
          if (chatController.searchContactListModel.isEmpty) {
            chatController.searchContactListModel.value[index]
                .status = 'Invited';
            chatController.searchContactListModel.refresh();
            chatController.searchContactListModel.refresh();
          } else {
            chatController.searchContactListModel.value[index]
                .status = 'Invited';
            chatController.searchContactListModel.refresh();
          }

          chatController.searchContactListModel.refresh();
          chatController.update();
          chatController.addContactToFirebase(
              mobileNumber: phoneNumber,
              userName: userName,
              status: 'Invited',
              id: '',
              fcmToken: '');
          AppWidget.toast(text: 'Invited');
          // await sendSMS(
          //         message:
          //             'Bondio app\nhttps://play.google.com/store/apps/details?id=com.app.bondio',
          //         recipients: [phoneNumber.toString()],
          //         sendDirect: false)
          //     .then((value) {
          //   log('PhoneNUmber $phoneNumber');
          //   firebaseController
          //       .addContactToFirebase(
          //           mobileNumber: phoneNumber,
          //           userName: userName,
          //           status: 'Invited',
          //           id: '',
          //           fcmToken: '')
          //       .then((value) => log('Edded'));

          /*
        }).catchError((onError) {
          log(onError.toString());
        });*/
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
              style: smallerTextStyle.copyWith(color: Colors.white),
            )
          ]),
        ),
      );

  invitedButton() =>
      Container(
          width: 20.w,
          height: 4.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.w),
              color: ColorConstant.greyBorder),
          child: Text(
            'Invited',
            style: smallerTextStyle.copyWith(color: Colors.grey),
          ));

  chatButton({required phoneNumber}) =>
      GestureDetector(
        onTap: SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) ==
            false
            ? () {
          AppWidget.toast(text: 'Please sign up first');
          Get.toNamed(RouteHelper.signUpPage);
        }
            : () async {
          DocumentSnapshot<Map<String, dynamic>> data =
          await chatController.contactCollection
              .doc(phoneNumber)
              .get();

          String peerId = data.get(ApiConstant.id);
          DocumentSnapshot<Map<String, dynamic>> peerInfo =
          await chatController.userCollection.doc(peerId)
              .get();

          String roomId = createRoom(
            userId: authController.userModel.value.user!.id.toString(),
            peerId: peerId,
          );


          chatController.personalChatListCollection
              .doc(authController.userModel.value.user!.id.toString())
              .set({
            ApiConstant.chatPersonList: FieldValue.arrayUnion([roomId])
          });

          chatController.personalChatListCollection
              .doc(authController.userModel.value.user!.id.toString())
              .set({
            ApiConstant.chatPersonList: FieldValue.arrayUnion([roomId])
          });

          chatController.collectionId.value = roomId.toString();
          chatController.peerId.value = peerId.toString();
          DocumentSnapshot<Map<String, dynamic>>
          user = await chatController.userCollection.doc(peerId.toString())
              .get();

          // chatController.peerInfo.value = UserInfo.fromDocument(user);
          // log('User ${chatController.peerInfo.value.}')
          chatController.update();

          Get.toNamed(RouteHelper.chatPage,
              arguments: [peerInfo.get('name')]);
        },
        child: Container(
            width: 20.w,
            height: 4.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: ColorConstant.lightOrange),
                borderRadius: BorderRadius.circular(2.w),
                color: const Color(0xffFFEFE0)),
            child: Text(
              'Chat',
              style: smallerTextStyle.copyWith(color: ColorConstant.darkOrange),
            )),
      );

  _searchData({String? searchString}) {
    log('Search String ${searchString.toString()}');
    if (searchString
        .toString()
        .isEmpty) {
      chatController.searchContactListModel.value = [];
      chatController.searchContactListModel.refresh();
    } else {
      if (searchString
          .toString()
          .length >= 3) {
        chatController.searchContactListModel.value = [];
        chatController.searchContactListModel.refresh();

        chatController.contacts.value.forEach((contactList) {
          if (contactList.displayName
              .toString()
              .toLowerCase()
              .contains(searchString.toString()) ||
              contactList.displayName
                  .toString()
                  .toUpperCase()
                  .contains(searchString.toString())) {
            chatController.searchContactListModel.add(contactList);
            chatController.searchContactListModel.refresh();
            chatController.update();
          }
        });
      }
    }
  }
}
