import 'dart:developer';
import 'package:bondio/controller/controller.dart';
import 'package:bondio/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../chat.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  //controller
  HomeController homeController = Get.put(HomeController());
  AuthController authController = Get.put(AuthController());
  ChatController chatController = Get.put(ChatController());

  List<QueryDocumentSnapshot> listMessage = [];

  @override
  void initState() {
    super.initState();
    log('${chatController.getFirebaseMessagingToken()}');
    chatController.currentUserId.value =
        authController.userModel.value.user!.id.toString();
    chatController.update();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      chatController.userCollection
          .doc(authController.userModel.value.user?.id.toString())
          .update({ApiConstant.onlineStatus: 'Online'});
    } else {
      chatController.userCollection
          .doc(authController.userModel.value.user?.id.toString())
          .update({ApiConstant.onlineStatus: 'Offline'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: ColorConstant.linearColor),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          body: Column(
            children: <Widget>[
              SizedBox(height: 8.h, child: buildAppBar()),
              // List of messages
              Expanded(
                child: buildListMessage(),
                flex: 10,
              ),

              Align(
                child: buildInput(),
                alignment: Alignment.bottomCenter,
              ),
              smallerSizedBox,
            ],
          ),
        ),
      ),
    );
  }

  buildInput() {
    return Padding(
      padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 0.0),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: TextField(
              maxLines: 4,
              minLines: 1,
              keyboardType: TextInputType.text,
              controller: chatController.typeMessageCon.value,
              textAlign: TextAlign.justify,
              textAlignVertical: TextAlignVertical.center,
              style: AppStyles.smallTextStyle,
              decoration: InputDecoration(
                hintText: 'Type message...',
                hintStyle: AppStyles.smallerTextStyle,
                contentPadding: EdgeInsets.only(
                  left: 2.w,
                  top: 0.0,
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.w),
                    borderSide: const BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.w),
                    borderSide: const BorderSide(color: Colors.white)),
              ),
              cursorColor: Colors.white,
              onSubmitted: (text) {},
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
          Expanded(
              child: GestureDetector(
            onTap: () async {
              if (chatController.typeMessageCon.value.text.isNotEmpty) {
                chatController.sendMessage(
                    content: chatController.typeMessageCon.value.text,
                    collectionId: chatController.collectionId.value,
                    peerId: chatController.peerId.value);
                chatController.typeMessageCon.value.clear();
              } else {
                Fluttertoast.showToast(msg: 'Nothing to sent');
              }
            },
            child: Container(
              height: 5.h,
              color: Colors.transparent,
              child: Icon(
                Icons.send_sharp,
                color: Colors.white,
                size: 4.h,
              ),
            ),
          )),
        ],
      ),
    );
  }

  buildListMessage() {
    return StreamBuilder(
      stream: chatController.personalChatRoomCollection
          .doc(chatController.collectionId.value)
          .collection(chatController.collectionId.value)
          .orderBy(ApiConstant.timestamp, descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return const SizedBox();
        }
        listMessage = snapshot.data!.docs;
        log('${listMessage.length}');
        return listMessage.isEmpty
            ? Center(
                child: Text(
                  'Say hi!! 👋',
                  style: AppStyles.mediumTextStyle,
                ),
              )
            : ListView.builder(
                padding: paddingAll(paddingAll: 10.0),
                itemBuilder: (context, index) =>
                    buildItem(index, snapshot.data?.docs[index]),
                itemCount: snapshot.data!.docs.length,
                reverse: true,
                // controller: listScrollController,
              );
      },
    );
  }

  buildAppBar() {
    return StreamBuilder(
        stream: chatController.userCollection
            .doc(chatController.peerId.toString())
            .snapshots(),
        builder: (context, snapshot) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 2.w,
                ),
                GestureDetector(
                  onTap: () async {
                    homeController.onTapOnAddContact.value = false;
                    homeController.personalGroupChatPage.value = false;
                    homeController.personalChatPage.value = false;
                    homeController.update();

                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios_outlined,
                      color: Colors.white, size: 8.w),
                ),
                SizedBox(
                  width: 6.w,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  maxRadius: 6.w,
                  minRadius: 2.w,
                  backgroundImage: ChatWidget.displayImage(
                      image: snapshot.data?.get(ApiConstant.photo) ?? '',
                      socialImage:
                          snapshot.data?.get(ApiConstant.photoSocial) ?? ''),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(snapshot.data?.get(ApiConstant.name) ?? '',
                        style: AppStyles.mediumTextStyle),
                    Text(snapshot.data?.get(ApiConstant.onlineStatus) ?? '',
                        style: AppStyles.smallerTextStyle),
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      position: PopupMenuPosition.under,
                      shadowColor: Colors.transparent,
                      constraints: BoxConstraints(maxHeight: 20.h),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<int>(
                            value: 0,
                            child: Text(
                                chatController.peerInfo.value.isPinned == true
                                    ? "Remove from Archive"
                                    : "Add to Archive"),
                          ),
                        ];
                      },
                      onSelected: (value) async {
                        if (value == 0) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                  chatController.peerInfo.value.isPinned == true
                                      ? 'Remove from Archive'
                                      : 'Add to Archive',
                                  style: AppStyles.largeTextStyle.copyWith(
                                      color:
                                          ColorConstant.backGroundColorOrange)),
                              actions: [
                                AppWidget.elevatedButton(
                                    text: 'Yes',
                                    onTap: () =>
                                        chatController.addOrRemoveFromArchive(
                                            pinned: chatController
                                                .peerInfo.value.isPinned)),
                                smallSizedBox,
                                AppWidget.elevatedButton(
                                    text: 'No', onTap: () => Get.back()),
                              ],
                            ),
                          );
                        }
                      }),
                ),
              ]);
        });
  }

  buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      ChatMessages messageChat = ChatMessages.fromDocument(document);

      if (messageChat.idFrom ==
          authController.userModel.value.user?.id.toString()) {
        // Right (my message)
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
                child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: _textContainer(
                  content: messageChat.content ?? '',
                  index: index,
                  timestamp: messageChat.timestamp ?? ''),
            )),
          ],
        );
      } else {
        // Left (peer message)

        if (messageChat.isRead == false) {
          chatController.updateMessageReadStatus(messages: messageChat);
          int chat = SharedPrefClass.getInt(SharedPrefStrings.totalChatCount);
          chat = chat - 1;
          SharedPrefClass.setInt(SharedPrefStrings.totalChatCount, chat);
          chatController.totalChatMessages.value = chat;
        }
        return Container(
          margin: EdgeInsets.only(bottom: 1.w),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Flexible(
                    child: _textContainer(
                        content: messageChat.content ?? '',
                        index: index,
                        timestamp: messageChat.timestamp ?? '',
                        radius: 1),
                  )
                ],
              ),
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get('idFrom') !=
                authController.userModel.value.user?.id.toString()) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  _textContainer({
    Color? containerColor,
    required String content,
    required int index,
    required String timestamp,
    int radius = 0,
  }) {
    return Container(
      padding: paddingAll(paddingAll: 2.w),
      margin: EdgeInsets.only(
          bottom: isLastMessageRight(index) ? 1.w : 1.w, right: 2.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(3.w),
            topRight: Radius.circular(3.w),
            bottomLeft:
                radius == 0 ? Radius.circular(3.w) : Radius.circular(0.w),
            bottomRight:
                radius == 1 ? Radius.circular(3.w) : Radius.circular(0.w),
          ),
          color: containerColor ?? Colors.white),
      //width: 50.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            content,
            style: AppStyles.smallTextStyle
                .copyWith(color: ColorConstant.mainAppColorNew),
          ),
          Text(
            DateFormat('kk:mm a').format(
                DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp))),
            style: AppStyles.smallerTextStyle
                .copyWith(color: ColorConstant.mainAppColorNew, fontSize: 6.sp),
          )
        ],
      ),
    );
  }
}