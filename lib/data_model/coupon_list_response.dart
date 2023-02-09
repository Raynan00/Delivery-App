// To parse this JSON data, do
//
//     final couponListResponse = couponListResponseFromJson(jsonString);

import 'dart:convert';

CouponListResponse couponListResponseFromJson(String str) => CouponListResponse.fromJson(json.decode(str));

String couponListResponseToJson(CouponListResponse data) => json.encode(data.toJson());

class CouponListResponse {
  CouponListResponse({
    this.data,
  });

  List<Coupon> data;

  factory CouponListResponse.fromJson(Map<String, dynamic> json) => CouponListResponse(
    data: List<Coupon>.from(json["data"].map((x) => Coupon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Coupon {
  Coupon({
    this.id,
    this.type,
    this.code,
    this.discount,
    this.discountType,
    this.startDate,
    this.endDate,
  });

  int id;
  String type;
  String code;
  var discount;
  String discountType;
  String startDate;
  String endDate;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json["id"],
    type: json["type"],
    code: json["code"],
    discount: json["discount"],
    discountType: json["discount_type"],
    startDate: json["start_date"],
    endDate: json["end_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "code": code,
    "discount": discount,
    "discount_type": discountType,
    "start_date": startDate,
    "end_date": endDate,
  };
}
