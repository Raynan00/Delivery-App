// To parse this JSON data, do
//
//     final ProductStatusChange = ProductStatusChangeFromJson(jsonString);

import 'dart:convert';

ProductStatusChange ProductStatusChangeFromJson(String str) => ProductStatusChange.fromJson(json.decode(str));

String ProductStatusChangeToJson(ProductStatusChange data) => json.encode(data.toJson());

class ProductStatusChange {
  ProductStatusChange({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory ProductStatusChange.fromJson(Map<String, dynamic> json) => ProductStatusChange(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
