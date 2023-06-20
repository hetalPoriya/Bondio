// import 'dart:developer';
// import 'package:bondio/controller/controller.dart';
// import 'package:bondio/model/model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:sizer/sizer.dart';
//
// class GroupChatPage extends StatefulWidget {
//   const GroupChatPage({Key? key}) : super(key: key);
//
//   @override
//   State<GroupChatPage> createState() => _GroupChatPageState();
// }
//
// class _GroupChatPageState extends State<GroupChatPage> {
//   //controller
//   HomeController homeController = Get.put(HomeController());
//   AuthController authController = Get.put(AuthController());
//   FirebaseController firebaseController = Get.put(FirebaseController());
//
//   List<QueryDocumentSnapshot> listMessage = [];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         extendBodyBehindAppBar: true,
//         body: Column(
//           children: <Widget>[
//             SizedBox(height: 8.h, child: buildAppBar()),
//             // List of messages
//             Expanded(
//               child: buildListMessage(),
//               flex: 10,
//             ),
//
//             Align(
//               child: buildInput(),
//               alignment: Alignment.bottomCenter,
//             ),
//             smallerSizedBox,
//           ],
//         ),
//       ),
//     );
//   }
//
//   buildInput() {
//     return Padding(
//       padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 0.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 6,
//             child: TextField(
//               maxLines: 2,
//               controller: firebaseController.typeMessageCon.value,
//               textAlign: TextAlign.justify,
//               textAlignVertical: TextAlignVertical.bottom,
//               decoration: InputDecoration(
//                 hintText: 'Type message...',
//                 contentPadding: EdgeInsets.only(
//                   left: 2.w,
//                   top: 0.0,
//                 ),
//                 // enabledBorder: InputBorder.none,
//                 // focusedBorder: InputBorder.none
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(2.w),
//                     borderSide:
//                         BorderSide(color: ColorConstant.backGroundColorOrange)),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(2.w),
//                     borderSide:
//                         BorderSide(color: ColorConstant.backGroundColorOrange)),
//               ),
//               cursorColor: ColorConstant.backGroundColorOrange,
//               onSubmitted: (text) {},
//             ),
//           ),
//           SizedBox(
//             width: 2.w,
//           ),
//           Expanded(
//               child: GestureDetector(
//             onTap: () async {
//               if (firebaseController.typeMessageCon.value.text.isNotEmpty) {
//                 // String msgInfo = firebaseController.sendMessage(
//                 //   content: firebaseController.typeMessageCon.value.text,
//                 //   collectionId: Get.arguments[0],
//                 // );
//
//                 // firebaseController.sendMessageForGroupChat(
//                 //     groupId: Get.arguments[0], chatMessageData: msgInfo);
//                 // DocumentSnapshot<Map<String, dynamic>> data =
//                 //     await firebaseController.fireStoreInstant
//                 //         .collection(AppStrings.chatRoomCollection)
//                 //         .doc(firebaseController.currentUserId.value)
//                 //         .collection(firebaseController.currentUserId.value)
//                 //         .doc(firebaseController.partnerUserId.value)
//                 //         .get();
//                 // log(data.exists.toString());
//                 // if (!data.exists) {
//                 //   firebaseController.addLastMessageToParticularUser(
//                 //       lastMessage: firebaseController.typeMessageCon.value.text,
//                 //       timestamp:
//                 //           DateTime.now().millisecondsSinceEpoch.toString());
//                 //   log('added');
//                 // }
//
//                 firebaseController.typeMessageCon.value.clear();
//               } else {
//                 Fluttertoast.showToast(msg: 'Nothing to sent');
//               }
//             },
//             child: Container(
//               height: 5.h,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(1.w),
//                 // gradient: LinearGradient(colors: [
//                 //   ColorConstant.backGroundColorLightPink,
//                 //   ColorConstant.backGroundColorOrange
//                 // ]),
//                 color: Colors.red,
//               ),
//               child: Icon(
//                 Icons.send_sharp,
//                 color: Colors.white,
//                 size: 4.h,
//               ),
//             ),
//           )),
//         ],
//       ),
//     );
//   }
//
//   buildListMessage() {
//     return StreamBuilder(
//       stream: firebaseController.fireStoreInstant
//           .collection(AppStrings.groupChatCollection)
//           .doc(Get.arguments[0])
//           .collection(Get.arguments[0])
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return AppWidget.progressIndicator();
//         } else {
//           listMessage = snapshot.data!.docs;
//           return ListView.builder(
//             padding: paddingAll(paddingAll: 10.0),
//             itemBuilder: (context, index) =>
//                 buildItem(index, snapshot.data?.docs[index]),
//             itemCount: snapshot.data!.docs.length,
//             reverse: true,
//             // controller: listScrollController,
//           );
//         }
//       },
//     );
//   }
//
//   buildAppBar() {
//     return Container(
//       decoration: BoxDecoration(
//           gradient: linearGradientColor,
//           borderRadius: BorderRadius.only(
//               bottomRight: Radius.circular(3.w),
//               bottomLeft: Radius.circular(3.w))),
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 2.w,
//             ),
//             GestureDetector(
//               onTap: () async {
//                 homeController.personalGroupChatPage.value = false;
//                 homeController.personalChatPage.value = false;
//                 homeController.update();
//                 // log('Perr ${SharedPrefClass.getString(SharedPrefStrings.partnerId)}');
//                 // log('Perr ${firebaseController.collectionId.value}');
//                 //
//                 // QuerySnapshot<Map<String, dynamic>> querySnapshot =
//                 //     await firebaseController.fireStoreInstant
//                 //         .collection(AppStrings.chatRoomCollection)
//                 //         .doc(firebaseController.collectionId.value)
//                 //         .collection(firebaseController.collectionId.value)
//                 //         .orderBy('timestamp', descending: true)
//                 //         .limit(1)
//                 //         .get();
//                 // log('MESS ${querySnapshot.docs.length}');
//                 // if (querySnapshot.docs.isNotEmpty) {
//                 //   MessageChat messageChat =
//                 //       MessageChat.fromDocument(querySnapshot.docs.last);
//                 //
//                 //   firebaseController.addLastMessageToParticularUser(
//                 //       lastMessage: messageChat.content,
//                 //       timestamp: messageChat.timestamp);
//                 //
//                 //   log('Callled');
//                 // }
//                 Get.back();
//               },
//               child: Icon(Icons.arrow_back_ios_outlined,
//                   color: Colors.white, size: 8.w),
//             ),
//             SizedBox(
//               width: 2.w,
//             ),
//             CircleAvatar(
//               backgroundColor: Colors.white,
//               maxRadius: 6.w,
//               minRadius: 2.w,
//             ),
//             SizedBox(
//               width: 4.w,
//             ),
//             Obx(
//               () => Text('',
//                   style: smallTextStyleOrangeText.copyWith(
//                       fontSize: 14.sp, color: Colors.white)),
//             ),
//           ]),
//     );
//   }
//
//   Widget buildItem(int index, DocumentSnapshot? document) {
//     if (document != null) {
//       MessageChat messageChat = MessageChat.fromDocument(document);
//       if (messageChat.idFrom ==
//           authController.userInfo.value.user?.id.toString()) {
//         // Right (my message)
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             Flexible(
//                 child: Padding(
//               padding: EdgeInsets.only(left: 20.w),
//               child: _textContainer(
//                   content: messageChat.content,
//                   index: index,
//                   timestamp: messageChat.timestamp),
//             )),
//
//             // Container(
//             //   padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
//             //   width: 200,
//             //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
//             //   margin: EdgeInsets.only(
//             //       bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
//             //   child: Text(
//             //     messageChat.content,
//             //   ),
//             // )
//           ],
//         );
//       } else {
//         // Left (peer message)
//         return Container(
//           margin: EdgeInsets.only(bottom: 1.w),
//           child: Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   isLastMessageLeft(index)
//                       ? const CircleAvatar(
//                           backgroundColor: Colors.red,
//                         )
//                       : Container(width: 2.w),
//                   SizedBox(
//                     width: 2.w,
//                   ),
//                   _textContainer(
//                       content: messageChat.content,
//                       index: index,
//                       containerColor: ColorConstant.darkOrange,
//                       timestamp: messageChat.timestamp,
//                       radius: 1),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }
//     } else {
//       return const SizedBox.shrink();
//     }
//   }
//
//   bool isLastMessageLeft(int index) {
//     if ((index > 0 &&
//             listMessage[index - 1].get('idFrom') ==
//                 authController.userInfo.value.user?.id.toString()) ||
//         index == 0) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   bool isLastMessageRight(int index) {
//     if ((index > 0 &&
//             listMessage[index - 1].get('idFrom') !=
//                 authController.userInfo.value.user?.id.toString()) ||
//         index == 0) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   _textContainer({
//     Color? containerColor,
//     required String content,
//     required int index,
//     required String timestamp,
//     int radius = 0,
//   }) {
//     return Container(
//       padding: paddingAll(paddingAll: 2.w),
//       margin: EdgeInsets.only(
//           bottom: isLastMessageRight(index) ? 1.w : 1.w, right: 2.w),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(3.w),
//             topRight: Radius.circular(3.w),
//             bottomLeft:
//                 radius == 0 ? Radius.circular(3.w) : Radius.circular(0.w),
//             bottomRight:
//                 radius == 1 ? Radius.circular(3.w) : Radius.circular(0.w),
//           ),
//           color: containerColor ?? ColorConstant.backGroundColorLightPink),
//       //width: 50.w,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Text(
//             content,
//             style: smallTextStyleGreyText.copyWith(color: Colors.white),
//           ),
//           Text(
//             DateFormat('kk:mm a').format(
//                 DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp))),
//             style:
//                 smallerTextStyle.copyWith(color: Colors.white, fontSize: 6.sp),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:bondio/controller/controller.dart';
import 'package:bondio/model/model.dart';

import 'package:bondio/route_helper/route_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../chat.dart';

class GroupChatPage extends StatefulWidget {
  const GroupChatPage({Key? key}) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  //controller
  HomeController homeController = Get.put(HomeController());
  AuthController authController = Get.put(AuthController());
  ChatController chatController = Get.put(ChatController());

  List<QueryDocumentSnapshot> listMessage = [];

  @override
  void initState() {
    super.initState();
    chatController.currentUserId.value =
        authController.userModel.value.user!.id.toString();
    chatController.update();
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
                // enabledBorder: InputBorder.none,
                // focusedBorder: InputBorder.none
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
                chatController.sendMessageForGroupChat(
                    groupId: chatController.groupInfo.value.groupId.toString(),
                    msg: chatController.typeMessageCon.value.text);

                chatController.typeMessageCon.value.clear();
              } else {
                Fluttertoast.showToast(msg: 'Nothing to sent');
              }
            },
            // child: Icon(
            //   Icons.send_sharp,
            //   color: Colors.white,
            //   size: 4.h,
            // ),
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
      stream: chatController.groupChatRoomCollection
          .doc(chatController.collectionId.toString())
          .collection(chatController.collectionId.toString())
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AppWidget.progressIndicator(color: Colors.transparent);
        } else {
          listMessage = snapshot.data!.docs;

          return ListView.builder(
            padding: paddingAll(paddingAll: 10.0),
            itemBuilder: (context, index) =>
                buildItem(index, snapshot.data?.docs[index]),
            itemCount: snapshot.data!.docs.length,
            reverse: true,
            // controller: listScrollController,
          );
        }
      },
    );
  }

  buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () async {
          homeController.onTapOnAddContact.value = false;
          homeController.personalGroupChatPage.value = false;
          homeController.personalChatPage.value = false;
          homeController.update();

          Get.back();
        },
        child:
            Icon(Icons.arrow_back_ios_outlined, color: Colors.white, size: 8.w),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 6.w,
            minRadius: 2.w,
            backgroundImage: ChatWidget.displayImage(
                image: chatController.groupInfo.value.groupIcon.toString()),
          ),
          SizedBox(
            width: 4.w,
          ),
          Obx(
            () => Row(
              children: [
                Text(chatController.groupInfo.value.groupName.toString(),
                    style: AppStyles.mediumTextStyle),
                IconButton(
                    onPressed: () {
                      chatController.groupNameController.value.text =
                          chatController.groupInfo.value.groupName.toString();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            content: AppWidget.textFormFiledProfilePage(
                                hintText: 'Group name',
                                textEditingController:
                                    chatController.groupNameController.value),
                            actions: [
                              Row(
                                children: [
                                  Expanded(
                                      child: AppWidget.elevatedButton(
                                          text: 'Cancel',
                                          onTap: () {
                                            Get.back();
                                          })),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Expanded(
                                      child: AppWidget.elevatedButton(
                                          text: 'Ok',
                                          onTap: () {
                                            chatController
                                                .groupChatRoomCollection
                                                .doc(chatController
                                                    .groupInfo.value.groupId
                                                    .toString())
                                                .update({
                                              ApiConstant.groupName:
                                                  chatController
                                                      .groupNameController
                                                      .value
                                                      .text
                                            });
                                            Get.back();
                                            chatController
                                                    .groupInfo.value.groupName =
                                                chatController
                                                    .groupNameController
                                                    .value
                                                    .text;
                                            chatController.groupInfo.refresh();
                                          })),
                                ],
                              )
                            ]),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ],
      ),
      actions: [
        Align(
          alignment: Alignment.centerRight,
          child: PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.w),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              position: PopupMenuPosition.under,
              shadowColor: Colors.transparent,
              constraints: BoxConstraints(maxHeight: 20.h),
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Add Participants"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Remove Participants"),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("Archive Group"),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: Text("Leave Group"),
                  ),
                ];
              },
              onSelected: (value) async {
                chatController.addParticipantList.value = [];
                chatController.addParticipantList.refresh();
                chatController.removeParticipantList.value = [];
                chatController.removeParticipantList.refresh();

                if (value == 0) {
                  if (chatController.groupInfo.value.isAdmin?.first
                          .toString() ==
                      authController.userModel.value.user?.id.toString()) {
                    Get.toNamed(
                      RouteHelper.addParticipant,
                    );
                  } else {
                    AppWidget.toast(
                        text:
                            'Sorry, you are not an admin you cannot access this feature');
                  }
                } else if (value == 1) {
                  if (chatController.groupInfo.value.isAdmin?.first
                          .toString() ==
                      authController.userModel.value.user?.id.toString()) {
                    Get.toNamed(
                      RouteHelper.removeParticipant,
                    );
                  } else {
                    AppWidget.toast(
                        text:
                            'Sorry, you are not an admin you cannot access this feature');
                  }
                } else if (value == 2) {
                  return showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          chatController.groupInfo.value.isPinned == true
                              ? 'Remove from Archive'
                              : 'Add to Archive',
                          style: AppStyles.largeTextStyle.copyWith(
                              color: ColorConstant.backGroundColorOrange)),
                      actions: [
                        AppWidget.elevatedButton(
                            text: 'Yes',
                            onTap: () {
                              chatController.groupChatRoomCollection
                                  .doc(chatController.groupInfo.value.groupId
                                      .toString())
                                  .update({
                                ApiConstant.isPinned:
                                    chatController.groupInfo.value.isPinned ==
                                            true
                                        ? false
                                        : true
                              }).then((value) => Get.back());
                            }),
                        smallSizedBox,
                        AppWidget.elevatedButton(
                            text: 'No', onTap: () => Get.back()),
                      ],
                    ),
                  );
                } else if (value == 3) {
                  // if (chatController.groupInfo.value.isAdmin?.first
                  //         .toString() ==
                  //     authController.userModel.value.user?.id.toString()) {
                  await chatController.groupChatRoomCollection
                      .doc(chatController.collectionId.toString())
                      .update({
                    ApiConstant.members: FieldValue.arrayRemove([
                      '${authController.userModel.value.user?.id}_${authController.userModel.value.user?.name}'
                    ]),
                    ApiConstant.membersId: FieldValue.arrayRemove(
                        [authController.userModel.value.user?.id.toString()]),
                  });

                  DocumentReference<Map<String, dynamic>> userDocRef =
                      chatController.groupChatListCollection.doc(
                          authController.userModel.value.user?.id.toString());

                  await userDocRef.update({
                    ApiConstant.groupId: FieldValue.arrayRemove(
                        [authController.userModel.value.user?.id])
                  });
                  Get.back();
                  AppWidget.toast(text: 'Success');
                }
                // else {
                //   AppWidget.toast(
                //       text:
                //           'Sorry, you are not an admin you cannot access this feature');
                // }
                //}
              }),
        ),
      ],
    );
    // return GestureDetector(
    //   onTap: () => Get.toNamed(RouteHelper.chatProfilePage),
    //   child: Row(
    //       //mainAxisAlignment: MainAxisAlignment.start,
    //       //crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         SizedBox(
    //           width: 2.w,
    //         ),
    //         GestureDetector(
    //           onTap: () async {
    //             homeController.onTapOnAddContact.value = false;
    //             homeController.personalGroupChatPage.value = false;
    //             homeController.personalChatPage.value = false;
    //             homeController.update();
    //
    //             Get.back();
    //           },
    //           child: Icon(Icons.arrow_back_ios_outlined,
    //               color: Colors.white, size: 8.w),
    //         ),
    //         SizedBox(
    //           width: 6.w,
    //         ),
    //         CircleAvatar(
    //           backgroundColor: Colors.white,
    //           maxRadius: 6.w,
    //           minRadius: 2.w,
    //           backgroundImage: ChatWidget.displayImage(
    //               image: chatController.groupInfo.value.groupIcon.toString()),
    //         ),
    //         SizedBox(
    //           width: 4.w,
    //         ),
    //         Obx(
    //           () => Text(chatController.groupInfo.value.groupName.toString(),
    //               style: smallTextStyleOrangeText.copyWith(
    //                   fontSize: 14.sp, color: Colors.white)),
    //         ),
    //         Align(
    //           alignment: Alignment.centerRight,
    //           child: PopupMenuButton(
    //               // add icon, by default "3 dot" icon
    //               // icon: Icon(Icons.book)
    //               itemBuilder: (context) {
    //             return [
    //               PopupMenuItem<int>(
    //                 value: 0,
    //                 child: Text("My Account"),
    //               ),
    //               PopupMenuItem<int>(
    //                 value: 1,
    //                 child: Text("Settings"),
    //               ),
    //               PopupMenuItem<int>(
    //                 value: 2,
    //                 child: Text("Logout"),
    //               ),
    //             ];
    //           }, onSelected: (value) {
    //             if (value == 0) {
    //               print("My account menu is selected.");
    //             } else if (value == 1) {
    //               print("Settings menu is selected.");
    //             } else if (value == 2) {
    //               print("Logout menu is selected.");
    //             }
    //           }),
    //         ),
    //       ]),
    // );
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      log('${document.data()}');
      ChatMessages messageChat = ChatMessages.fromDocument(document);

      if (messageChat.idFrom ==
          SharedPrefClass.getString(SharedPrefStrings.userId)) {
        // Right (my message)
        return messageChat.deletedUserList?.contains(
                    authController.userModel.value.user?.id.toString()) ==
                true
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                      child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: _textContainer(
                        isSender: false,
                        content: messageChat.content ?? '',
                        index: index,
                        timestamp: messageChat.timestamp ?? '',
                        senderName: messageChat.senderName),
                  )),

                  // Container(
                  //   padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //   width: 200,
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  //   margin: EdgeInsets.only(
                  //       bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
                  //   child: Text(
                  //     messageChat.content,
                  //   ),
                  // )
                ],
              );
      } else {
        // Left (peer message)
        return messageChat.deletedUserList?.contains(
                    authController.userModel.value.user?.id.toString()) ==
                true
            ? Container()
            : Container(
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
                          child: Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: _textContainer(
                                  isSender: true,
                                  content: messageChat.content ?? '',
                                  index: index,
                                  timestamp: messageChat.timestamp ?? '',
                                  radius: 1,
                                  senderName: messageChat.senderName)),
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

  // bool isLastMessageLeft(int index) {
  //   if ((index > 0 &&
  //           listMessage[index - 1].get('idFrom') ==
  //               authController.userInfo.value.user?.id.toString()) ||
  //       index == 0) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

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
    bool? isSender,
    required String content,
    required int index,
    required String timestamp,
    int radius = 0,
    String? senderName,
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
          if (isSender == true)
            Text(
              senderName.toString(),
              overflow: TextOverflow.ellipsis,
              style: AppStyles.smallTextStyle
                  .copyWith(color: ColorConstant.backGroundColorDarkPurple),
              textAlign: TextAlign.start,
            ),
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