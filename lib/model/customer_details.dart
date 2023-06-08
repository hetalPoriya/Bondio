// To parse this JSON data, do
//
//     final customerDetails = customerDetailsFromMap(jsonString);

import 'dart:convert';

CustomerDetails customerDetailsFromMap(String str) =>
    CustomerDetails.fromMap(json.decode(str));

String customerDetailsToMap(CustomerDetails data) => json.encode(data.toMap());

class CustomerDetails {
  bool? status;
  String? msg;
  Data? data;

  CustomerDetails({
    this.status,
    this.msg,
    this.data,
  });

  factory CustomerDetails.fromMap(Map<String, dynamic> json) => CustomerDetails(
        status: json["Status"],
        msg: json["Msg"],
        data: json["Data"] == null ? null : Data.fromMap(json["Data"]),
      );

  Map<String, dynamic> toMap() => {
        "Status": status,
        "Msg": msg,
        "Data": data?.toMap(),
      };
}

class Data {
  int? id;
  String? name;
  dynamic lname;
  String? email;
  String? mobile;
  dynamic zipCode;
  dynamic country;
  dynamic state;
  dynamic city;
  dynamic aboutMe;
  dynamic photo;
  dynamic photoSocial;
  dynamic company;
  dynamic dob;
  dynamic gender;
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
  int? referredCustomersCount;
  int? balance;
  int? attendance;
  int? upcoming;

  Data({
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
    this.referredCustomersCount,
    this.balance,
    this.attendance,
    this.upcoming,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
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
        referredCustomersCount: json["referred_customers_count"],
        balance: json["balance"],
        attendance: json["attendance"],
        upcoming: json["upcoming"],
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
        "referred_customers_count": referredCustomersCount,
        "balance": balance,
        "attendance": attendance,
        "upcoming": upcoming,
      };
}
