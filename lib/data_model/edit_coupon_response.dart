// To parse this JSON data, do
//
//     final editCouponResponse = editCouponResponseFromJson(jsonString);

import 'dart:convert';

EditCouponResponse editCouponResponseFromJson(String str) => EditCouponResponse.fromJson(json.decode(str));

String editCouponResponseToJson(EditCouponResponse data) => json.encode(data.toJson());

class EditCouponResponse {
  EditCouponResponse({
    this.data,
  });

  Data data;

  factory EditCouponResponse.fromJson(Map<String, dynamic> json) => EditCouponResponse(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.type,
    this.code,
    this.details,
    this.discount,
    this.discountType,
    this.startDate,
    this.endDate,
  });

  int id;
  String type;
  String code;
  String details;
  int discount;
  String discountType;
  String startDate;
  String endDate;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    type: json["type"],
    code: json["code"],
    details: json["details"],
    discount: json["discount"],
    discountType: json["discount_type"],
    startDate: json["start_date"],
    endDate: json["end_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "code": code,
    "details": details,
    "discount": discount,
    "discount_type": discountType,
    "start_date": startDate,
    "end_date": endDate,
  };
}
