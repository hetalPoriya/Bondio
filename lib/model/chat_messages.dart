import 'package:bondio/controller/controller.dart';
import 'package:bondio/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessages {
  String? idFrom;
  String? idTo;
  String? timestamp;
  String? content;
  String? senderName = '';
  bool? isRead;

  ChatMessages(
      {this.idFrom,
      this.idTo,
      this.timestamp,
      this.content,
      this.isRead,
      this.senderName});

  Map<String, dynamic> toJson() {
    return {
      ApiConstant.idFrom: idFrom,
      ApiConstant.idTo: idTo,
      ApiConstant.timestamp: timestamp,
      ApiConstant.lastMessage: content,
      ApiConstant.isRead: isRead,
      ApiConstant.senderName: senderName,
    };
  }

  factory ChatMessages.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(ApiConstant.idFrom);
    String idTo = doc.get(ApiConstant.idTo);
    String timestamp = doc.get(ApiConstant.timestamp);
    String content = doc.get(ApiConstant.lastMessage);
    bool isRead = doc.get(ApiConstant.isRead);
    String senderName = doc.get(ApiConstant.senderName);
    return ChatMessages(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        isRead: isRead,
        senderName: senderName);
  }
}
