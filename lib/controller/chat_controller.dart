import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bondio/model/contact_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as d;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/model.dart';
import 'controller.dart';

class ChatController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseFirestore fireStoreInstant = FirebaseFirestore.instance;

  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

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
  RxList<ContactListModel> availableChatPersonFromContacts =
      <ContactListModel>[].obs;
  RxList<ContactListModel> availableChatPersonSearchList =
      <ContactListModel>[].obs;

  RxList<ContactListModel> addParticipantList = <ContactListModel>[].obs;

  RxList<ContactListModel> removeParticipantList = <ContactListModel>[].obs;
  RxList<ContactListModel> selectedGroupMember = <ContactListModel>[].obs;

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
  RxList peerInfoList = [].obs;
  RxList searchUserInfoList = [].obs;
  RxList groupInfoList = [].obs;
  RxList searchGroupInfoList = [].obs;

  Rx<GroupChat> groupInfo = GroupChat().obs;
  Rx<User> peerUser = User().obs;
  Rx<PeerInfo> peerInfo = PeerInfo().obs;

  RxInt totalChatMessages = 0.obs;

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

  //update contact
  updateContactToFirebase({
    required String mobileNumber,
    required String id,
    required String fcmToken,
    required String userName,
  }) async {
    await contactCollection.doc(mobileNumber).update({
      ApiConstant.status: 'Chat',
      ApiConstant.id: id,
      ApiConstant.fcmToken: fcmToken,
      ApiConstant.userName: userName
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
      ApiConstant.members:
          FieldValue.arrayUnion([userId.toString(), peerId.toString()]),
      ApiConstant.user1: FieldValue.arrayUnion(
          [userId, userInfo.get(ApiConstant.name), userInfo.get('email')]),
      ApiConstant.user2: FieldValue.arrayUnion(
          [peerId, peerInfo.get(ApiConstant.name), peerInfo.get('email')]),
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
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    AuthController authController = Get.put(AuthController());
    DocumentReference documentReference = fireStoreInstant
        .collection(ApiConstant.personalChatRoomCollection)
        .doc(collectionId)
        .collection(collectionId)
        .doc(time);

    ChatMessages messageChat = ChatMessages(
      idFrom: authController.userModel.value.user!.id.toString(),
      idTo: peerId,
      timestamp: time,
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
        .collection(ApiConstant.personalChatListCollection)
        .doc(authController.userModel.value.user?.id.toString())
        .collection(authController.userModel.value.user?.id.toString() ?? '')
        .doc(collectionId.toString())
        .set({
      ApiConstant.timestamp: time,
    }, SetOptions(merge: true)).then(
            (value) => sendPushNotification(peerUser: peerUser, msg: content));
  }

  // create group
  Future createGroup({
    required String userName,
    required String groupName,
  }) async {
    try {
      isLoading(true);
      AuthController authController = Get.put(AuthController());
      List<String> userInfo = [
        '${authController.userModel.value.user!.id.toString()}_${authController.userModel.value.user!.name.toString()}'
      ];

      List<String> userId = [
        authController.userModel.value.user!.id.toString()
      ];

      for (var element in selectedGroupMember) {
        userCollection.doc(element.id.toString()).get().then((value) {
          userInfo.add('${element.id}_${element.name ?? ''}');
          userId.add('${element.id}');
        });
      }

      GroupChat groupChat = GroupChat(
          groupName: groupName,
          groupIcon: '',
          members: [],
          membersId: [],
          isAdmin: [],
          isArchive: [],
          groupId: '',
          isPinned: false,
          lastMessage: '',
          lastMessageSender: '',
          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
          isEvent: false,
          eventDes: '',
          eventId: '',
          eventLocation: '',
          eventTime: '',
          eventDate: '');

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
            groupChatListCollection.doc(element.id);

        userDocRef.set({
          ApiConstant.groupId: FieldValue.arrayUnion([groupDocRef.id])
        }, SetOptions(merge: true));

        return true;
      });

      selectedGroupMember.clear();
      selectedGroupMember.value = [];
      groupNameController.value.clear();
      selectedGroupMember.refresh();
      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

  // create group  event
  Future createGroupEvent({
    required String userName,
    required String eventTitle,
    bool? isEvent,
    String? eventDate,
    String? eventDes,
    String? eventLocation,
    String? eventId,
    String? eventTime,
  }) async {
    try {
      isLoading(true);
      AuthController authController = Get.put(AuthController());
      List<String> userInfo = [
        '${authController.userModel.value.user!.id.toString()}_${authController.userModel.value.user!.name.toString()}'
      ];

      List<String> userId = [
        authController.userModel.value.user!.id.toString()
      ];

      for (var element in selectedGroupMember) {
        userCollection.doc(element.id.toString()).get().then((value) {
          userInfo.add('${element.id}_${element.name ?? ''}');
          userId.add('${element.id}');
        });
      }

      await groupChatRoomCollection.doc(eventId.toString()).set({
        ApiConstant.groupName: eventTitle,
        ApiConstant.groupIcon: '',
        ApiConstant.isArchive: [],
        ApiConstant.groupId: eventId.toString(),
        ApiConstant.isPinned: false,
        ApiConstant.lastMessage: '',
        ApiConstant.lastMessageSender: '',
        ApiConstant.timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        ApiConstant.isEvent: true,
        ApiConstant.eventDescription: eventDes ?? '',
        ApiConstant.eventId: eventId ?? '',
        ApiConstant.eventLoc: eventLocation ?? '',
        ApiConstant.eventTimeChat: eventTime ?? '',
        ApiConstant.eventDate:
            eventDate ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        ApiConstant.members: FieldValue.arrayUnion(userInfo),
        ApiConstant.membersId: FieldValue.arrayUnion(userId),
        ApiConstant.isAdmin: FieldValue.arrayUnion(
            [authController.userModel.value.user?.id.toString()]),
      });

      selectedGroupMember.every((element) {
        DocumentReference<Map<String, dynamic>> userDocRef =
            groupChatListCollection.doc(element.id);

        userDocRef.set({
          ApiConstant.groupId: FieldValue.arrayUnion([eventId.toString()])
        }, SetOptions(merge: true));

        return true;
      });

      selectedGroupMember.clear();
      selectedGroupMember.value = [];
      groupNameController.value.clear();
      selectedGroupMember.refresh();
      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

  // group send message
  sendMessageForGroupChat({
    required String groupId,
    required String msg,
    List? groupMembers,
  }) {
    AuthController authController = Get.put(AuthController());
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    groupMembers
        ?.remove(authController.userModel.value.user?.id.toString() ?? '');
    DocumentReference documentReference =
        groupChatRoomCollection.doc(groupId).collection(groupId).doc(time);

    ChatMessages messageChat = ChatMessages(
      idFrom: authController.userModel.value.user!.id.toString(),
      timestamp: time,
      idTo: '',
      content: msg,
      senderName: authController.userModel.value.user?.name.toString() ?? '',
      isRead: false,
      isReadForGroup: groupMembers,
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
      ApiConstant.timestamp: time,
    }).then((value) {
      groupMembers?.forEach((element) {
        log('${getFirebaseMessagingToken()}');
        userCollection.doc(element.toString()).get().then((value) {
          User user = User.fromDocument(value);
          sendPushNotificationForGroup(msg: msg, user: user);
        });
      });
    });
  }

  //add participant to group
  Future addParticipant() async {
    log('Event ${groupInfo.value.isEvent}');
    log('Event ${groupInfo.value.groupId.toString()}');
    for (int i = 0; i < addParticipantList.length; i++) {
      await groupChatRoomCollection
          .doc(groupInfo.value.groupId.toString())
          .set({
        ApiConstant.members: FieldValue.arrayUnion(
            ['${addParticipantList[i].id}_${addParticipantList[i].name}']),
        ApiConstant.membersId:
            FieldValue.arrayUnion([addParticipantList[i].id]),
      }, SetOptions(merge: true));

      DocumentReference<Map<String, dynamic>> userDocRef =
          groupChatListCollection.doc(addParticipantList[i].id);

      await userDocRef.set({
        ApiConstant.groupId: FieldValue.arrayUnion([addParticipantList[i].id])
      }, SetOptions(merge: true));
    }

    Stream<DocumentSnapshot<Map<String, dynamic>>> docSnap =
        groupChatRoomCollection
            .doc(groupInfo.value.groupId.toString())
            .snapshots();

    docSnap.listen((DocumentSnapshot snap) {
      groupInfo.value = GroupChat.fromDocument(snap);
      groupInfo.refresh();
    });

    if (groupInfo.value.isEvent == true) {
      EventController eventController = Get.put(EventController());
      DocumentSnapshot<Map<String, dynamic>> value =
          await groupChatRoomCollection
              .doc(groupInfo.value.eventId.toString())
              .get();
      List members = value.get(ApiConstant.membersId);
      String m = members.join(',');
      eventController.updateEventMembersApiCall(
          eventMembers: m.toString(),
          eventId: groupInfo.value.eventId.toString());
    }

    AppWidget.toast(text: 'Participant Added');
    Get.back();
  }

  //add participant to group
  Future removeParticipant() async {
    for (int i = 0; i < removeParticipantList.length; i++) {
      await groupChatRoomCollection
          .doc(groupInfo.value.groupId.toString())
          .set({
        ApiConstant.members: FieldValue.arrayRemove([
          '${removeParticipantList[i].id}_${removeParticipantList[i].name}'
        ]),
        ApiConstant.membersId:
            FieldValue.arrayRemove([removeParticipantList[i].id]),
      }, SetOptions(merge: true));

      DocumentReference<Map<String, dynamic>> userDocRef =
          groupChatListCollection.doc(removeParticipantList[i].id);

      await userDocRef.set({
        ApiConstant.groupId:
            FieldValue.arrayRemove([removeParticipantList[i].id])
      }, SetOptions(merge: true));
    }

    Stream<DocumentSnapshot<Map<String, dynamic>>> docSnap =
        groupChatRoomCollection
            .doc(groupInfo.value.groupId.toString())
            .snapshots();

    docSnap.listen((DocumentSnapshot snap) {
      groupInfo.value = GroupChat.fromDocument(snap);
      groupInfo.refresh();
    });
    if (groupInfo.value.isEvent == true) {
      EventController eventController = Get.put(EventController());
      DocumentSnapshot<Map<String, dynamic>> value =
          await groupChatRoomCollection
              .doc(groupInfo.value.eventId.toString())
              .get();
      List members = value.get(ApiConstant.membersId);
      String m = members.join(',');
      eventController.updateEventMembersApiCall(
          eventMembers: m.toString(),
          eventId: groupInfo.value.eventId.toString());
    }
    AppWidget.toast(text: 'Participant Removed');
    Get.back();
  }

  Future<void> updateMessageReadStatus({required ChatMessages messages}) async {
    personalChatRoomCollection
        .doc(collectionId.toString())
        .collection(collectionId.toString())
        .doc(messages.timestamp.toString())
        .update({ApiConstant.isRead: true});

    personalChatRoomCollection
        .doc(collectionId.toString())
        .update({ApiConstant.isRead: true});
  }

  Future<void> updateMessageReadStatusForGroup(
      {required ChatMessages messages}) async {
    groupChatRoomCollection
        .doc(collectionId.toString())
        .collection(collectionId.toString())
        .doc(messages.timestamp.toString())
        .update({ApiConstant.isRead: true});
  }

  Future<void> removeIntoIsReadForGroup(
      {required ChatMessages messages}) async {
    AuthController authController = Get.put(AuthController());
    groupChatRoomCollection
        .doc(collectionId.toString())
        .collection(collectionId.toString())
        .doc(messages.timestamp.toString())
        .update({
      ApiConstant.isReadFGroup: FieldValue.arrayRemove(
          [authController.userModel.value.user?.id.toString()])
    });
  }

  String? getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    //if time is not available then return below statement
    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return 'Last seen at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);
    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }

  addOrRemoveFromArchive({bool? pinned}) {
    AuthController authController = Get.put(AuthController());
    return personalChatListCollection
        .doc(authController.userModel.value.user?.id.toString())
        .collection(authController.userModel.value.user?.id.toString() ?? '')
        .doc(peerInfo.value.id.toString())
        .update({
      ApiConstant.isPinned: pinned == true ? false : true,
    }).then((value) {
      Get.back();

      peerInfo.value.isPinned = pinned == true ? false : true;
    });
  }

  updateStatus({required String status}) {
    AuthController authController = Get.put(AuthController());
    userCollection
        .doc(authController.userModel.value.user?.id.toString())
        .update({ApiConstant.onlineStatus: status});
  }

  Future<String?> getFirebaseMessagingToken() async {
    await firebaseMessaging.requestPermission();
    String? val = await firebaseMessaging.getToken();
    return val;
  }

  static Future<void> sendPushNotification(
      {required String msg, required Rx<User> peerUser}) async {
    AuthController authController = Get.put(AuthController());
    String key =
        'AAAA251Ulz8:APA91bGRYuyXWUgL1qC4n10qMsEcIxJ8MKlR8d6Q1YqTeWgquM8CnspYOZ3jOprjDYD4Vnfqie70yYWnae-apK0w2ciaj9f_qCWYNKdN7WjCuZLwlUtupoAdIVMhgRAT6BVMX5EyZRSu';
    d.Dio dio = d.Dio();
    try {
      final body = {
        "to": peerUser.value.deviceToken ?? '',
        "notification": {
          "title": authController.userModel.value.user?.name ?? '',
          "body": msg
        }
      };

      var res = await dio.post('https://fcm.googleapis.com/fcm/send',
          options: d.Options(headers: {'Authorization': 'Bearer $key'}),
          data: body);
      log('Notification ${res.data}');
    } on d.DioError catch (e) {
      AppWidget.toast(text: e.toString());
    }
  }

  static Future<void> sendPushNotificationForGroup(
      {required String msg, required User user}) async {
    AuthController authController = Get.put(AuthController());
    String key =
        'AAAA251Ulz8:APA91bGRYuyXWUgL1qC4n10qMsEcIxJ8MKlR8d6Q1YqTeWgquM8CnspYOZ3jOprjDYD4Vnfqie70yYWnae-apK0w2ciaj9f_qCWYNKdN7WjCuZLwlUtupoAdIVMhgRAT6BVMX5EyZRSu';
    d.Dio dio = d.Dio();
    try {
      final body = {
        "to": user.deviceToken ?? '',
        "notification": {
          "title": authController.userModel.value.user?.name ?? '',
          "body": msg.toString()
        }
      };

      var res = await dio.post('https://fcm.googleapis.com/fcm/send',
          options: d.Options(headers: {'Authorization': 'Bearer $key'}),
          data: body);
      log('Notification ${res.data}');
    } on d.DioError catch (e) {
      AppWidget.toast(text: e.toString());
    }
  }
}