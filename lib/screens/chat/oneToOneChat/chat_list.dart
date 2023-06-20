// import 'dart:developer';
//
// import 'package:bondio/model/login_model.dart';
// import 'package:bondio/model/user_info.dart';
// import 'package:bondio/route_helper/route_helper.dart';
// import 'package:bondio/screens/chat/chat.dart';
// import 'package:bondio/controller/controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:sizer/sizer.dart';
//
// class ChatList extends StatefulWidget {
//   const ChatList({Key? key}) : super(key: key);
//
//   @override
//   State<ChatList> createState() => _ChatListState();
// }
//
// class _ChatListState extends State<ChatList> {
//   HomeController homeController = Get.put(HomeController());
//   AuthController authController = Get.put(AuthController());
//   ChatController chatController = Get.put(ChatController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         mediumSizedBox,
//         Padding(
//           padding: paddingSymmetric(horizontalPad: 6.w, verticalPad: 0.0),
//           child: AppWidget.searchField(
//               controller: chatController.searchController.value,
//               onChanged: (searchText) {
//                 chatController.searchController.refresh();
//                 searchText = searchText.toString().trim();
//               }),
//         ),
//         StreamBuilder(
//             stream: chatController.personalChatRoomCollection
//                 .where(ApiConstant.members,
//                     arrayContains:
//                         authController.userModel.value.user?.id.toString())
//                 .orderBy(ApiConstant.isPinned, descending: true)
//                 .orderBy(ApiConstant.timestamp, descending: true)
//                 .snapshots(),
//             builder: ((context, snapshot) {
//               if (!snapshot.hasData) {
//                 return ChatWidget.noConversionFound();
//               } else if (snapshot.connectionState == ConnectionState.waiting ||
//                   snapshot.connectionState == ConnectionState.none) {
//                 return AppWidget.progressIndicator();
//               }
//               chatController.userInfoList.value = snapshot.data!.docs
//                   .map((userInfo) => UserInfo.fromDocument(userInfo))
//                   .toList();
//
//               return snapshot.data!.docs.isEmpty
//                   ? ChatWidget.noConversionFound()
//                   : displayList(userInfoList: chatController.userInfoList);
//             }))
//       ],
//     );
//   }
//
//   displayList({required RxList userInfoList}) => ListView.builder(
//       padding: paddingSymmetric(verticalPad: 1.h),
//       shrinkWrap: true,
//       itemCount: userInfoList.length,
//       physics: const ClampingScrollPhysics(),
//       itemBuilder: ((context, index) {
//         UserInfo userInfo = userInfoList[index];
//         // log('UserInfo %${userInfo.members}');
//         // log('UserInfo %${userInfo.lastMessage}');
//         List? members = userInfo.members;
//         members?.remove(authController.userModel.value.user?.id.toString());
//
//         return StreamBuilder(
//           stream: chatController.userCollection
//               .doc(members?[0].toString())
//               .snapshots(),
//           builder: (context, snapshot) {
//             return Padding(
//                 padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 1.h),
//                 child: GestureDetector(
//                     // onLongPress: () {
//                     //   log('Enter');
//                     //   showDialog(
//                     //     context: context,
//                     //     builder: (context) => AlertDialog(
//                     //       title: Text(
//                     //           userInfo.isPinned == true
//                     //               ? 'Remove from Archive'
//                     //               : 'Add to Archive',
//                     //           style: AppStyles.largeTextStyle.copyWith(
//                     //               color: ColorConstant.backGroundColorOrange)),
//                     //       actions: [
//                     //         AppWidget.elevatedButton(
//                     //             text: 'Yes',
//                     //             onTap: () {
//                     //               chatController.personalChatRoomCollection
//                     //                   .doc(userInfo.id.toString())
//                     //                   .update({
//                     //                 ApiConstant.isPinned:
//                     //                     userInfo.isPinned == true ? false : true
//                     //               }).then((value) => Get.back());
//                     //             }),
//                     //         smallSizedBox,
//                     //         AppWidget.elevatedButton(
//                     //             text: 'No', onTap: () => Get.back()),
//                     //       ],
//                     //     ),
//                     //   );
//                     // },
//                     onTap: () async {
//                       homeController.personalChatPage.value = true;
//                       homeController.personalGroupChatPage.value = false;
//                       homeController.update();
//                       chatController.collectionId.value =
//                           userInfo.id.toString();
//                       chatController.peerId.value = members?[0];
//                       chatController.chatInfo.value = userInfoList[index];
//
//                       chatController.update();
//
//                       Get.toNamed(RouteHelper.chatPage);
//                     },
//                     child: Obx(() =>
//                         (((snapshot.data?.get('name').toString().toLowerCase() ?? '')
//                                     .contains(chatController
//                                         .searchController.value.text
//                                         .toLowerCase()) ||
//                                 (snapshot.data?.get('name').toString().toUpperCase() ?? '')
//                                     .contains(chatController
//                                         .searchController.value.text
//                                         .toUpperCase())))
//                             ? ChatWidget.chatContainer(
//                                 isPinned: userInfo.isPinned,
//                                 titleText: snapshot.data?.get('name'),
//                                 subText: userInfo.lastMessage ?? '',
//                                 imageString: snapshot.data?.get('photo') ?? '',
//                                 photoSocial: snapshot.data?.get('photo_social') ?? '',
//                                 time: DateFormat('kk:mm a').format(DateTime.fromMillisecondsSinceEpoch(int.parse(userInfo.timestamp.toString()))))
//                             : Container())));
//           },
//         );
//       }));
// }
//
import 'dart:developer';

import 'package:bondio/model/login_model.dart';
import 'package:bondio/model/user_info.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:bondio/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                searchText = searchText.toString().trim();
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
                        textColor:
                        homeController.innerTabForActiveAndArchiveIndex.value ==
                            0
                            ? Colors.white
                            : Colors.grey,
                        color:
                        homeController.innerTabForActiveAndArchiveIndex.value ==
                            0
                            ? [ColorConstant.darkRed, ColorConstant.lightRed]
                            : [Colors.white, Colors.white],
                        onTap: () {
                          homeController.innerTabForActiveAndArchiveIndex
                              .value = 0;

                          homeController.update();
                        },
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      ChatWidget.tabContainer(
                        textColor:
                        homeController.innerTabForActiveAndArchiveIndex.value ==
                            1
                            ? Colors.white
                            : Colors.grey,
                        color:
                        homeController.innerTabForActiveAndArchiveIndex.value ==
                            1
                            ? [ColorConstant.darkRed, ColorConstant.lightRed]
                            : [Colors.white, Colors.white],
                        text: 'Archive',
                        index: 1,
                        onTap: () {
                          homeController.innerTabForActiveAndArchiveIndex
                              .value = 1;
                          homeController.update();
                        },
                      ),
                    ],
                  ),
            )),
        StreamBuilder(
            stream: chatController.personalChatRoomCollection
                .where(ApiConstant.members,
                arrayContains:
                authController.userModel.value.user?.id.toString())
                .orderBy(ApiConstant.isPinned, descending: true)
                .orderBy(ApiConstant.timestamp, descending: true)
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
                  : displayList(userInfoList: chatController.userInfoList);
            }))
      ],
    );
  }

  displayList({required RxList userInfoList}) =>
      ListView.builder(
          padding: paddingSymmetric(verticalPad: 1.h),
          shrinkWrap: true,
          itemCount: userInfoList.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: ((context, index) {
            UserInfo userInfo = userInfoList[index];
            // log('UserInfo %${userInfo.members}');
            // log('UserInfo %${userInfo.lastMessage}');
            List? members = userInfo.members;
            members?.remove(authController.userModel.value.user?.id.toString());

            return Obx(() =>
            ((homeController.innerTabForActiveAndArchiveIndex.value == 0 &&
                userInfo.isPinned == false) ||
                (homeController.innerTabForActiveAndArchiveIndex.value ==
                    1 &&
                    userInfo.isPinned == true))
                ? StreamBuilder(
              stream: chatController.userCollection
                  .doc(members?[0].toString())
                  .snapshots(),
              builder: (context, snapshot) {
                return Padding(
                    padding: paddingSymmetric(
                        horizontalPad: 5.w, verticalPad: 1.h),
                    child: GestureDetector(
                      // onLongPress: () {
                      //   log('Enter');
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //       title: Text(
                      //           userInfo.isPinned == true
                      //               ? 'Remove from Archive'
                      //               : 'Add to Archive',
                      //           style: AppStyles.largeTextStyle.copyWith(
                      //               color: ColorConstant.backGroundColorOrange)),
                      //       actions: [
                      //         AppWidget.elevatedButton(
                      //             text: 'Yes',
                      //             onTap: () {
                      //               chatController.personalChatRoomCollection
                      //                   .doc(userInfo.id.toString())
                      //                   .update({
                      //                 ApiConstant.isPinned:
                      //                     userInfo.isPinned == true ? false : true
                      //               }).then((value) => Get.back());
                      //             }),
                      //         smallSizedBox,
                      //         AppWidget.elevatedButton(
                      //             text: 'No', onTap: () => Get.back()),
                      //       ],
                      //     ),
                      //   );
                      // },
                        onTap: () async {
                          homeController.personalChatPage.value = true;
                          homeController.personalGroupChatPage.value = false;
                          homeController.update();
                          chatController.collectionId.value =
                              userInfo.id.toString();
                          chatController.peerId.value = members?[0];
                          chatController.chatInfo.value = userInfoList[index];

                          chatController.update();

                          Get.toNamed(RouteHelper.chatPage);
                        },
                        child: Obx(() =>
                        (((snapshot.data?.get('name')
                            .toString()
                            .toLowerCase() ?? '').contains(
                            chatController.searchController.value.text
                                .toLowerCase()) ||
                            (snapshot.data?.get('name')
                                .toString()
                                .toUpperCase() ?? '')
                                .contains(chatController
                                .searchController.value.text
                                .toUpperCase())))
                            ? ChatWidget.chatContainer(
                            isPinned: userInfo.isPinned,
                            titleText: snapshot.data?.get('name'),
                            subText: userInfo.lastMessage ?? '',
                            imageString: snapshot.data?.get('photo') ?? '',
                            photoSocial: snapshot.data?.get('photo_social') ??
                                '',
                            time: DateFormat('kk:mm a').format(DateTime
                                .fromMillisecondsSinceEpoch(
                                int.parse(userInfo.timestamp.toString()))))
                            : Container())));
              },
            )
                : Container());
          }));
}