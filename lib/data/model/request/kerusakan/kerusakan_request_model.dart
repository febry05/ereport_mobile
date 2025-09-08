import 'dart:convert';

class KerusakanRequestModel {
  final int? userId;
  final int? projectId;
  final int? lokasiId;
  final String fasilitas;
  final String tanggal; 
  final double latPosisi;
  final double lngPosisi;
  final String deskripsi;
  final String? fotoKerusakan;
  final String status;

  KerusakanRequestModel({
    this.userId,
    this.projectId,
    this.lokasiId,
    required this.fasilitas,
    required this.tanggal,
    required this.latPosisi,
    required this.lngPosisi,
    required this.deskripsi,
    this.fotoKerusakan,
    this.status = 'pending',
  });

  factory KerusakanRequestModel.fromJson(String str) =>
      KerusakanRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory KerusakanRequestModel.fromMap(Map<String, dynamic> json) =>
    KerusakanRequestModel(
      userId: json["user_id"] is int
          ? json["user_id"]
          : int.tryParse(json["user_id"].toString()),
      projectId: json["id_project"] is int
          ? json["id_project"]
          : int.tryParse(json["id_project"].toString()),
      lokasiId: json["id_lokasi"] is int
          ? json["id_lokasi"]
          : int.tryParse(json["id_lokasi"].toString()),
      fasilitas: json["fasilitas"] ?? '',
      tanggal: json["tanggal"] ?? '',
      latPosisi: (json["lat_posisi"] ?? 0).toDouble(),
      lngPosisi: (json["lng_posisi"] ?? 0).toDouble(),
      deskripsi: json["deskripsi"] ?? '',
      fotoKerusakan: json["foto_kerusakan"],
      status: json["status"] ?? 'pending',
    );


  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "id_project": projectId,
        "id_lokasi": lokasiId,
        "fasilitas": fasilitas,
        "tanggal": tanggal,
        "lat_posisi": latPosisi,
        "lng_posisi": lngPosisi,
        "deskripsi": deskripsi,
        "foto_kerusakan": fotoKerusakan,
        "status": status,
  };
}
