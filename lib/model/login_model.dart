// To parse this JSON data, do
//
//     final loginModel = loginModelFromMap(jsonString);

import 'dart:convert';

LoginModel loginModelFromMap(String str) =>
    LoginModel.fromMap(json.decode(str));

String loginModelToMap(LoginModel data) => json.encode(data.toMap());

String signUpBodyToMap(SignUpBody data) => json.encode(data.toMap());

String loginBodyToMap(LoginBody data) => json.encode(data.toMap());

String userInfoBodyToMap(User data) => json.encode(data.toMap());

class LoginBody {
  String email;
  String password;

  LoginBody({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        "email": email,
        "password": password,
      };
}

class SignUpBody {
  SignUpBody(
      {this.name,
      this.email,
      this.mobile,
      this.zipCode,
      this.country,
      this.state,
      this.city,
      this.aboutMe,
      this.photo,
      this.company,
      this.dob,
      this.gender,
      this.password,
      this.referCode,
      this.referBy,
      this.deviceToken,
      this.googleToken,
      this.facebookToken,
      this.outlookToken,
      this.twitterToken,
      this.linkedinToken,
      this.instagramToken,
      this.otp,
      this.service});

  String? name;
  String? email;
  String? mobile;
  dynamic zipCode;
  dynamic country;
  dynamic state;
  dynamic city;
  dynamic aboutMe;
  dynamic photo;
  String? company;
  String? dob;
  dynamic gender;
  String? password;
  String? referCode;
  dynamic referBy;
  String? deviceToken;
  dynamic googleToken;
  dynamic facebookToken;
  dynamic outlookToken;
  dynamic instagramToken;
  dynamic twitterToken;
  dynamic linkedinToken;
  String? otp;
  String? service;

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "mobile": mobile,
        "zip_code": zipCode,
        "country": country,
        "state": state,
        "city": city,
        "about_me": aboutMe,
        "photo": photo,
        "company": company,
        "dob": dob,
        "gender": gender,
        "password": password,
        "refer_code": referCode,
        "refer_by": referBy,
        "device_token": deviceToken,
        "google_token": googleToken,
        "facebook_token": facebookToken,
        "outlook_token": outlookToken,
        "instagram_token": instagramToken,
        "linkedin_token": linkedinToken,
        "twitter_token": twitterToken,
        "otp": otp,
        "service": service
      };
}

class LoginModel {
  LoginModel({
    this.status,
    this.msg,
    this.data,
  });

  bool? status;
  String? msg;
  LoginData? data;

  factory LoginModel.fromMap(Map<String, dynamic> json) => LoginModel(
        status: json["Status"],
        msg: json["Msg"],
        data: json["Data"] == null ? null : LoginData.fromMap(json["Data"]),
      );

  Map<String, dynamic> toMap() => {
        "Status": status,
        "Msg": msg,
        "Data": data?.toMap(),
      };
}

class LoginData {
  LoginData({
    this.user,
    this.token,
  });

  User? user;
  String? token;

  factory LoginData.fromMap(Map<String, dynamic> json) => LoginData(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "token": token,
      };
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.zipCode,
    this.country,
    this.state,
    this.city,
    this.aboutMe,
    this.photo,
    this.company,
    this.dob,
    this.gender,
    this.oPassword,
    this.referCode,
    this.referBy,
    this.deviceToken,
    this.googleToken,
    this.facebookToken,
    this.outlookToken,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? email;
  String? mobile;
  dynamic zipCode;
  dynamic country;
  dynamic state;
  dynamic city;
  dynamic aboutMe;
  dynamic photo;
  String? company;
  String? dob;
  dynamic gender;
  String? oPassword;
  String? referCode;
  dynamic referBy;
  String? deviceToken;
  dynamic googleToken;
  dynamic facebookToken;
  dynamic outlookToken;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        mobile: json["mobile"] ?? '',
        zipCode: json["zip_code"] ?? '',
        country: json["country"] ?? '',
        state: json["state"] ?? '',
        city: json["city"] ?? '',
        aboutMe: json["about_me"] ?? '',
        photo: json["photo"] ?? '',
        company: json["company"] ?? '',
        dob: json["dob"] ?? '',
        gender: json["gender"] ?? '',
        oPassword: json["o_password"] ?? '',
        referCode: json["refer_code"] ?? '',
        referBy: json["refer_by"] ?? '',
        deviceToken: json["device_token"] ?? '',
        googleToken: json["google_token"] ?? '',
        facebookToken: json["facebook_token"] ?? '',
        outlookToken: json["outlook_token"] ?? '',
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile": mobile,
        "zip_code": zipCode,
        "country": country,
        "state": state,
        "city": city,
        "about_me": aboutMe,
        "photo": photo,
        "company": company,
        "dob": dob,
        "gender": gender,
        "o_password": oPassword,
        "refer_code": referCode,
        "refer_by": referBy,
        "device_token": deviceToken,
        "google_token": googleToken,
        "facebook_token": facebookToken,
        "outlook_token": outlookToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
//
// factory User.fromDocument(DocumentSnapshot doc) {
//   int id = doc.get(ApiConstant.id);
//   String? name = doc.get(ApiConstant.id);
//   String? email = doc.get(ApiConstant.id);
//   String? mobile = doc.get(ApiConstant.id);
//   dynamic zipCode = doc.get(ApiConstant.id);
//   dynamic country = doc.get(ApiConstant.id);
//   dynamic state = doc.get(ApiConstant.id);
//   dynamic city = doc.get(ApiConstant.id);
//   dynamic aboutMe = doc.get(ApiConstant.id);
//   dynamic photo = doc.get(ApiConstant.id);
//   String? company = doc.get(ApiConstant.id);
//   String? dob = doc.get(ApiConstant.id);
//   dynamic gender = doc.get(ApiConstant.id);
//   String? oPassword = doc.get(ApiConstant.id);
//   String? referCode = doc.get(ApiConstant.id);
//   dynamic referBy = doc.get(ApiConstant.id);
//   String? deviceToken = doc.get(ApiConstant.id);
//   dynamic googleToken = doc.get(ApiConstant.id);
//   dynamic facebookToken = doc.get(ApiConstant.id);
//   DateTime? createdAt = doc.get(ApiConstant.id);
//   DateTime? updatedAt = doc.get(ApiConstant.id);
//
//   return UserInfo(
//     id: id,
//     timestamp: timestamp,
//     lastMessage: lastMessage,
//     user1: user1,
//     user2: user2,
//     members: members,
//   );
// }
}
