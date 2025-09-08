import 'dart:convert';

class KerusakanInventoryModel {
  final String message;
  final int statusCode;
  final List<KerusakanInventory> data;

  KerusakanInventoryModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory KerusakanInventoryModel.fromRawJson(String str) =>
      KerusakanInventoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory KerusakanInventoryModel.fromJson(Map<String, dynamic> json) =>
      KerusakanInventoryModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: List<KerusakanInventory>.from(
          json["data"].map((x) => KerusakanInventory.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class KerusakanInventory {
  final int? idKerusakanInventory;
  final int? idKerusakan;
  final int? idInventory;
  final int? jumlah;

  KerusakanInventory({
    this.idKerusakanInventory,
    this.idKerusakan,
    this.idInventory,
    this.jumlah,
  });

  factory KerusakanInventory.fromRawJson(String str) =>
      KerusakanInventory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory KerusakanInventory.fromJson(Map<String, dynamic> json) =>
      KerusakanInventory(
        idKerusakanInventory: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"].toString()),
        idKerusakan: json["id_kerusakan"] is int
            ? json["id_kerusakan"]
            : int.tryParse(json["id_kerusakan"]?.toString() ?? ''),
        idInventory: json["id_inventory"] is int
            ? json["id_inventory"]
            : int.tryParse(json["id_inventory"]?.toString() ?? ''),
        jumlah: json["jumlah"] is int
            ? json["jumlah"]
            : int.tryParse(json["jumlah"]?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "id": idKerusakanInventory,
        "id_kerusakan": idKerusakan,
        "id_inventory": idInventory,
        "jumlah": jumlah,
      };
}
