// import 'dart:developer';
//
// import 'package:bondio/model/login_model.dart';
// import 'package:bondio/model/user_info.dart';
// import 'package:bondio/route_helper/route_helper.dart';
// import 'package:bondio/screens/chat/chat.dart';
// import 'package:bondio/controller/controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
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
//         smallSizedBox,
//         Padding(
//             padding: paddingSymmetric(horizontalPad: 6.w, verticalPad: 00),
//             child: Obx(
//                   () =>
//                   Row(
//                     children: [
//                       ChatWidget.tabContainer(
//                         text: 'Active',
//                         index: 0,
//                         textColor:
//                         homeController.innerTabForActiveAndArchiveIndex.value ==
//                             0
//                             ? Colors.white
//                             : Colors.grey,
//                         color:
//                         homeController.innerTabForActiveAndArchiveIndex.value ==
//                             0
//                             ? [ColorConstant.darkRed, ColorConstant.lightRed]
//                             : [Colors.white, Colors.white],
//                         onTap: () {
//                           homeController.innerTabForActiveAndArchiveIndex
//                               .value = 0;
//
//                           homeController.update();
//                         },
//                       ),
//                       SizedBox(
//                         width: 4.w,
//                       ),
//                       ChatWidget.tabContainer(
//                         textColor:
//                         homeController.innerTabForActiveAndArchiveIndex.value ==
//                             1
//                             ? Colors.white
//                             : Colors.grey,
//                         color:
//                         homeController.innerTabForActiveAndArchiveIndex.value ==
//                             1
//                             ? [ColorConstant.darkRed, ColorConstant.lightRed]
//                             : [Colors.white, Colors.white],
//                         text: 'Archive',
//                         index: 1,
//                         onTap: () {
//                           homeController.innerTabForActiveAndArchiveIndex
//                               .value = 1;
//                           homeController.update();
//                         },
//                       ),
//                     ],
//                   ),
//             )),
//         StreamBuilder(
//             stream: chatController.personalChatRoomCollection
//                 .where(ApiConstant.members,
//                 arrayContains:
//                 authController.userModel.value.user?.id.toString())
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
//   displayList({required RxList userInfoList}) =>
//       ListView.builder(
//           padding: paddingSymmetric(verticalPad: 1.h),
//           shrinkWrap: true,
//           itemCount: userInfoList.length,
//           physics: const ClampingScrollPhysics(),
//           itemBuilder: ((context, index) {
//             UserInfo userInfo = userInfoList[index];
//             List? members = userInfo.members;
//             members?.remove(authController.userModel.value.user?.id.toString());
//
//             return Obx(() =>
//             ((homeController.innerTabForActiveAndArchiveIndex.value == 0 &&
//                 userInfo.isPinned == false) ||
//                 (homeController.innerTabForActiveAndArchiveIndex.value ==
//                     1 &&
//                     userInfo.isPinned == true))
//                 ? StreamBuilder(
//               stream: chatController.userCollection
//                   .doc(members?[0].toString())
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 return Padding(
//                     padding: paddingSymmetric(
//                         horizontalPad: 5.w, verticalPad: 1.h),
//                     child: GestureDetector(
//
//                         onTap: () async {
//                           homeController.personalChatPage.value = true;
//                           homeController.personalGroupChatPage.value = false;
//                           homeController.update();
//                           chatController.collectionId.value =
//                               userInfo.id.toString();
//
//                           chatController.peerId.value = members?[0];
//                           chatController.chatInfo.value = userInfoList[index];
//
//                           chatController.update();
//
//                           Get.toNamed(RouteHelper.chatPage);
//                         },
//                         child: Obx(() =>
//                         (((snapshot.data?.get(ApiConstant.name)
//                             .toString()
//                             .toLowerCase() ?? '').contains(
//                             chatController.searchController.value.text
//                                 .toLowerCase()) ||
//                             (snapshot.data?.get(ApiConstant.name)
//                                 .toString()
//                                 .toUpperCase() ?? '')
//                                 .contains(chatController
//                                 .searchController.value.text
//                                 .toUpperCase())))
//                             ? ChatWidget.chatContainer(
//                             isPinned: userInfo.isPinned,
//                             titleText: snapshot.data?.get(ApiConstant.name),
//                             subText: userInfo.lastMessage ?? '',
//                             imageString: snapshot.data?.get(
//                                 ApiConstant.photo) ?? '',
//                             photoSocial: snapshot.data?.get(
//                                 ApiConstant.photoSocial) ??
//                                 '',
//                             time: DateFormat('kk:mm a').format(DateTime
//                                 .fromMillisecondsSinceEpoch(
//                                 int.parse(userInfo.timestamp.toString()))))
//                             : Container())));
//               },
//             )
//                 : Container());
//           }));
// }import 'dart:developer';
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

import '../../../model/model.dart';

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
                          log('ENter');
                          homeController.innerTabForActiveAndArchiveIndex
                              .value = 0;
                          log('a ${homeController
                              .innerTabForActiveAndArchiveIndex.value}');
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
                          log('ENter');
                          homeController.innerTabForActiveAndArchiveIndex
                              .value = 1;
                          log('a ${homeController
                              .innerTabForActiveAndArchiveIndex.value}');
                          homeController.update();
                        },
                      ),
                    ],
                  ),
            )),
        StreamBuilder(
            stream: chatController.personalChatListCollection
                .doc(authController.userModel.value.user?.id.toString())
                .collection(
                authController.userModel.value.user?.id.toString() ?? '')
                .orderBy(ApiConstant.timestamp, descending: true)
                .snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return ChatWidget.noConversionFound();
              } else if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return AppWidget.progressIndicator();
              }

              chatController.peerInfoList.value = snapshot.data!.docs
                  .map((peerInfo) => PeerInfo.fromDocument(peerInfo))
                  .toList();

              int counter = 0;
              chatController.totalChatMessages.value = 0;
              SharedPrefClass.setInt(SharedPrefStrings.totalChatCount, 0);
              return snapshot.data!.docs.isEmpty
                  ? ChatWidget.noConversionFound()
                  : ListView.builder(
                shrinkWrap: true,
                padding: paddingSymmetric(verticalPad: 1.h),
                physics: const ClampingScrollPhysics(),
                itemCount: chatController.peerInfoList.length,
                itemBuilder: (context, index) {
                  PeerInfo userList =
                  chatController.peerInfoList.value[index];

                  return displayList(
                      userList: userList,
                      snapshot: snapshot,
                      index: index,
                      counter: counter);
                },
              );
              // : displayList(userInfoList: chatController.userInfoList);
            })),
      ],
    );
  }

  // displayList({required RxList userInfoList}) =>
  //     ListView.builder(
  //         padding: paddingSymmetric(verticalPad: 1.h),
  //         shrinkWrap: true,
  //         itemCount: userInfoList.length,
  //         physics: const ClampingScrollPhysics(),
  //         itemBuilder: ((context, index) {
  //           UserInfo userInfo = userInfoList[index];
  //
  //           log('${userInfo.user1.toString().contains(
  //               authController.userModel.value.user?.id.toString() ?? '')}');
  //           if (userInfo.user1.toString().contains(
  //               authController.userModel.value.user?.id.toString() ?? '') ==
  //               true) {
  //             chatController.userArchivedString.value =
  //                 ApiConstant.user2;
  //             chatController.isUserArchived.value = userInfo.isUser2Archived!;
  //             chatController.update();
  //           } else {
  //             chatController.userArchivedString.value =
  //                 ApiConstant.user1;
  //             chatController.isUserArchived.value = userInfo.isUser1Archived!;
  //             chatController.update();
  //           }
  //
  //
  //           return Obx(() =>
  //           ((homeController.innerTabForActiveAndArchiveIndex.value == 0 &&
  //               chatController.isUserArchived.value == false) ||
  //               (homeController.innerTabForActiveAndArchiveIndex.value ==
  //                   1 &&
  //                   chatController.isUserArchived.value == true))
  //               ? StreamBuilder(
  //             stream: chatController.userCollection
  //                 .doc(
  //                 chatController.userArchivedString.value == ApiConstant.user1
  //                     ? userInfo.user1![0].toString()
  //                     : userInfo.user2![0])
  //                 .snapshots(),
  //             builder: (context, snapshot) {
  //               var val = User.fromMap(snapshot.data?.data());
  //
  //
  //               log('isPIIned ${chatController.isUserArchived.value}');
  //               return Padding(
  //                   padding: paddingSymmetric(
  //                       horizontalPad: 5.w, verticalPad: 1.h),
  //                   child: GestureDetector(
  //
  //                       onTap: () async {
  //                         homeController.personalChatPage.value = true;
  //                         homeController.personalGroupChatPage.value = false;
  //                         homeController.update();
  //                         chatController.collectionId.value =
  //                             userInfo.id.toString();
  //
  //                         chatController.peerUser.value =
  //                             User.fromMap(snapshot.data?.data());
  //                         chatController.peerUser.refresh();
  //                         //chatController.isArchive.value= members?[3];
  //                         chatController.peerId.value =
  //                             chatController.peerUser.value.id.toString();
  //                         chatController.userArchivedString.value ==
  //                             ApiConstant.user1
  //                             ? userInfo.user1![0].toString()
  //                             : userInfo.user2![0];
  //
  //                         chatController.isUserArchived.value =
  //                             chatController.isUserArchived.value;
  //                         chatController.chatInfo.value = userInfoList[index];
  //
  //                         chatController.update();
  //
  //                         Get.toNamed(RouteHelper.chatPage);
  //                       },
  //                       child: Obx(() =>
  //                       (((snapshot.data?.get(ApiConstant.name)
  //                           .toString()
  //                           .toLowerCase() ?? '').contains(
  //                           chatController.searchController.value.text
  //                               .toLowerCase()) ||
  //                           (snapshot.data?.get(ApiConstant.name)
  //                               .toString()
  //                               .toUpperCase() ?? '')
  //                               .contains(chatController
  //                               .searchController.value.text
  //                               .toUpperCase())))
  //                           ? ChatWidget.chatContainer(
  //                           isNotRead: userInfo.isRead,
  //                           isPinned: chatController.isUserArchived.value,
  //                           titleText: snapshot.data?.get(ApiConstant.name),
  //                           subText: userInfo.lastMessage ?? '',
  //                           imageString: snapshot.data?.get(
  //                               ApiConstant.photo) ?? '',
  //                           photoSocial: snapshot.data?.get(
  //                               ApiConstant.photoSocial) ??
  //                               '',
  //                           time: DateFormat('kk:mm a').format(DateTime
  //                               .fromMillisecondsSinceEpoch(
  //                               int.parse(userInfo.timestamp.toString()))))
  //                           : Container())));
  //             },
  //           )
  //               : Container());
  //         }));

  getUserModel(String userId) {
    final document = chatController.userCollection.doc(userId);
    final snapshot = document.get();

    log('Sanp ${snapshot}');
    // final userModel = User.fromDocument(snapshot);
    // return userModel;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData(
      {required PeerInfo userList}) async {
    return await chatController.personalChatRoomCollection
        .doc(userList.id.toString())
        .collection(userList.id.toString())
        .orderBy(ApiConstant.timestamp)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPeerUser(
      {required peerId}) async {
    return await chatController.userCollection.doc(peerId.toString()).get();
  }

  Widget displayList({required PeerInfo userList,
    required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
    required int index,
    required int counter}) {
    return StreamBuilder(
      stream: chatController.personalChatRoomCollection
          .doc(userList.id.toString())
          .collection(userList.id.toString())
          .orderBy(ApiConstant.timestamp)
          .snapshots(),
      builder: (context, messageSnap) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        if (snapshot.hasData) {
          List<DocumentSnapshot>? documentList = messageSnap.data?.docs
              .where((element) =>
          (element.get(ApiConstant.idFrom) == userList.peerId &&
              element.get(ApiConstant.isRead) == false))
              .toList();
          int chatInt =
          SharedPrefClass.getInt(SharedPrefStrings.totalChatCount);
          chatInt = chatInt + (documentList?.length ?? 0);
          SharedPrefClass.setInt(SharedPrefStrings.totalChatCount, chatInt);
          int innn = SharedPrefClass.getInt(SharedPrefStrings.totalChatCount);
          chatController.totalChatMessages.value = innn;

          //}

          return Padding(
              padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 1.h),
              child: FutureBuilder(
                future: getPeerUser(peerId: userList.peerId.toString()),
                builder: (context, userSnap) {
                  log('ARch ${homeController.innerTabForActiveAndArchiveIndex
                      .value}');
                  log('a ${userList.isPinned}');
                  if (userSnap.hasData) {
                    return Obx(() =>
                    ((homeController
                        .innerTabForActiveAndArchiveIndex
                        .value ==
                        0 &&
                        userList.isPinned == false) ||
                        (homeController.innerTabForActiveAndArchiveIndex
                            .value == 1 &&
                            userList.isPinned == true))
                        ? (((userSnap.data
                        ?.get(ApiConstant.name)
                        .toString()
                        .toLowerCase() ??
                        '')
                        .contains(chatController
                        .searchController.value.text
                        .toLowerCase()) ||
                        (userSnap.data
                            ?.get(ApiConstant.name)
                            .toString()
                            .toUpperCase() ??
                            '')
                            .contains(chatController.searchController.value.text
                            .toUpperCase())))
                        ? GestureDetector(
                      onTap: () async {
                        homeController.personalChatPage.value = true;
                        homeController.personalGroupChatPage.value =
                        false;
                        homeController.update();
                        chatController.collectionId.value =
                            userList.id.toString();

                        chatController.peerUser.value =
                            User.fromMap(userSnap.data?.data());
                        chatController.peerUser.refresh();

                        chatController.peerInfo.value = userList;
                        chatController.peerInfo.refresh();
                        //chatController.isArchive.value= members?[3];
                        chatController.peerId.value =
                            userList.peerId.toString();

                        chatController.update();

                        Get.toNamed(RouteHelper.chatPage);
                      },
                      child: ChatWidget.chatContainer(
                          isNotRead: documentList?.length != 0
                              ? false
                              : true,
                          chatCount: documentList?.length,
                          isPinned: userList.isPinned,
                          subText: messageSnap.data?.docs.length != 0
                              ? messageSnap.data?.docs.last
                              .get(ApiConstant.lastMessage) ??
                              ''
                              : 'Say hii 👋 and Start Conversion',
                          titleText:
                          userSnap.data?.get(ApiConstant.name) ??
                              '',
                          imageString:
                          userSnap.data?.get(ApiConstant.photo) ??
                              '',
                          photoSocial: userSnap.data
                              ?.get(ApiConstant.photoSocial) ??
                              '',
                          time:
                          userList.timestamp ?? '1687535308214'),
                    )
                        : Container()
                        : Container());
                  } else {
                    return const SizedBox();
                  }
                },
              ));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Future<String> getMessageLenght(PeerInfo userList) async {
    QuerySnapshot<Map<String, dynamic>> vv = await chatController
        .personalChatRoomCollection
        .doc(userList.id.toString())
        .collection(userList.id.toString())
        .where(ApiConstant.idFrom, isEqualTo: userList.peerId)
        .where(ApiConstant.isRead, isEqualTo: false)
        .get();

    return vv.docs.length.toString();
  }
}