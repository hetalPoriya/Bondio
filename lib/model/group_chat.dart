import 'package:bondio/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChat {
  String? groupName;
  String? groupIcon;

  List<dynamic>? members;
  List<dynamic>? membersId;
  List<dynamic>? isAdmin;
  String? groupId;
  String? lastMessage;
  String? lastMessageSender;
  String? timestamp;

  GroupChat(
      {this.groupName,
      this.groupIcon,
      this.members,
      this.groupId,
      this.isAdmin,
      this.lastMessage,
      this.lastMessageSender,
      this.membersId,
      this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      ApiConstant.groupName: groupName,
      ApiConstant.groupIcon: groupIcon,
      ApiConstant.members: members,
      ApiConstant.membersId: membersId,
      ApiConstant.isAdmin: isAdmin,
      ApiConstant.groupId: groupId,
      ApiConstant.lastMessage: lastMessage,
      ApiConstant.lastMessageSender: lastMessageSender,
      ApiConstant.timestamp: timestamp,
    };
  }

  factory GroupChat.fromDocument(DocumentSnapshot doc) {
    String groupName = doc.get(ApiConstant.groupName);
    String groupIcon = doc.get(ApiConstant.groupIcon);
    List<dynamic> members = doc.get(ApiConstant.members);
    List<dynamic> membersId = doc.get(ApiConstant.membersId);
    List<dynamic> isAdmin = doc.get(ApiConstant.isAdmin);
    String groupId = doc.get(ApiConstant.groupId);
    String lastMessage = doc.get(ApiConstant.lastMessage);
    String lastMessageSender = doc.get(ApiConstant.lastMessageSender);
    String timestamp = doc.get(ApiConstant.timestamp);
    return GroupChat(
      groupName: groupName,
      groupIcon: groupIcon,
      groupId: groupId,
      members: members,
      membersId: membersId,
      isAdmin: isAdmin,
      lastMessage: lastMessage,
      lastMessageSender: lastMessageSender,
      timestamp: timestamp,
    );
  }
}
