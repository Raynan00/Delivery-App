// To parse this JSON data, do
//
//     final addonResponse = addonResponseFromJson(jsonString);

import 'dart:convert';

List<AddonResponse> addonResponseFromJson(String str) => List<AddonResponse>.from(json.decode(str).map((x) => AddonResponse.fromJson(x)));

String addonResponseToJson(List<AddonResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddonResponse {
  AddonResponse({
    this.id,
    this.name,
    this.uniqueIdentifier,
    this.version,
    this.activated,
    this.image,
    this.purchaseCode,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String uniqueIdentifier;
  String version;
  var activated;
  String image;
  String purchaseCode;
  DateTime createdAt;
  DateTime updatedAt;

  factory AddonResponse.fromJson(Map<String, dynamic> json) => AddonResponse(
    id: json["id"],
    name: json["name"],
    uniqueIdentifier: json["unique_identifier"],
    version: json["version"],
    activated: json["activated"],
    image: json["image"],
    purchaseCode: json["purchase_code"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "unique_identifier": uniqueIdentifier,
    "version": version,
    "activated": activated,
    "image": image,
    "purchase_code": purchaseCode,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
