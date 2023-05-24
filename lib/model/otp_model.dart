// To parse this JSON data, do
//
//     final otpModel = otpModelFromMap(jsonString);

import 'dart:convert';

OtpModel otpModelFromMap(String str) => OtpModel.fromMap(json.decode(str));

String otpModelToMap(OtpMap data) => json.encode(data.toMap());

class OtpMap {
  String email;
  String name;
  String mobile;

  OtpMap({required this.email, required this.name, required this.mobile});

  Map<String, dynamic> toMap() => {
        "email": email,
        "name": name,
        "mobile": mobile,
      };
}

class OtpModel {
  bool? status;
  String? msg;
  OtpData? data;

  OtpModel({
    this.status,
    this.msg,
    this.data,
  });

  factory OtpModel.fromMap(Map<String, dynamic> json) => OtpModel(
        status: json["Status"],
        msg: json["Msg"],
        data: json["Data"] == null ? null : OtpData.fromMap(json["Data"]),
      );

  Map<String, dynamic> toMap() => {
        "Status": status,
        "Msg": msg,
        "Data": data?.toMap(),
      };
}

class OtpData {
  String? service;

  OtpData({
    this.service,
  });

  factory OtpData.fromMap(Map<String, dynamic> json) => OtpData(
        service: json["service"],
      );

  Map<String, dynamic> toMap() => {
        "service": service,
      };
}
