import 'package:bondio/controller/controller.dart';
import 'package:bondio/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  String? id;
  String? lastMessage;
  String? timestamp;
  List<dynamic>? user1;
  List<dynamic>? user2;
  List<dynamic>? members;

  UserInfo(
      {this.id,
      this.timestamp,
      this.lastMessage,
      this.members,
      this.user1,
      this.user2});

  Map<String, dynamic> toJson() {
    return {
      ApiConstant.id: id,
      ApiConstant.lastMessage: lastMessage,
      ApiConstant.timestamp: timestamp,
      ApiConstant.user1: user1,
      ApiConstant.user2: user2,
      ApiConstant.members: members,
    };
  }

  factory UserInfo.fromDocument(DocumentSnapshot doc) {
    String id = doc.get(ApiConstant.id);
    String timestamp = doc.get(ApiConstant.timestamp);
    String lastMessage = doc.get(ApiConstant.lastMessage);
    List<dynamic>? user1 = doc.get(ApiConstant.user1);
    List<dynamic>? user2 = doc.get(ApiConstant.user2);
    List<dynamic>? members = doc.get(ApiConstant.members);

    return UserInfo(
      id: id,
      timestamp: timestamp,
      lastMessage: lastMessage,
      user1: user1,
      user2: user2,
      members: members,
    );
  }
}
