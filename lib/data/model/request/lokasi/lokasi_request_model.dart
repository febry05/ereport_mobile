import 'dart:convert';

class LokasiRequestModel {
  final String? namaLokasi;

  LokasiRequestModel({
    this.namaLokasi,
  });

  factory LokasiRequestModel.fromJson(String str) =>
      LokasiRequestModel.fromMap(json.decode(str));

  Map<String, dynamic> toJson() => toMap();

  factory LokasiRequestModel.fromMap(Map<String, dynamic> json) =>
      LokasiRequestModel(
        namaLokasi: json["nama_lokasi"],

      );

  Map<String, dynamic> toMap() => {
        "nama_lokasi": namaLokasi,
  };
}
