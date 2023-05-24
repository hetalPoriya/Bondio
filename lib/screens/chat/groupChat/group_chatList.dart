import 'dart:developer';
import 'package:bondio/model/model.dart';

import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:bondio/controller/controller.dart';
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
                    .where((x) => (x.groupName
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

  displayList({required RxList groupChatList}) => ListView.builder(
      padding: paddingSymmetric(verticalPad: 1.h),
      shrinkWrap: true,
      itemCount: groupChatList.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: ((context, index) {
        GroupChat groupInfo = groupChatList[index];
        return Padding(
          padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 1.h),
          child: GestureDetector(
              onTap: () async {
                homeController.personalChatPage.value = false;
                homeController.personalGroupChatPage.value = true;
                homeController.update();
                log('GROUP ${groupChatList[index].toString()}');
                log('GROUP ${groupInfo.groupName.toString()}');
                chatController.collectionId.value =
                    groupInfo.groupId.toString();
                chatController.groupInfo.value = groupInfo;
                chatController.update();
                chatController.groupInfo.refresh();
                Get.toNamed(RouteHelper.groupChatPage);
              },
              child: ChatWidget.chatContainer(
                  titleText: groupInfo.groupName.toString(),
                  imageString: groupInfo.groupIcon.toString(),
                  subText: groupInfo.lastMessage.toString(),
                  time: DateFormat('kk:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(groupInfo.timestamp.toString()))))),
        );
      }));
}
