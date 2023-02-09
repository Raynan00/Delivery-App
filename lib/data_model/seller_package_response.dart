// To parse this JSON data, do
//
//     final sellerPackageResponse = sellerPackageResponseFromJson(jsonString);

import 'dart:convert';

SellerPackageResponse sellerPackageResponseFromJson(String str) => SellerPackageResponse.fromJson(json.decode(str));

String sellerPackageResponseToJson(SellerPackageResponse data) => json.encode(data.toJson());

class SellerPackageResponse {
  SellerPackageResponse({
    this.data,
  });

  List<Package> data;

  factory SellerPackageResponse.fromJson(Map<String, dynamic> json) => SellerPackageResponse(
    data: List<Package>.from(json["data"].map((x) => Package.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Package {
  Package({
    this.id,
    this.name,
    this.logo,
    this.productUploadLimit,
    this.amount,
    this.price,
    this.duration,
  });

  int id;
  String name;
  String logo;
  int productUploadLimit;
  String amount;
  var price;
  int duration;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
    productUploadLimit: json["product_upload_limit"],
    amount: json["amount"],
    price: json["price"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo": logo,
    "product_upload_limit": productUploadLimit,
    "amount": amount,
    "price": price,
    "duration": duration,
  };
}
