import 'package:bondio/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GroupChat {
  String? groupName;
  String? groupIcon;
  bool? isPinned;

  List<dynamic>? members;
  List<dynamic>? membersId;
  List<dynamic>? isAdmin;
  String? groupId;
  String? lastMessage;
  String? lastMessageSender;
  String? timestamp;
  final String? eventDate;
  bool? isEvent;

  GroupChat({this.groupName,
    this.groupIcon,
    this.isPinned,
    this.members,
    this.groupId,
    this.isAdmin,
    this.lastMessage,
    this.lastMessageSender,
    this.membersId,
    this.timestamp,
    this.eventDate,
    this.isEvent = false});

  Map<String, dynamic> toJson() {
    return {
      ApiConstant.groupName: groupName,
      ApiConstant.groupIcon: groupIcon,
      ApiConstant.isPinned: isPinned,
      ApiConstant.members: members,
      ApiConstant.membersId: membersId,
      ApiConstant.isAdmin: isAdmin,
      ApiConstant.groupId: groupId,
      ApiConstant.lastMessage: lastMessage,
      ApiConstant.lastMessageSender: lastMessageSender,
      ApiConstant.timestamp: timestamp,
      ApiConstant.isEvent: isEvent,
      ApiConstant.eventDate: eventDate
    };
  }

  factory GroupChat.fromDocument(DocumentSnapshot doc) {
    String groupName = doc.get(ApiConstant.groupName);
    String groupIcon = doc.get(ApiConstant.groupIcon);
    bool isPinned = doc.get(ApiConstant.isPinned);
    List<dynamic> members = doc.get(ApiConstant.members);
    List<dynamic> membersId = doc.get(ApiConstant.membersId);
    List<dynamic> isAdmin = doc.get(ApiConstant.isAdmin);
    String groupId = doc.get(ApiConstant.groupId);
    String lastMessage = doc.get(ApiConstant.lastMessage);
    String lastMessageSender = doc.get(ApiConstant.lastMessageSender);
    String timestamp = doc.get(ApiConstant.timestamp);
    String eventDate = doc.get(ApiConstant.eventDate);
    bool isEvent = doc.get(ApiConstant.isEvent);
    return GroupChat(
      groupName: groupName,
      groupIcon: groupIcon,
      isPinned: isPinned,
      groupId: groupId,
      members: members,
      membersId: membersId,
      isAdmin: isAdmin,
      lastMessage: lastMessage,
      lastMessageSender: lastMessageSender,
      timestamp: timestamp,
      isEvent: isEvent,
      eventDate: eventDate,
    );
  }
}