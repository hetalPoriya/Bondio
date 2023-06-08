// To parse this JSON data, do
//
//     final getEvent = getEventFromMap(jsonString);

import 'dart:convert';

GetEvent getEventFromMap(String str) => GetEvent.fromMap(json.decode(str));

String getEventToMap(GetEvent data) => json.encode(data.toMap());

String createEventToMap(CreateEventBody data) => json.encode(data.toMap());

class CreateEventBody {
  String? id;
  String name;
  String location;
  String? date;
  String time;
  String? users;
  String description;
  dynamic photo;

  CreateEventBody(
      {this.id,
      required this.name,
      required this.location,
      this.date,
      required this.time,
      required this.description,
      this.photo,
      this.users});

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "location": location,
        "date": date,
        "time": time,
        "users": users,
        "description": description,
        "photo": photo,
      };
}

class GetEvent {
  bool? status;
  String? msg;
  List<GetEventList>? data;

  GetEvent({
    this.status,
    this.msg,
    this.data,
  });

  factory GetEvent.fromMap(Map<String, dynamic> json) => GetEvent(
        status: json["Status"],
        msg: json["Msg"],
        data: json["Data"] == null
            ? []
            : List<GetEventList>.from(
                json["Data"]!.map((x) => GetEventList.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "Status": status,
        "Msg": msg,
        "Data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class GetEventList {
  int? id;
  int? customerId;
  String? name;
  String? description;
  String? location;
  dynamic? date;
  String? time;
  String? photo;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Customer>? customers;

  GetEventList({
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

  factory GetEventList.fromMap(Map<String, dynamic> json) => GetEventList(
        id: json["id"],
        customerId: json["customer_id"],
        name: json["name"],
        description: json["description"],
        location: json["location"],
        date: json["date"],
        time: json["time"],
        photo: json["photo"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        customers: json["customers"] == null
            ? []
            : List<Customer>.from(
                json["customers"]!.map((x) => Customer.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
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
        "customers": customers == null
            ? []
            : List<dynamic>.from(customers!.map((x) => x.toMap())),
      };
}

class Customer {
  int? id;
  String? name;
  String? lname;
  String? email;
  String? mobile;
  String? zipCode;
  String? country;
  String? state;
  String? city;
  String? aboutMe;
  String? photo;
  String? photoSocial;
  String? company;
  dynamic? dob;
  String? gender;
  String? oPassword;
  String? referCode;
  String? referBy;
  dynamic deviceToken;
  dynamic googleToken;
  dynamic facebookToken;
  dynamic instagramToken;
  dynamic twitterToken;
  dynamic linkedinToken;
  dynamic outlookToken;
  String? onlineStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  Pivot? pivot;

  Customer({
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

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
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
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : Pivot.fromMap(json["pivot"]),
      );

  Map<String, dynamic> toMap() => {
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

class Pivot {
  int? customerEventId;
  int? customerId;

  Pivot({
    this.customerEventId,
    this.customerId,
  });

  factory Pivot.fromMap(Map<String, dynamic> json) => Pivot(
        customerEventId: json["customer_event_id"],
        customerId: json["customer_id"],
      );

  Map<String, dynamic> toMap() => {
        "customer_event_id": customerEventId,
        "customer_id": customerId,
      };
}
