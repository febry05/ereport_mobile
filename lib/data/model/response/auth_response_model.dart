import 'dart:convert';

class AuthResponseModel {
  final String? message;
  final int? statusCode;
  final User? user;

  AuthResponseModel({
    this.message,
    this.statusCode,
    this.user,
  });

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        user: json["data"] == null ? null : User.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": user?.toMap(),
      };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? token;
  final String? role;
  final List<String>? akses;

  User({
    this.id,
    this.name,
    this.email,
    this.token,
    this.role,
    this.akses, 
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        token: json["token"],  
        role: json["role"],    
        akses: (json["akses"] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(), 
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "token": token,
        "role": role,
        "akses": akses,
      };
}
