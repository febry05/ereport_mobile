import 'dart:convert';

class KerusakanInventoryRequestModel {
  final int? kerusakanId;
  final int? inventoryId;
  final int? jumlah;

  KerusakanInventoryRequestModel({
    this.kerusakanId,
    this.inventoryId,
    this.jumlah,
  });

  factory KerusakanInventoryRequestModel.fromJson(String str) =>
      KerusakanInventoryRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory KerusakanInventoryRequestModel.fromMap(Map<String, dynamic> json) =>
    KerusakanInventoryRequestModel(
      kerusakanId: json["id_kerusakan"] is int
          ? json["id_kerusakan"]
          : int.tryParse(json["id_kerusakan"].toString()),
      inventoryId: json["id_inventory"] is int
          ? json["id_inventory"]
          : int.tryParse(json["id_inventory"].toString()),
      jumlah: json["jumlah"] is int
          ? json["jumlah"]
          : int.tryParse(json["jumlah"].toString()),
    );


  Map<String, dynamic> toMap() => {
        "id_kerusakan": kerusakanId,
        "id_inventory": inventoryId,
        "jumlah": jumlah,
  };
}
