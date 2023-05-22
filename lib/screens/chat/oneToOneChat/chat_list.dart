import 'dart:developer';

import 'package:bondio/model/user_info.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:bondio/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  HomeController homeController = Get.put(HomeController());
  AuthController authController = Get.put(AuthController());
  ChatController chatController = Get.put(ChatController());

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
                chatController.searchUserInfoList.value = chatController
                    .userInfoList
                    .where((x) => (x.peerName
                            .toString()
                            .toLowerCase()
                            .contains(searchText.toString()) ||
                        x.peerName
                            .toString()
                            .toUpperCase()
                            .contains(searchText.toString())))
                    .toList();
              }),
        ),
        StreamBuilder(
            stream: chatController.personalChatRoomCollection
                .where(ApiConstant.members,
                    arrayContains:
                        authController.userModel.value.user?.id.toString())
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return ChatWidget.noConversionFound();
              } else if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return AppWidget.progressIndicator();
              }
              chatController.userInfoList.value = snapshot.data!.docs
                  .map((userInfo) => UserInfo.fromDocument(userInfo))
                  .toList();

              return snapshot.data!.docs.isEmpty
                  ? ChatWidget.noConversionFound()
                  : Obx(() {
                      return chatController.searchController.value.text.isEmpty
                          ? displayList(
                              userInfoList: chatController.userInfoList)
                          : displayList(
                              userInfoList: chatController.searchUserInfoList);
                    });
            }))
      ],
    );
  }

  displayList({required RxList userInfoList}) => ListView.builder(
      padding: paddingSymmetric(verticalPad: 1.h),
      shrinkWrap: true,
      itemCount: userInfoList.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: ((context, index) {
        UserInfo userInfo = userInfoList[index];
        log('UserInfo %${userInfo.members}');
        log('UserInfo %${userInfo.lastMessage}');
        List? members = userInfo.members;
        members?.remove(authController.userModel.value.user?.id.toString());

        return Padding(
            padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 1.h),
            child: StreamBuilder(
              stream: chatController.userCollection
                  .doc(members?[0].toString())
                  .snapshots(),
              builder: (context, snapshot) => GestureDetector(
                onTap: () async {
                  homeController.personalChatPage.value = true;
                  homeController.personalGroupChatPage.value = false;
                  homeController.update();
                  chatController.collectionId.value = userInfo.id.toString();
                  chatController.peerId.value = members?[0];

                  chatController.update();

                  Get.toNamed(RouteHelper.chatPage);
                },
                child: ChatWidget.chatContainer(
                    titleText: snapshot.data?.get('name'),
                    subText: userInfo.lastMessage ?? '',
                    imageString: snapshot.data?.get('photo') ?? '',
                    time: DateFormat('kk:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(userInfo.timestamp.toString())))),
              ),
            ));
      }));
}
