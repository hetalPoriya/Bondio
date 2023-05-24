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
// class ChatPage extends StatefulWidget {
//   const ChatPage({Key? key}) : super(key: key);
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   //controller
//   HomeController homeController = Get.put(HomeController());
//   FirebaseController firebaseController = Get.put(FirebaseController());
//
//   List<QueryDocumentSnapshot> listMessage = [];
//
//   String createroom(String user1, String user2) {
//     if (user1.hashCode <= user2.hashCode) {
//       return "$user1-$user2";
//     } else {
//       return "$user2-$user1";
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     firebaseController.currentUserId.value =
//         authController.userInfo.value.user?.id.toString();
//     firebaseController.partnerUserId.value =
//         SharedPrefClass.getString(SharedPrefStrings.partnerId);
//     firebaseController.update();
//     log('${firebaseController.currentUserId.value} -  ${firebaseController.partnerUserId.value}');
//     firebaseController.collectionId.value = createroom(
//         firebaseController.currentUserId.value,
//         firebaseController.partnerUserId.value);
//     log('Created ${firebaseController.collectionId.value}');
//     firebaseController.update();
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
//                 firebaseController.sendMessage(
//                   content: firebaseController.typeMessageCon.value.text,
//                   collectionId: firebaseController.collectionId.value,
//                   currentUserId: firebaseController.currentUserId.value,
//                   peerId: firebaseController.partnerUserId.value,
//                 );
//
//                 DocumentSnapshot<Map<String, dynamic>> data =
//                     await firebaseController.fireStoreInstant
//                         .collection(AppStrings.chatRoomCollection)
//                         .doc(firebaseController.currentUserId.value)
//                         .collection(firebaseController.currentUserId.value)
//                         .doc(firebaseController.partnerUserId.value)
//                         .get();
//                 log(data.exists.toString());
//                 if (!data.exists) {
//                   firebaseController.addLastMessageToParticularUser(
//                       lastMessage: firebaseController.typeMessageCon.value.text,
//                       timestamp:
//                           DateTime.now().millisecondsSinceEpoch.toString());
//                   log('added');
//                 }
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
//           .collection(AppStrings.chatRoomCollection)
//           .doc(firebaseController.collectionId.value)
//           .collection(firebaseController.collectionId.value)
//           .orderBy('timestamp', descending: true)
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
//
//                 log('Perr ${SharedPrefClass.getString(SharedPrefStrings.partnerId)}');
//                 log('Perr ${firebaseController.collectionId.value}');
//
//                 QuerySnapshot<Map<String, dynamic>> querySnapshot =
//                     await firebaseController.fireStoreInstant
//                         .collection(AppStrings.chatRoomCollection)
//                         .doc(firebaseController.collectionId.value)
//                         .collection(firebaseController.collectionId.value)
//                         .orderBy('timestamp', descending: true)
//                         .limit(1)
//                         .get();
//                 log('MESS ${querySnapshot.docs.length}');
//                 if (querySnapshot.docs.isNotEmpty) {
//                   MessageChat messageChat =
//                       MessageChat.fromDocument(querySnapshot.docs.last);
//
//                   firebaseController.addLastMessageToParticularUser(
//                       lastMessage: messageChat.content,
//                       timestamp: messageChat.timestamp);
//
//                   log('Callled');
//                 }
//
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
//               () => Text(firebaseController.partnerUserName.value,
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
//
// // @override
// // Widget build(BuildContext context) {
// //   return SafeArea(
// //       child: Scaffold(
// //           body: Column(children: [
// //     smallerSizedBox,
// //     Expanded(
// //       child: GroupedListView<Message, DateTime>(
// //         reverse: true,
// //         shrinkWrap: true,
// //         physics: ClampingScrollPhysics(),
// //         order: GroupedListOrder.DESC,
// //         // useStickyGroupSeparators: true,
// //         // stickyHeaderBackgroundColor: Theme.of(context).primaryColor,
// //         floatingHeader: true,
// //         padding: paddingSymmetric(horizontalPad: 3.w, verticalPad: 0.0),
// //         elements: messages,
// //         groupBy: (messages) => DateTime(
// //             messages.date.year, messages.date.month, messages.date.day),
// //         groupHeaderBuilder: ((message) => _chatHeader(message)),
// //         itemBuilder: ((context, Message messages) => _chatMessages(messages)),
// //       ),
// //     ),
// //     Align(
// //       alignment: Alignment.bottomCenter,
// //       child: _typeMessage(),
// //     )
// //   ])));
// //   // return ChatBackground(
// //   //   openDrawerOnTap: () => Scaffold.of(context).openDrawer(),
// //   //   onBackButtonPressed: () {
// //   //     // homeController.personalChatPage.value = false;
// //   //     homeController.innerTabSelectedIndex.value = 0;
// //   //     homeController.personalChatPage.value = false;
// //   //     homeController.update();
// //   //     Get.back();
// //   //   },
// //   //   title: '',
// //   //   appBarWidget: ChatWidget.appBarWidget(),
// //   //   bodyWidget: Container(
// //   //     height: 76.h,
// //   //     child: Column(children: [
// //   //       smallerSizedBox,
// //   //       Expanded(
// //   //         child: GroupedListView<Message, DateTime>(
// //   //           reverse: true,
// //   //           shrinkWrap: true,
// //   //           physics: ClampingScrollPhysics(),
// //   //           order: GroupedListOrder.DESC,
// //   //           // useStickyGroupSeparators: true,
// //   //           // stickyHeaderBackgroundColor: Theme.of(context).primaryColor,
// //   //           floatingHeader: true,
// //   //           padding: paddingSymmetric(horizontalPad: 3.w, verticalPad: 0.0),
// //   //           elements: messages,
// //   //           groupBy: (messages) => DateTime(
// //   //               messages.date.year, messages.date.month, messages.date.day),
// //   //           groupHeaderBuilder: ((message) => _chatHeader(message)),
// //   //           itemBuilder: ((context, Message messages) =>
// //   //               _chatMessages(messages)),
// //   //         ),
// //   //       ),
// //   //       Align(
// //   //         alignment: Alignment.bottomCenter,
// //   //         child: _typeMessage(),
// //   //       )
// //   //     ]),
// //   //   ),
// //   // );
// // }
//
// // _typeMessage() {
// //   return Container(
// //     height: 13.h,
// //     padding: paddingSymmetric(horizontalPad: 6.w, verticalPad: 0.0),
// //     alignment: Alignment.center,
// //     decoration: BoxDecoration(
// //       borderRadius: BorderRadius.only(
// //         topRight: Radius.circular(10.w),
// //         topLeft: Radius.circular(10.w),
// //       ),
// //       boxShadow: [
// //         BoxShadow(color: Colors.grey.shade100, spreadRadius: 2, blurRadius: 0)
// //       ],
// //       color: Colors.white,
// //     ),
// //     child: Container(
// //       decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(2.w),
// //           border: Border.all(color: ColorConstant.backGroundColorOrange)),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             flex: 5,
// //             child: TextField(
// //               controller: chatCon,
// //               decoration: InputDecoration(
// //                   hintText: 'Type message...',
// //                   contentPadding: EdgeInsets.only(left: 2.w, top: 0.0),
// //                   enabledBorder: InputBorder.none,
// //                   focusedBorder: InputBorder.none
// //                   // enabledBorder: OutlineInputBorder(
// //                   //   borderRadius: BorderRadius.circular(2.w),
// //                   // ),
// //                   // focusedBorder: OutlineInputBorder(
// //                   //   borderRadius: BorderRadius.circular(2.w),
// //                   // ),
// //                   ),
// //               cursorColor: ColorConstant.backGroundColorOrange,
// //               onSubmitted: (text) {
// //                 final msg = Message(
// //                     text: text, date: DateTime.now(), isSendByMe: true);
// //                 setState(() {
// //                   messages.add(msg);
// //                   chatCon.clear();
// //                 });
// //               },
// //             ),
// //           ),
// //           Expanded(
// //               child: GestureDetector(
// //             onTap: () {
// //               final msg = Message(
// //                   text: chatCon.text, date: DateTime.now(), isSendByMe: true);
// //               setState(() {
// //                 messages.add(msg);
// //                 chatCon.clear();
// //               });
// //             },
// //             child: Container(
// //               height: 6.h,
// //               child: Icon(
// //                 Icons.send_sharp,
// //                 color: Colors.white,
// //                 size: 4.h,
// //               ),
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(2.w),
// //                 // gradient: LinearGradient(colors: [
// //                 //   ColorConstant.backGroundColorLightPink,
// //                 //   ColorConstant.backGroundColorOrange
// //                 // ]),
// //                 color: Colors.red,
// //               ),
// //             ),
// //           )),
// //         ],
// //       ),
// //     ),
// //   );
// // }
// //
// // _chatMessages(Message messages) {
// //   return SingleChildScrollView(
// //     child: Align(
// //       alignment:
// //           messages.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
// //       child: messages.isSendByMe
// //           ? _normalCardText(
// //               messages: messages, cardColor: ColorConstant.chatColor)
// //           : _sendByOtherCard(messages),
// //     ),
// //   );
// // }
// //
// // _sendByOtherCard(Message messages) {
// //   return Row(
// //     children: [
// //       Expanded(
// //         child: Container(
// //           alignment: Alignment.center,
// //           padding: paddingAll(paddingAll: 4.w),
// //           height: 6.h,
// //           width: 12.w,
// //           decoration: BoxDecoration(
// //               color: ColorConstant.backGroundColorDarkPurple,
// //               shape: BoxShape.circle,
// //               image: DecorationImage(
// //                   image: AssetImage(AppAssets.reward), fit: BoxFit.fill)),
// //         ),
// //       ),
// //       Flexible(
// //         flex: 5,
// //         child: _normalCardText(messages: messages),
// //       ),
// //     ],
// //   );
// // }
// //
// // _chatHeader(Message message) {
// //   return Column(
// //     children: [
// //       smallerSizedBox,
// //       Card(
// //           color: Theme.of(context).primaryColor,
// //           margin: paddingSymmetric(horizontalPad: 30.w, verticalPad: 0.0),
// //           child: Padding(
// //             padding: paddingAll(
// //               paddingAll: 1.w,
// //             ),
// //             child: Center(
// //               child: FittedBox(
// //                 child: Text(DateFormat.yMMMd().format(message.date),
// //                     style: smallerTextStyle.copyWith(color: Colors.white)),
// //               ),
// //             ),
// //           )),
// //       smallerSizedBox,
// //     ],
// //   );
// // }
// //
// // _normalCardText({required Message messages, Color? cardColor}) {
// //   return Card(
// //     color: cardColor ?? Colors.white,
// //     semanticContainer: true,
// //     elevation: 2.w,
// //     child: Padding(
// //       padding: paddingAll(paddingAll: 3.w),
// //       child: Wrap(
// //         alignment: WrapAlignment.spaceBetween,
// //         crossAxisAlignment: WrapCrossAlignment.end,
// //         children: [
// //           Text(messages.text.toString()),
// //           SizedBox(
// //             width: 4.w,
// //           ),
// //           Text(
// //             '5:30 PM',
// //             style: smallerTextStyle.copyWith(fontSize: 7.sp),
// //           )
// //         ],
// //       ),
// //     ),
// //   );
// // }
// }

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

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //controller
  HomeController homeController = Get.put(HomeController());
  AuthController authController = Get.put(AuthController());
  FirebaseController firebaseController = Get.put(FirebaseController());
  ChatController chatController = Get.put(ChatController());

  List<QueryDocumentSnapshot> listMessage = [];

  // String createroom(String user1, String user2) {
  //   if (user1.hashCode <= user2.hashCode) {
  //     firebaseController.createRoomAndAddToList(
  //         userId: user1, peerId: user2, roomId: '$user1-$user2');
  //     return "$user1-$user2";
  //   } else {
  //     firebaseController.createRoomAndAddToList(
  //         userId: user1, peerId: user2, roomId: '$user2-$user1');
  //     return "$user2-$user1";
  //   }
  // }

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
                chatController.sendMessage(
                    content: chatController.typeMessageCon.value.text,
                    collectionId: chatController.collectionId.value,
                    peerId: chatController.peerId.value);
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
      stream: chatController.personalChatRoomCollection
          .doc(chatController.collectionId.value)
          .collection(chatController.collectionId.value)
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
    return StreamBuilder(
        stream: chatController.userCollection
            .doc(chatController.peerId.toString())
            .snapshots(),
        builder: (context, snapshot) {
          Map<String, dynamic>? data = snapshot.data?.data();
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
                  backgroundImage:
                      ChatWidget.displayImage(image: data?['photo'] ?? ''),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Text(data?['name'] ?? '', style: AppStyles.mediumTextStyle),
              ]);
        });
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
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
