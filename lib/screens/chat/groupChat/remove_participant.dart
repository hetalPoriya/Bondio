import 'dart:developer';
import 'package:bondio/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../model/model.dart';
import '../chat.dart';

class RemoveParticipant extends StatefulWidget {
  const RemoveParticipant({Key? key}) : super(key: key);

  @override
  State<RemoveParticipant> createState() => _RemoveParticipantState();
}

class _RemoveParticipantState extends State<RemoveParticipant> {
//controller
  HomeController homeController = Get.put(HomeController());
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return ChatBackground(
        floatingButton: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 8.w),
            child: AppWidget.elevatedButton(
                text: 'Done', onTap: () => Get.back())),
        onBackButtonPressed: () {
          Get.back();
        },
        bodyWidget: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              smallSizedBox,
              Padding(
                padding: paddingSymmetric(horizontalPad: 8.w, verticalPad: 0.0),
                child: AppWidget.searchField(
                    controller: chatController.searchController.value,
                    onChanged: (v) {
                      chatController.availableChatPersonSearchList?.value =
                          chatController.availableChatPersonFromContacts!.value
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
                      chatController.availableChatPersonSearchList?.refresh();
                      chatController.availableChatPersonFromContacts?.refresh();
                    }),
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
        title: 'Remove Participant');
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
          return chatController.groupInfo.value.membersId!.contains(
                      availableChatPersonFromContacts[index]
                          .loginId
                          .toString()) ==
                  true
              ? Container(
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
                                    style: mediumTextStyleWhiteText.copyWith(
                                        color: Colors.black),
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
                                  style: smallTextStyleGreyText.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ])),
                    GestureDetector(
                      onTap: () {
                        // Stream<DocumentSnapshot<Map<String, dynamic>>> docSnap =
                        //     chatController.groupChatRoomCollection
                        //         .doc(chatController.groupInfo.value.groupId
                        //             .toString())
                        //         .snapshots();
                        //
                        // docSnap.listen((DocumentSnapshot snap) {
                        //   chatController.groupInfo.value ==
                        //       GroupChat.fromDocument(snap);
                        //   log('Info ${chatController.groupInfo.value.groupId}');
                        //   log('Info ${chatController.groupInfo.value.membersId}');
                        //   chatController.groupInfo.refresh();
                        //   AppWidget.toast(text: 'Participant Removed');
                        // });

                        chatController.removeParticipant(
                          id: availableChatPersonFromContacts[index]
                              .loginId
                              .toString(),
                          userName: availableChatPersonFromContacts[index]
                                  .displayName ??
                              '',
                        );
                      },
                      child: Container(
                          width: 20.w,
                          height: 4.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorConstant.lightOrange),
                              borderRadius: BorderRadius.circular(2.w),
                              color: ColorConstant.backGroundColorOrange),
                          child: Text(
                            'Remove',
                            style:
                                smallerTextStyle.copyWith(color: Colors.white),
                          )),
                    ),
                  ]),
                )
              : Container();
        })));
  }
}
