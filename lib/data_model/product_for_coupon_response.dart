// To parse this JSON data, do
//
//     final productForCouponResponse = productForCouponResponseFromJson(jsonString);

import 'dart:convert';

ProductForCouponResponse productForCouponResponseFromJson(String str) => ProductForCouponResponse.fromJson(json.decode(str));

String productForCouponResponseToJson(ProductForCouponResponse data) => json.encode(data.toJson());

class ProductForCouponResponse {
  ProductForCouponResponse({
    this.data,
  });

  List<CouponProduct> data;

  factory ProductForCouponResponse.fromJson(Map<String, dynamic> json) => ProductForCouponResponse(
    data: List<CouponProduct>.from(json["data"].map((x) => CouponProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CouponProduct {
  CouponProduct({
    this.id,
    this.name,
    this.thumbnailImg,
    this.price,
    this.currentStock,
    this.status,
    this.category,
    this.featured,
  });

  int id;
  String name;
  String thumbnailImg;
  String price;
  var currentStock;
  bool status;
  String category;
  bool featured;

  factory CouponProduct.fromJson(Map<String, dynamic> json) => CouponProduct(
    id: json["id"],
    name: json["name"],
    thumbnailImg: json["thumbnail_img"],
    price: json["price"],
    currentStock: json["current_stock"],
    status: json["status"],
    category: json["category"],
    featured: json["featured"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "thumbnail_img": thumbnailImg,
    "price": price,
    "current_stock": currentStock,
    "status": status,
    "category": category,
    "featured": featured,
  };
}
