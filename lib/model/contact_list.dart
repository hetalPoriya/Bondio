class ContactListModel {
  String? id;
  String? status;
  String? name;
  String? phoneNumber;

  ContactListModel({this.id, this.status, this.name, this.phoneNumber});

  factory ContactListModel.fromMap(Map<String, dynamic> json) =>
      ContactListModel(
        id: json["loginId"] ?? '',
        status: json["status"] ?? '',
        name: json["displayName"] ?? '',
        phoneNumber: json["phones"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "loginId": id,
        "status": status,
        "displayName": name,
        "phones": phoneNumber,
      };
}