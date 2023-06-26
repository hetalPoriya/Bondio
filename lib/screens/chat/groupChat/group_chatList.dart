import 'dart:developer';
import 'package:bondio/model/model.dart';

import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:bondio/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class GroupChatList extends StatefulWidget {
  const GroupChatList({Key? key}) : super(key: key);

  @override
  State<GroupChatList> createState() => _GroupChatListState();
}

class _GroupChatListState extends State<GroupChatList> {
  HomeController homeController = Get.put(HomeController());
  AuthController authController = Get.put(AuthController());
  ChatController chatController = Get.put(ChatController());

  @override
  void initState() {
    log(SharedPrefClass.getString(SharedPrefStrings.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        mediumSizedBox,
        Padding(
          padding: paddingSymmetric(horizontalPad: 6.w, verticalPad: 0.0),
          child: AppWidget.searchField(
              controller: chatController.searchController.value,
              onChanged: (searchText) {
                chatController.searchController.refresh();
                chatController.searchGroupInfoList.value = chatController
                    .groupInfoList
                    .where((x) =>
                (x.groupName
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toString()) ||
                    x.groupName
                        .toString()
                        .toUpperCase()
                        .contains(searchText.toString())))
                    .toList();
              }),
        ),
        smallSizedBox,
        Padding(
            padding: paddingSymmetric(horizontalPad: 6.w, verticalPad: 00),
            child: Obx(
                  () =>
                  Row(
                    children: [
                      ChatWidget.tabContainer(
                        text: 'Active',
                        index: 0,
                        textColor: homeController
                            .innerTabForActiveAndArchiveIndexForGroup
                            .value ==
                            0
                            ? Colors.white
                            : Colors.grey,
                        color: homeController
                            .innerTabForActiveAndArchiveIndexForGroup
                            .value ==
                            0
                            ? [ColorConstant.darkRed, ColorConstant.lightRed]
                            : [Colors.white, Colors.white],
                        onTap: () {
                          homeController
                              .innerTabForActiveAndArchiveIndexForGroup.value =
                          0;

                          homeController.update();
                        },
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      ChatWidget.tabContainer(
                        textColor: homeController
                            .innerTabForActiveAndArchiveIndexForGroup
                            .value ==
                            1
                            ? Colors.white
                            : Colors.grey,
                        color: homeController
                            .innerTabForActiveAndArchiveIndexForGroup
                            .value ==
                            1
                            ? [ColorConstant.darkRed, ColorConstant.lightRed]
                            : [Colors.white, Colors.white],
                        text: 'Archive',
                        index: 1,
                        onTap: () {
                          homeController
                              .innerTabForActiveAndArchiveIndexForGroup.value =
                          1;
                          homeController.update();
                        },
                      ),
                    ],
                  ),
            )),
        StreamBuilder(
            stream: chatController.groupChatRoomCollection
                .where(ApiConstant.membersId,
                arrayContains:
                authController.userModel.value.user?.id.toString())
                .orderBy(ApiConstant.timestamp, descending: true)
                .snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return ChatWidget.noConversionFound();
              } else if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return AppWidget.progressIndicator();
              }

              chatController.groupInfoList.value = snapshot.data!.docs
                  .map((groupInfo) => GroupChat.fromDocument(groupInfo))
                  .toList();
              return snapshot.data!.docs.isEmpty
                  ? ChatWidget.noConversionFound()
                  : Obx(() {
                return chatController.searchController.value.text.isEmpty
                    ? displayList(
                    groupChatList: chatController.groupInfoList)
                    : displayList(
                    groupChatList:
                    chatController.searchGroupInfoList);
              });
            }))
      ],
    );
  }

  displayList({required RxList groupChatList}) =>
      ListView.builder(
          padding: paddingSymmetric(verticalPad: 1.h),
          shrinkWrap: true,
          itemCount: groupChatList.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: ((context, index) {
            GroupChat groupInfo = groupChatList[index];
            return StreamBuilder(
              stream: chatController.groupChatRoomCollection
                  .doc(groupInfo.groupId.toString())
                  .collection(groupInfo.groupId.toString())
                  .orderBy(ApiConstant.timestamp, descending: true)
                  .snapshots(),
              builder: (context, messageSnap) {
                if (!messageSnap.hasData) {
                  return SizedBox();
                }
                if (messageSnap.hasData) {
                  List<DocumentSnapshot>? documentList = messageSnap.data?.docs
                      .where((element) =>
                  (element.get(ApiConstant.idFrom) !=
                      authController.userModel.value.user?.id.toString() &&
                      element.get(ApiConstant.isReadFGroup).toString().contains(
                          authController.userModel.value.user?.id.toString() ??
                              '')))
                      .toList();

                  int chatInt =
                  SharedPrefClass.getInt(SharedPrefStrings.totalChatCount);
                  chatInt = chatInt + (documentList?.length ?? 0);
                  SharedPrefClass.setInt(
                      SharedPrefStrings.totalChatCount, chatInt);
                  int innn =
                  SharedPrefClass.getInt(SharedPrefStrings.totalChatCount);
                  chatController.totalChatMessages.value = innn;

                  return Obx(() =>
                      Padding(
                        padding:
                        paddingSymmetric(horizontalPad: 5.w, verticalPad: 1.h),
                        child: ((homeController
                            .innerTabForActiveAndArchiveIndexForGroup.value ==
                            0 && groupInfo.isArchive?.contains(authController
                            .userModel.value.user?.id.toString()) == false) ||
                            (homeController
                                .innerTabForActiveAndArchiveIndexForGroup
                                .value == 1 &&
                                groupInfo.isArchive?.contains(authController
                                    .userModel.value.user?.id.toString()) ==
                                    true))
                            ? GestureDetector(
                            onTap: () async {
                              homeController.personalChatPage.value = false;
                              homeController.personalGroupChatPage.value = true;
                              homeController.update();

                              chatController.collectionId.value =
                                  groupInfo.groupId.toString();
                              chatController.groupInfo.value = groupInfo;
                              chatController.update();
                              chatController.groupInfo.refresh();
                              Get.toNamed(RouteHelper.groupChatPage);
                            },
                            child: groupInfo.isEvent == false
                                ? ChatWidget.chatContainer(
                                isPinned: groupInfo.isArchive?.contains(
                                    authController.userModel.value.user?.id
                                        .toString()) == true
                                    ? true
                                    : false,
                                isNotRead: documentList?.length != 0
                                    ? false
                                    : true,
                                chatCount: documentList?.length,
                                titleText: groupInfo.groupName.toString(),
                                imageString: groupInfo.groupIcon.toString(),
                                subText:
                                groupInfo.lastMessage.toString()
                                ,
                                time: groupInfo.timestamp.toString())
                                : ChatWidget.eventContainer(
                                invitedBy: (groupInfo.isAdmin?[0] ==
                                    authController.userModel.value.user?.id
                                        .toString())
                                    ? 'Invited by you'
                                    : '',
                                title: groupInfo.groupName.toString(),
                                imageString: groupInfo.groupIcon.toString(),
                                description: groupInfo.lastMessage.toString(),
                                time: DateFormat('kk:mm a').format(DateTime
                                    .fromMillisecondsSinceEpoch(
                                    int.parse(groupInfo.timestamp.toString()))),
                                date: groupInfo.eventDate.toString(),
                                memberList: groupInfo.members!.length
                                    .toString()))
                            : Container(),
                      ));
                } else {
                  return SizedBox();
                }
              },
            );
          }));
}