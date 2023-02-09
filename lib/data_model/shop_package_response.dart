// To parse this JSON data, do
//
//     final shopPackageResponse = shopPackageResponseFromJson(jsonString);

import 'dart:convert';

ShopPackageResponse shopPackageResponseFromJson(String str) => ShopPackageResponse.fromJson(json.decode(str));

String shopPackageResponseToJson(ShopPackageResponse data) => json.encode(data.toJson());

class ShopPackageResponse {
  ShopPackageResponse({
    this.result,
    this.id,
    this.packageName,
    this.packageImg,
  });

  bool result;
  int id;
  String packageName;
  String packageImg;

  factory ShopPackageResponse.fromJson(Map<String, dynamic> json) => ShopPackageResponse(
    result: json["result"],
    id: json["id"],
    packageName: json["package_name"],
    packageImg: json["package_img"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "id": id,
    "package_name": packageName,
    "package_img": packageImg,
  };
}
