// To parse this JSON data, do
//
//     final sellerProfileResponse = sellerProfileResponseFromJson(jsonString);

import 'dart:convert';

SellerProfileResponse sellerProfileResponseFromJson(String str) => SellerProfileResponse.fromJson(json.decode(str));

String sellerProfileResponseToJson(SellerProfileResponse data) => json.encode(data.toJson());

class SellerProfileResponse {
  SellerProfileResponse({
    this.result,
    this.id,
    this.type,
    this.name,
    this.email,
    this.avatar,
    this.avatarOriginal,
    this.phone,
  });

  bool result;
  int id;
  String type;
  String name;
  String email;
  String avatar;
  String avatarOriginal;
  dynamic phone;

  factory SellerProfileResponse.fromJson(Map<String, dynamic> json) => SellerProfileResponse(
    result: json["result"],
    id: json["id"],
    type: json["type"],
    name: json["name"],
    email: json["email"],
    avatar: json["avatar"],
    avatarOriginal: json["avatar_original"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "id": id,
    "type": type,
    "name": name,
    "email": email,
    "avatar": avatar,
    "avatar_original": avatarOriginal,
    "phone": phone,
  };
}
