import 'dart:convert';

class UserRequestModel {
  final String? nama;
  final String? nip;
  final String? email;
  final String? notlp;
  final String? alamat;

  UserRequestModel({
    this.nama,
    this.nip,
    this.email,
    this.notlp,
    this.alamat,
  });

  factory UserRequestModel.fromJson(String str) =>
      UserRequestModel.fromMap(json.decode(str));

  Map<String, dynamic> toJson() => toMap();

  factory UserRequestModel.fromMap(Map<String, dynamic> json) =>
      UserRequestModel(
        nama: json["name"],
        nip: json["nip"],
        notlp: json["notlp"],
        alamat: json["alamat"],
        
      );

  Map<String, dynamic> toMap() => {
        "name": nama,
        "nip": nip,
        "notlp": notlp,
        "alamat": alamat,
  };
}
