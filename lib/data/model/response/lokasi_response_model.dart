import 'dart:convert';

class LokasiResponseModel {
  final String message;
  final int statusCode;
  final List<DataLokasi> data;

  LokasiResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory LokasiResponseModel.fromRawJson(String str) =>
      LokasiResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LokasiResponseModel.fromJson(Map<String, dynamic> json) =>
      LokasiResponseModel(
        message: json["message"] ?? '',
        statusCode: json["status_code"] ?? 0,
        data: json["data"] != null
            ? List<DataLokasi>.from(
                json["data"].map((x) => DataLokasi.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataLokasi {
  final int idLokasi;
  final String namaLokasi;

  DataLokasi({
    required this.idLokasi,
    required this.namaLokasi,
  });

  factory DataLokasi.fromJson(Map<String, dynamic> json) => DataLokasi(
        idLokasi: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"].toString()) ?? 0,
        namaLokasi: json["nama_lokasi"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": idLokasi,
        "nama_lokasi": namaLokasi,
      };
}
