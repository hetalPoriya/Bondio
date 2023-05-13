import 'dart:convert';

SignUpModel signUpModelFromMap(String str) =>
    SignUpModel.fromMap(json.decode(str));

String signUpModelToMap(SignUpModel data) => json.encode(data.toMap());

class SignUpModel {
  SignUpModel({
    this.status,
    this.msg,
    this.data,
  });

  bool? status;
  String? msg;
  SignUpData? data;

  factory SignUpModel.fromMap(Map<String, dynamic> json) => SignUpModel(
        status: json["Status"],
        msg: json["Msg"],
        data: json["Data"] == null ? null : SignUpData.fromMap(json["Data"]),
      );

  Map<String, dynamic> toMap() => {
        "Status": status,
        "Msg": msg,
        "Data": data?.toMap(),
      };
}

class SignUpData {
  SignUpData({
    this.user,
    this.token,
  });

  SignUpUser? user;
  String? token;

  factory SignUpData.fromMap(Map<String, dynamic> json) => SignUpData(
        user: json["user"] == null ? null : SignUpUser.fromMap(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "token": token,
      };
}

class SignUpUser {
  SignUpUser({
    this.name,
    this.email,
    this.company,
    this.dob,
    this.gender,
    this.oPassword,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String? name;
  String? email;
  dynamic company;
  DateTime? dob;
  dynamic gender;
  String? oPassword;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory SignUpUser.fromMap(Map<String, dynamic> json) => SignUpUser(
        name: json["name"],
        email: json["email"],
        company: json["company"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        gender: json["gender"],
        oPassword: json["o_password"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "company": company,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "o_password": oPassword,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
