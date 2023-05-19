import 'package:flutter/services.dart';

class ContactListModel {
  String? id;
  String? status;
  String? name;

  //Uint8List? photoUrl;
  String? phoneNumber;

  ContactListModel({this.id, this.status, this.name, this.phoneNumber});

  factory ContactListModel.fromMap(Map<String, dynamic> json) =>
      ContactListModel(
        id: json["loginId"] ?? '',
        status: json["status"] ?? '',
        name: json["displayName"] ?? '',
        //photoUrl: json["photo"] ?? ' ' as Uint8List,
        phoneNumber: json["phones"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "loginId": id,
        "status": status,
        "displayName": name,
        //"photo": photoUrl ?? '',
        "phones": phoneNumber,
      };
}
