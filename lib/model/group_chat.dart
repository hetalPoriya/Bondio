import 'package:bondio/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChat {
  String? groupName;
  String? groupIcon;
  bool? isPinned;

  List<dynamic>? members;
  List<dynamic>? membersId;
  List<dynamic>? isAdmin;
  List<dynamic>? isArchive;

  String? groupId;
  String? lastMessage;
  String? lastMessageSender;
  String? timestamp;
  bool? isEvent;
  String? eventId;
  String? eventDes;
  String? eventTime;
  String? eventDate;
  String? eventLocation;

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
    this.isEvent = false,
    this.eventId,
    this.eventLocation,
    this.eventTime,
    this.eventDes,

    this.isArchive,
  });

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
      ApiConstant.eventDate: eventDate,
      ApiConstant.isArchive: isArchive,
      ApiConstant.isEvent: isEvent,
      ApiConstant.eventDescription: eventDes,
      ApiConstant.eventTimeChat: eventTime,
      ApiConstant.eventLoc: eventLocation,
      ApiConstant.eventDate: eventDate,
      ApiConstant.eventId: eventId,
    };
  }

  factory GroupChat.fromDocument(DocumentSnapshot doc) {
    String groupName = doc.get(ApiConstant.groupName);
    String groupIcon = doc.get(ApiConstant.groupIcon);
    bool isPinned = doc.get(ApiConstant.isPinned);
    List<dynamic> members = doc.get(ApiConstant.members);
    List<dynamic> membersId = doc.get(ApiConstant.membersId);
    List<dynamic> isAdmin = doc.get(ApiConstant.isAdmin);
    List<dynamic> isArchive = doc.get(ApiConstant.isArchive);

    String groupId = doc.get(ApiConstant.groupId);
    String lastMessage = doc.get(ApiConstant.lastMessage);
    String lastMessageSender = doc.get(ApiConstant.lastMessageSender);
    String timestamp = doc.get(ApiConstant.timestamp);
    bool isEvent = doc.get(ApiConstant.isEvent);
    String eventDes = doc.get(ApiConstant.eventDescription);
    String eventTime = doc.get(ApiConstant.eventTimeChat);
    String eventLoc = doc.get(ApiConstant.eventLoc);
    String eventDate = doc.get(ApiConstant.eventDate);
    String eventId = doc.get(ApiConstant.eventId);

    return GroupChat(
        groupName: groupName,
        groupIcon: groupIcon,
        isPinned: isPinned,
        groupId: groupId,
        members: members,
        membersId: membersId,
        isArchive: isArchive,
        isAdmin: isAdmin,
        lastMessage: lastMessage,
        lastMessageSender: lastMessageSender,
        timestamp: timestamp,
        isEvent: isEvent,
        eventDate: eventDate,
        eventDes: eventDes,
        eventId: eventId,
        eventLocation: eventLoc,
        eventTime: eventTime
    );
  }
}