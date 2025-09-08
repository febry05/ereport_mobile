import 'dart:convert';

class UserResponseModel {
  final String message;
  final int statusCode;
  final DataUser? data;

  UserResponseModel({
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory UserResponseModel.fromRawJson(String str) =>
      UserResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] != null ? DataUser.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data?.toJson(),
      };
}

class DataUser {
  final int id;
  final String name;
  final String nip;
  final String notlp;
  final String alamat;
  final String email;
  

  DataUser({
    required this.id,
    required this.name,
    required this.nip,
    required this.notlp,
    required this.alamat,
    required this.email,
  });

  factory DataUser.fromRawJson(String str) =>
      DataUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        id: json["id"],
        name: json["name"],
        nip: json["nip"].toString(),
        notlp: json["notlp"],
        alamat: json["alamat"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nip": nip,
        "notlp": notlp,
        "alamat": alamat,
        "email": email,
        
      };
}
