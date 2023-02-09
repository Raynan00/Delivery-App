// To parse this JSON data, do
//
//     final productDuplicateResponse = productDuplicateResponseFromJson(jsonString);

import 'dart:convert';

ProductDuplicateResponse productDuplicateResponseFromJson(String str) => ProductDuplicateResponse.fromJson(json.decode(str));

String productDuplicateResponseToJson(ProductDuplicateResponse data) => json.encode(data.toJson());

class ProductDuplicateResponse {
  ProductDuplicateResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory ProductDuplicateResponse.fromJson(Map<String, dynamic> json) => ProductDuplicateResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
