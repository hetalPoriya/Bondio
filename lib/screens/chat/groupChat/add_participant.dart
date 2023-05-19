import 'dart:developer';
import 'package:bondio/controller/controller.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../chat.dart';

class AddParticipant extends StatefulWidget {
  const AddParticipant({Key? key}) : super(key: key);

  @override
  State<AddParticipant> createState() => _AddParticipantState();
}

class _AddParticipantState extends State<AddParticipant> {
//controller
  HomeController homeController = Get.put(HomeController());
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ChatBackground(
            floatingButton: Padding(
                padding: EdgeInsets.only(left: 14.w, right: 8.w),
                child: AppWidget.elevatedButton(
                    text: 'Done',
                    onTap: () => chatController.addParticipant())),
            onBackButtonPressed: () {
              // Stream<DocumentSnapshot<Map<String, dynamic>>>
              // docSnap = chatController.groupChatRoomCollection
              //     .doc(chatController.groupInfo.value.groupId
              //     .toString())
              //     .snapshots();
              //
              // docSnap.listen((DocumentSnapshot snap) {
              //   chatController.groupInfo.value ==
              //       GroupChat.fromDocument(snap);
              //   log('Info ${chatController.groupInfo.value.groupId}');
              //   log('Info ${chatController.groupInfo.value.membersId}');
              //   chatController.groupInfo.refresh();
              //   AppWidget.toast(text: 'Participant Added');
              // });
              Get.back();
            },
            bodyWidget: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  smallSizedBox,
                  Padding(
                    padding:
                        paddingSymmetric(horizontalPad: 8.w, verticalPad: 0.0),
                    child: AppWidget.searchField(
                        controller: chatController.searchController.value,
                        onChanged: (v) {
                          chatController.availableChatPersonSearchList.value =
                              chatController.availableChatPersonFromContacts
                                  .where((x) => (x.displayName
                                          .toString()
                                          .toLowerCase()
                                          .contains(chatController
                                              .searchController.value.text) ||
                                      x.displayName
                                          .toString()
                                          .toUpperCase()
                                          .contains(chatController
                                              .searchController.value.text)))
                                  .toList();
                          chatController.availableChatPersonSearchList
                              .refresh();
                          chatController.availableChatPersonFromContacts
                              .refresh();
                        }),
                  ),
                  smallerSizedBox,
                  if (chatController.addParticipantList.isNotEmpty)
                    Container(
                      height: 10.h,
                      alignment: Alignment.centerLeft,
                      //color: Colors.green,
                      child: Padding(
                        padding: EdgeInsets.only(left: 7.w),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                chatController.addParticipantList.length,
                                (index) {
                              log('LoginId ${chatController.addParticipantList[index].loginId}');
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                    width: 18.w,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            chatController.addParticipantList
                                                .removeAt(index);
                                            chatController.update();
                                          },
                                          child: Container(
                                            height: 7.h,
                                            width: 14.w,
                                            decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 4,
                                                  )
                                                ],
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2),
                                                color: Colors.grey,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        AppAssets.addContact),
                                                    fit: BoxFit.cover)),
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 4,
                                                    )
                                                  ],
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white)),
                                              child: Icon(Icons.close,
                                                  size: 4.w,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Text(
                                            chatController
                                                .addParticipantList[index]
                                                .displayName,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppStyles.smallerTextStyle
                                                .copyWith(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  )
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  smallerSizedBox,
                  if (chatController.addParticipantList.isNotEmpty)
                    Padding(
                      padding: paddingSymmetric(
                          horizontalPad: 5.w, verticalPad: 0.0),
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                  Obx(
                    () => chatController.searchController.value.text.isEmpty
                        ? buildListView(
                            availableChatPersonFromContacts:
                                chatController.availableChatPersonFromContacts)
                        : buildListView(
                            availableChatPersonFromContacts:
                                chatController.availableChatPersonSearchList),
                  )
                ]),
            textStyle: AppStyles.largeTextStyle,
            title: 'Add Participant');
      },
    );
  }

  buildListView({RxList? availableChatPersonFromContacts}) {
    return Obx(() => ListView.builder(
        shrinkWrap: true,
        padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 1.h),
        itemCount: availableChatPersonFromContacts!.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: ((context, index) {
          log('Memeber ${chatController.groupInfo.value.membersId}');
          log('list ${chatController.groupInfo.value.membersId!.contains(availableChatPersonFromContacts[index].loginId.toString())}');
          return GestureDetector(
            onTap: () {
              if (chatController.addParticipantList.contains(
                      chatController.availableChatPersonFromContacts[index]) ==
                  false) {
                chatController.addParticipantList
                    .add(availableChatPersonFromContacts[index]);

                chatController.addParticipantList.refresh();
                chatController.update();
              } else {
                Fluttertoast.showToast(msg: 'Already added.');
              }
            },
            child: Container(
              height: 8.h,
              margin: paddingSymmetric(verticalPad: 1.0),
              child: Row(children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChatWidget.imageCircleAvatar(
                          imageString:
                              availableChatPersonFromContacts[index].photo,
                          context: context),
                    ],
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                                availableChatPersonFromContacts[index]
                                        .displayName ??
                                    '',
                                style: AppStyles.mediumTextStyle
                                    .copyWith(color: Colors.black),
                                overflow: TextOverflow.ellipsis),
                          ),
                          if (availableChatPersonFromContacts[index]
                                  .phones
                                  .isNotEmpty ==
                              true)
                            Text(
                              availableChatPersonFromContacts[index]
                                      .phones
                                      .first
                                      .normalizedNumber ??
                                  '(none)',
                              style: AppStyles.smallTextStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ])),
                Container(
                    width: 20.w,
                    height: 4.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorConstant.lightOrange),
                        borderRadius: BorderRadius.circular(2.w),
                        color: chatController.groupInfo.value.membersId!
                                    .contains(
                                        availableChatPersonFromContacts[index]
                                            .loginId
                                            .toString()) ==
                                true
                            ? Colors.grey.shade400
                            : ColorConstant.backGroundColorOrange),
                    child: Text(
                      chatController.groupInfo.value.membersId!.contains(
                                  availableChatPersonFromContacts[index]
                                      .loginId
                                      .toString()) ==
                              true
                          ? 'Added'
                          : 'Add',
                      style: AppStyles.smallerTextStyle,
                    )),
              ]),
            ),
          );
        })));
  }
}
