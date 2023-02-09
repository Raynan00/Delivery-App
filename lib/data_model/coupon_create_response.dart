// To parse this JSON data, do
//
//     final couponCreateResponse = couponCreateResponseFromJson(jsonString);

import 'dart:convert';

CouponCreateResponse couponCreateResponseFromJson(String str) => CouponCreateResponse.fromJson(json.decode(str));

String couponCreateResponseToJson(CouponCreateResponse data) => json.encode(data.toJson());

class CouponCreateResponse {
  CouponCreateResponse({
    this.result,
    this.message,
  });

  bool result;
  var message;

  factory CouponCreateResponse.fromJson(Map<String, dynamic> json) => CouponCreateResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
