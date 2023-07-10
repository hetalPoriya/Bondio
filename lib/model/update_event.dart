// To parse this JSON data, do
//
//     final updateEventModel = updateEventModelFromMap(jsonString);

import 'dart:convert';

UpdateEventModel updateEventModelFromMap(String str) =>
    UpdateEventModel.fromMap(json.decode(str));

String updateEventModelToMap(UpdateEventModel data) =>
    json.encode(data.toMap());

class UpdateEventModel {
  final bool? status;
  final String? msg;
  final EventData? data;

  UpdateEventModel({
    this.status,
    this.msg,
    this.data,
  });

  factory UpdateEventModel.fromMap(Map<String, dynamic> json) =>
      UpdateEventModel(
        status: json["Status"],
        msg: json["Msg"],
        data: json["Data"] == null ? null : EventData.fromMap(json["Data"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "Status": status,
        "Msg": msg,
        "Data": data?.toMap(),
      };
}

class EventData {
  final int? id;
  final int? customerId;
  final String? name;
  final String? description;
  final String? location;
  final String? date;
  final String? time;
  final dynamic photo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<EventCustomer>? customers;

  EventData({
    this.id,
    this.customerId,
    this.name,
    this.description,
    this.location,
    this.date,
    this.time,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.customers,
  });

  factory EventData.fromMap(Map<String, dynamic> json) =>
      EventData(
        id: json["id"],
        customerId: json["customer_id"],
        name: json["name"],
        description: json["description"],
        location: json["location"],
        date: json["date"],
        time: json["time"],
        photo: json["photo"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(
            json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(
            json["updated_at"]),
        customers: json["customers"] == null ? [] : List<EventCustomer>.from(
            json["customers"]!.map((x) => EventCustomer.fromMap(x))),
      );

  Map<String, dynamic> toMap() =>
      {
        "id": id,
        "customer_id": customerId,
        "name": name,
        "description": description,
        "location": location,
        "date": date,
        "time": time,
        "photo": photo,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "customers": customers == null ? [] : List<dynamic>.from(
            customers!.map((x) => x.toMap())),
      };
}

class EventCustomer {
  final int? id;
  final String? name;
  final dynamic lname;
  final String? email;
  final String? mobile;
  final dynamic zipCode;
  final dynamic country;
  final dynamic state;
  final dynamic city;
  final dynamic aboutMe;
  final dynamic photo;
  final String? photoSocial;
  final dynamic company;
  final dynamic dob;
  final dynamic gender;
  final String? oPassword;
  final String? referCode;
  final dynamic referBy;
  final String? deviceToken;
  final String? googleToken;
  final dynamic facebookToken;
  final dynamic instagramToken;
  final dynamic twitterToken;
  final dynamic linkedinToken;
  final dynamic outlookToken;
  final String? onlineStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final EventPivot? pivot;

  EventCustomer({
    this.id,
    this.name,
    this.lname,
    this.email,
    this.mobile,
    this.zipCode,
    this.country,
    this.state,
    this.city,
    this.aboutMe,
    this.photo,
    this.photoSocial,
    this.company,
    this.dob,
    this.gender,
    this.oPassword,
    this.referCode,
    this.referBy,
    this.deviceToken,
    this.googleToken,
    this.facebookToken,
    this.instagramToken,
    this.twitterToken,
    this.linkedinToken,
    this.outlookToken,
    this.onlineStatus,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory EventCustomer.fromMap(Map<String, dynamic> json) =>
      EventCustomer(
        id: json["id"],
        name: json["name"],
        lname: json["lname"],
        email: json["email"],
        mobile: json["mobile"],
        zipCode: json["zip_code"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        aboutMe: json["about_me"],
        photo: json["photo"],
        photoSocial: json["photo_social"],
        company: json["company"],
        dob: json["dob"],
        gender: json["gender"],
        oPassword: json["o_password"],
        referCode: json["refer_code"],
        referBy: json["refer_by"],
        deviceToken: json["device_token"],
        googleToken: json["google_token"],
        facebookToken: json["facebook_token"],
        instagramToken: json["instagram_token"],
        twitterToken: json["twitter_token"],
        linkedinToken: json["linkedin_token"],
        outlookToken: json["outlook_token"],
        onlineStatus: json["online_status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(
            json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(
            json["updated_at"]),
        pivot: json["pivot"] == null ? null : EventPivot.fromMap(json["pivot"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "id": id,
        "name": name,
        "lname": lname,
        "email": email,
        "mobile": mobile,
        "zip_code": zipCode,
        "country": country,
        "state": state,
        "city": city,
        "about_me": aboutMe,
        "photo": photo,
        "photo_social": photoSocial,
        "company": company,
        "dob": dob,
        "gender": gender,
        "o_password": oPassword,
        "refer_code": referCode,
        "refer_by": referBy,
        "device_token": deviceToken,
        "google_token": googleToken,
        "facebook_token": facebookToken,
        "instagram_token": instagramToken,
        "twitter_token": twitterToken,
        "linkedin_token": linkedinToken,
        "outlook_token": outlookToken,
        "online_status": onlineStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toMap(),
      };
}

class EventPivot {
  final int? customerEventId;
  final int? customerId;

  EventPivot({
    this.customerEventId,
    this.customerId,
  });

  factory EventPivot.fromMap(Map<String, dynamic> json) =>
      EventPivot(
        customerEventId: json["customer_event_id"],
        customerId: json["customer_id"],
      );

  Map<String, dynamic> toMap() =>
      {
        "customer_event_id": customerEventId,
        "customer_id": customerId,
      };
}