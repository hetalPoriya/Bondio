import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

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
      this.lName,
      this.photoSocial,
      this.onlineStatus,
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
  String? onlineStatus;
  dynamic lName;
  dynamic photoSocial;
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
        "name1": name,
        "email1": email,
        "lname": lName,
        "photo_social": photoSocial,
        "online_status": onlineStatus,
        "mobile1": mobile,
        "zip_code": zipCode,
        "country": country,
        "state": state,
        "city": city,
        "about_me": aboutMe,
        "photo": photo,
        "company": company,
        "dob": dob,
        "gender": gender,
        "password1": password,
        "refer_code": referCode,
        "refer_by": referBy,
        "device_token": deviceToken,
        "google_token": googleToken,
        "facebook_token": facebookToken,
        "outlook_token": outlookToken,
        "instagram_token": instagramToken,
        "linkedin_token": linkedinToken,
        "twitter_token": twitterToken,
        "otp1": otp,
        "service1": service
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
    this.lName,
    this.onlineStatus,
    this.photoSocial,
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

  dynamic id;
  String? name;
  String? lName;
  String? photoSocial;
  String? onlineStatus;
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
  String? createdAt;
  String? updatedAt;

  factory User.fromMap(Map<String, dynamic>? json) => User(
        id: json?["id"] ?? '',
        name: json?["name"] ?? '',
        lName: json?["lname"] ?? '',
        photoSocial: json?["photo_social"] ?? '',
        onlineStatus: json?["online_status"] ?? '',
        email: json?["email"] ?? '',
        mobile: json?["mobile"] ?? '',
        zipCode: json?["zip_code"] ?? '',
        country: json?["country"] ?? '',
        state: json?["state"] ?? '',
        city: json?["city"] ?? '',
        aboutMe: json?["about_me"] ?? '',
        photo: json?["photo"] ?? '',
        company: json?["company"] ?? '',
        dob: json?["dob"] ?? '',
        gender: json?["gender"] ?? '',
        oPassword: json?["o_password"] ?? '',
        referCode: json?["refer_code"] ?? '',
        referBy: json?["refer_by"] ?? '',
        deviceToken: json?["device_token"] ?? '',
        googleToken: json?["google_token"] ?? '',
        facebookToken: json?["facebook_token"] ?? '',
        outlookToken: json?["outlook_token"] ?? '',
        createdAt: json?["created_at"],
        updatedAt: json?["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "lname": lName,
        "photo_social": photoSocial,
        "online_status": onlineStatus,
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
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

//
  factory User.fromDocument(DocumentSnapshot doc) {
    int? id = doc.get('id');
    String? name = doc.get('name');
    String? lName = doc.get('lname');
    String? photoSocial = doc.get('photo_social');
    String? onlineStatus = doc.get('online_status');
    String? email = doc.get('email');
    String? mobile = doc.get('mobile');
    dynamic zipCode = doc.get('zip_code');
    dynamic country = doc.get('country');
    dynamic state = doc.get('state');
    dynamic city = doc.get('city');
    dynamic aboutMe = doc.get('about_me');
    dynamic photo = doc.get('photo');
    String? company = doc.get('company');
    String? dob = doc.get('dob');
    dynamic gender = doc.get('gender');
    String? oPassword = doc.get('o_password');
    String? referCode = doc.get('refer_code');
    dynamic referBy = doc.get('refer_by');
    String? deviceToken = doc.get('device_token');
    dynamic googleToken = doc.get('google_token');
    dynamic facebookToken = doc.get('facebook_token');
    dynamic outlookToken = doc.get('outlook_token');
    String? createdAt = doc.get('created_at');
    String? updatedAt = doc.get('updated_at');

    return User(
      id: id,
      name: name,
      lName: lName,
      photoSocial: photoSocial,
      onlineStatus: onlineStatus,
      email: email,
      mobile: mobile,
      zipCode: zipCode,
      country: country,
      state: state,
      city: city,
      aboutMe: aboutMe,
      photo: photo,
      company: company,
      dob: dob,
      gender: gender,
      oPassword: oPassword,
      referCode: referCode,
      referBy: referBy,
      deviceToken: deviceToken,
      googleToken: googleToken,
      facebookToken: facebookToken,
      outlookToken: outlookToken,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}