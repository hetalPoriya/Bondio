import 'package:bondio/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessages {
  String? idFrom;
  String? idTo;
  String? timestamp;
  String? content;
  String? senderName = '';
  bool? isRead;

  List<dynamic>? deletedUserList = [];

  ChatMessages(
      {this.idFrom,
      this.idTo,
      this.timestamp,
      this.content,
      this.isRead,
      this.senderName,
      this.deletedUserList});

  Map<String, dynamic> toJson() {
    return {
      ApiConstant.idFrom: idFrom,
      ApiConstant.idTo: idTo,
      ApiConstant.timestamp: timestamp,
      ApiConstant.lastMessage: content,
      ApiConstant.isRead: isRead,
      ApiConstant.senderName: senderName,
      ApiConstant.deletedUserList: deletedUserList == null
          ? []
          : List<dynamic>.from(deletedUserList!.map((x) => x))
    };
  }

  factory ChatMessages.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(ApiConstant.idFrom);
    String idTo = doc.get(ApiConstant.idTo);
    String timestamp = doc.get(ApiConstant.timestamp);
    String content = doc.get(ApiConstant.lastMessage);
    bool isRead = doc.get(ApiConstant.isRead);
    String senderName = doc.get(ApiConstant.senderName);
    List<dynamic> deletedUserList = doc.get(ApiConstant.deletedUserList) ?? [];
    return ChatMessages(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        isRead: isRead,
        senderName: senderName,
        deletedUserList: deletedUserList);
  }
}
