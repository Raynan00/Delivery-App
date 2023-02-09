import 'dart:convert';

RemainingProduct remainingProductFromJson(String str) => RemainingProduct.fromJson(json.decode(str));

String remainingProductToJson(RemainingProduct data) => json.encode(data.toJson());

class RemainingProduct {
  RemainingProduct({
    this.ramainingProduct,
  });

  var ramainingProduct;

  factory RemainingProduct.fromJson(Map<String, dynamic> json) => RemainingProduct(
    ramainingProduct: json["ramaining_product"],
  );

  Map<String, dynamic> toJson() => {
    "ramaining_product": ramainingProduct,
  };
}