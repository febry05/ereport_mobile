import 'dart:convert';

class InventoryListResponseModel {
  final String message;
  final int statusCode;
  final List<Inventory> data;

  InventoryListResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory InventoryListResponseModel.fromRawJson(String str) =>
      InventoryListResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InventoryListResponseModel.fromJson(Map<String, dynamic> json) =>
      InventoryListResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: List<Inventory>.from(
          json["data"].map((x) => Inventory.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Inventory {
  final int id;
  final String namaInventory;
  final int jumlah; 

  Inventory({
    required this.id,
    required this.namaInventory,
    required this.jumlah,
  });

  factory Inventory.fromRawJson(String str) =>
      Inventory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        id: json["id"],
        namaInventory: json["nama_inventory"],
        jumlah: json["jumlah"] is int
            ? json["jumlah"]
            : int.tryParse(json["jumlah"].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_inventory": namaInventory,
        "jumlah": jumlah,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Inventory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
