// To parse this JSON data, do
//
//     final deleteProduct = deleteProductFromJson(jsonString);

import 'dart:convert';

DeleteProduct deleteProductFromJson(String str) => DeleteProduct.fromJson(json.decode(str));

String deleteProductToJson(DeleteProduct data) => json.encode(data.toJson());

class DeleteProduct {
  DeleteProduct({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory DeleteProduct.fromJson(Map<String, dynamic> json) => DeleteProduct(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
