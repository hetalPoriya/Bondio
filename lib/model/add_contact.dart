import 'package:bondio/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddContactModel {
  String id;
  String userName;
  String status;
  String fcmToken;
  String phoneNumber;

  AddContactModel({
    required this.id,
    required this.userName,
    required this.status,
    required this.fcmToken,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiConstant.phoneNumber: phoneNumber,
      ApiConstant.userName: userName,
      ApiConstant.status: status,
      ApiConstant.fcmToken: fcmToken,
      ApiConstant.id: id,
    };
  }

  factory AddContactModel.fromDocument(DocumentSnapshot doc) {
    String phoneNumber = doc.get(ApiConstant.phoneNumber);
    String userName = doc.get(ApiConstant.userName);
    String status = doc.get(ApiConstant.status);
    String fcmToken = doc.get(ApiConstant.fcmToken);
    String id = doc.get(ApiConstant.id);
    return AddContactModel(
        id: id,
        userName: userName,
        status: status,
        fcmToken: fcmToken,
        phoneNumber: phoneNumber);
  }
}
