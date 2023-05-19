import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bondio/model/contact_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import '../model/model.dart';
import 'controller.dart';

class ChatController extends GetxController {
  FirebaseController firebaseController = Get.put(FirebaseController());
  FirebaseFirestore fireStoreInstant = FirebaseFirestore.instance;

  //collection
  CollectionReference<Map<String, dynamic>> contactCollection =
      FirebaseFirestore.instance
          .collection(ApiConstant.manageContactCollection);

  CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection(ApiConstant.userCollection);

  CollectionReference<Map<String, dynamic>> personalChatListCollection =
      FirebaseFirestore.instance
          .collection(ApiConstant.personalChatListCollection);

  CollectionReference<Map<String, dynamic>> personalChatRoomCollection =
      FirebaseFirestore.instance
          .collection(ApiConstant.personalChatRoomCollection);

  CollectionReference<Map<String, dynamic>> groupChatListCollection =
      FirebaseFirestore.instance
          .collection(ApiConstant.groupChatListCollection);

  CollectionReference<Map<String, dynamic>> groupChatRoomCollection =
      FirebaseFirestore.instance
          .collection(ApiConstant.groupChatRoomCollection);

  //check status for user from firebase manage contacts collection
  RxList<ContactListModel> contacts = <ContactListModel>[].obs;
  RxList searchContactListModel = [].obs;

  //for group members
  RxList availableChatPersonFromContacts = [].obs;
  RxList availableChatPersonSearchList = [].obs;

  RxList addParticipantList = [].obs;

  RxList removeParticipantList = [].obs;
  RxList selectedGroupMember = [].obs;

  //textEditing controller
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<TextEditingController> searchControllerForContact =
      TextEditingController().obs;
  Rx<TextEditingController> groupNameController = TextEditingController().obs;
  Rx<TextEditingController> typeMessageCon = TextEditingController().obs;

  //current id
  RxString currentUserId = ''.obs;
  RxString collectionId = ''.obs;
  RxString peerId = ''.obs;

  //image
  Rx<File?>? pickedImage;

  //chat snapshot
  RxList userInfoList = [].obs;
  RxList groupInfoList = [].obs;

  Rx<GroupChat> groupInfo = GroupChat().obs;
  Rx<User> peerInfo = User().obs;
  RxList searchUserInfoList = [].obs;
  RxList searchGroupInfoList = [].obs;

  //add users
  addUserInfoToFirebase({User? userInfo}) {
    String data = userInfoBodyToMap(userInfo!);
    var userId = User.fromMap(json.decode(data));
    log('Data ${userId.id.toString()}');
    DocumentReference documentReference =
        userCollection.doc(userId.id.toString());

    fireStoreInstant.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        userInfo.toMap(),
      );
    });
  }

  //add contact
  addContactToFirebase({
    required String mobileNumber,
    required String userName,
    required String status,
    required String id,
    required String fcmToken,
  }) async {
    DocumentReference documentReference = contactCollection.doc(mobileNumber);

    AddContactModel addContactModel = AddContactModel(
      id: id,
      userName: userName,
      status: status,
      fcmToken: fcmToken,
      phoneNumber: mobileNumber,
    );

    fireStoreInstant.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        addContactModel.toJson(),
      );
    });
  }

  //add personal chat room
  createRoomAndAddToList({
    required String userId,
    required String peerId,
    required String roomId,
  }) async {
    DocumentSnapshot<Map<String, dynamic>> userInfo =
        await userCollection.doc(userId).get();

    DocumentSnapshot<Map<String, dynamic>> peerInfo =
        await userCollection.doc(peerId).get();

    fireStoreInstant
        .collection(ApiConstant.personalChatRoomCollection)
        .doc(roomId)
        .set({
      ApiConstant.members: FieldValue.arrayUnion([userId, peerId]),
      ApiConstant.user1: FieldValue.arrayUnion(
          [userId, userInfo.get('name'), userInfo.get('email')]),
      ApiConstant.user2: FieldValue.arrayUnion(
          [peerId, peerInfo.get('name'), peerInfo.get('email')]),
      ApiConstant.timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      ApiConstant.lastMessage: '',
      ApiConstant.id: roomId,
    });
  }

  //send personal message
  sendMessage(
      {required String content,
      required String collectionId,
      required String peerId}) {
    AuthController authController = Get.put(AuthController());
    DocumentReference documentReference = fireStoreInstant
        .collection(ApiConstant.personalChatRoomCollection)
        .doc(collectionId)
        .collection(collectionId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    ChatMessages messageChat = ChatMessages(
      idFrom: authController.userModel.value.user!.id.toString(),
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      senderName: '',
      isRead: false,
    );

    fireStoreInstant.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });

    fireStoreInstant
        .collection(ApiConstant.personalChatRoomCollection)
        .doc(collectionId)
        .set({
      ApiConstant.timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      ApiConstant.lastMessage: content
    }, SetOptions(merge: true));
  }

  // create group
  Future createGroup(
      {required String userName, required String groupName}) async {
    AuthController authController = Get.put(AuthController());
    List<String> userInfo = [
      '${authController.userModel.value.user!.id.toString()}_${authController.userModel.value.user!.name.toString()}'
    ];

    List<String> userId = [authController.userModel.value.user!.id.toString()];

    for (var element in selectedGroupMember) {
      userInfo.add('${element.loginId}_${element.displayName ?? ''}');
      userId.add('${element.loginId}');
    }

    GroupChat groupChat = GroupChat(
        groupName: groupName,
        groupIcon: '',
        members: [],
        membersId: [],
        isAdmin: [],
        //'messages': ,
        groupId: '',
        lastMessage: '',
        lastMessageSender: '',
        timestamp: DateTime.now().millisecondsSinceEpoch.toString());

    DocumentReference groupDocRef =
        await groupChatRoomCollection.add(groupChat.toJson());

    await groupDocRef.update({
      ApiConstant.members: FieldValue.arrayUnion(userInfo),
      ApiConstant.groupId: groupDocRef.id,
      ApiConstant.membersId: FieldValue.arrayUnion(userId),
      ApiConstant.isAdmin: FieldValue.arrayUnion(
          [authController.userModel.value.user?.id.toString()]),
    });

    selectedGroupMember.every((element) {
      DocumentReference<Map<String, dynamic>> userDocRef =
          groupChatListCollection.doc(element.loginId);

      userDocRef.set({
        ApiConstant.groupId: FieldValue.arrayUnion([groupDocRef.id])
      }, SetOptions(merge: true));

      return true;
    });
  }

  // group send message
  sendMessageForGroupChat({required String groupId, required String msg}) {
    DocumentReference documentReference = groupChatRoomCollection
        .doc(groupId)
        .collection(groupId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    ChatMessages messageChat = ChatMessages(
      idFrom: SharedPrefClass.getString(SharedPrefStrings.userId),
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      idTo: '',
      content: msg,
      senderName: SharedPrefClass.getString(SharedPrefStrings.userName),
      isRead: false,
    );

    fireStoreInstant.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });

    groupChatRoomCollection.doc(groupId).update({
      ApiConstant.lastMessage: msg,
      ApiConstant.lastMessageSender:
          SharedPrefClass.getString(SharedPrefStrings.userId),
      ApiConstant.timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  //add participant to group
  Future addParticipant() async {
    for (int i = 0; i < addParticipantList.length; i++) {
      await groupChatRoomCollection
          .doc(groupInfo.value.groupId.toString())
          .set({
        ApiConstant.members: FieldValue.arrayUnion([
          '${addParticipantList[i].loginId}_${addParticipantList[i].displayName}'
        ]),
        ApiConstant.membersId:
            FieldValue.arrayUnion([addParticipantList[i].loginId]),
      }, SetOptions(merge: true));

      DocumentReference<Map<String, dynamic>> userDocRef =
          groupChatListCollection.doc(addParticipantList[i].loginId);

      await userDocRef.set({
        ApiConstant.groupId:
            FieldValue.arrayUnion([addParticipantList[i].loginId])
      }, SetOptions(merge: true));
    }

    Stream<DocumentSnapshot<Map<String, dynamic>>> docSnap =
        groupChatRoomCollection
            .doc(groupInfo.value.groupId.toString())
            .snapshots();

    docSnap.listen((DocumentSnapshot snap) {
      groupInfo.value = GroupChat.fromDocument(snap);
      log('Info ${groupInfo.value.groupId}');
      log('Info ${groupInfo.value.membersId}');
      groupInfo.refresh();
      AppWidget.toast(text: 'Participant Added');
    });
    Get.back();
  }

  //add participant to group
  Future removeParticipant() async {
    for (int i = 0; i < removeParticipantList.length; i++) {
      await groupChatRoomCollection
          .doc(groupInfo.value.groupId.toString())
          .set({
        ApiConstant.members: FieldValue.arrayRemove([
          '${removeParticipantList[i].loginId}_${removeParticipantList[i].displayName}'
        ]),
        ApiConstant.membersId:
            FieldValue.arrayRemove([removeParticipantList[i].loginId]),
      }, SetOptions(merge: true));

      DocumentReference<Map<String, dynamic>> userDocRef =
          groupChatListCollection.doc(removeParticipantList[i].loginId);

      await userDocRef.set({
        ApiConstant.groupId:
            FieldValue.arrayRemove([removeParticipantList[i].loginId])
      }, SetOptions(merge: true));
    }

    Stream<DocumentSnapshot<Map<String, dynamic>>> docSnap =
        groupChatRoomCollection
            .doc(groupInfo.value.groupId.toString())
            .snapshots();

    docSnap.listen((DocumentSnapshot snap) {
      groupInfo.value = GroupChat.fromDocument(snap);
      log('Info ${groupInfo.value.groupId}');
      log('Info ${groupInfo.value.membersId}');
      groupInfo.refresh();
      AppWidget.toast(text: 'Participant Removed');
    });

    Get.back();
  }
}
