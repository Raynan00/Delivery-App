// To parse this JSON ShopInfo, do
//
//     final shopInfoResponse = shopInfoResponseFromJson(jsonString);

import 'dart:convert';

ShopInfoResponse shopInfoResponseFromJson(String str) => ShopInfoResponse.fromJson(json.decode(str));

String shopInfoResponseToJson(ShopInfoResponse ShopInfo) => json.encode(ShopInfo.toJson());

class ShopInfoResponse {
  ShopInfoResponse({
    this.shopInfo,
    this.success,
    this.status,
  });

  ShopInfo shopInfo;
  bool success;
  var status;

  factory ShopInfoResponse.fromJson(Map<String, dynamic> json) => ShopInfoResponse(
    shopInfo: ShopInfo.fromJson(json["data"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": shopInfo.toJson(),
    "success": success,
    "status": status,
  };
}

class ShopInfo {
  ShopInfo({
    this.id,
    this.userId,
    this.name,
    this.title,
    this.description,
    this.deliveryPickupLatitude,
    this.deliveryPickupLongitude,
    this.logo,
    this.packageInvalidAt,
    this.productUploadLimit,
    this.sellerPackage,
    this.sellerPackageImg,
    this.uploadId,
    this.sliders,
    this.slidersId,
    this.address,
    this.adminToPay,
    this.phone,
    this.facebook,
    this.google,
    this.twitter,
    this.instagram,
    this.youtube,
    this.cashOnDeliveryStatus,
    this.bank_payment_status,
    this.bankName,
    this.bankAccName,
    this.bankAccNo,
    this.bankRoutingNo,
    this.rating,
    this.verified,
    this.verifiedImg,
    this.verifyText,
    this.email,
    this.products,
    this.orders,
    this.sales,
  });

  var id;
  var userId;
  String name;
  String title;
  String description;
  dynamic deliveryPickupLatitude;
  dynamic deliveryPickupLongitude;
  String logo;
  String packageInvalidAt;
  var productUploadLimit;
  String sellerPackage;
  String sellerPackageImg;
  String uploadId;
  List<String> sliders;
  dynamic slidersId;
  String address;
  var adminToPay;
  String phone;
  String facebook;
  String google;
  String twitter;
  dynamic instagram;
  String youtube;
  var cashOnDeliveryStatus;
  var bank_payment_status;
  String bankName;
  String bankAccName;
  String bankAccNo;
  var bankRoutingNo;
  double rating;
  bool verified;
  String verifiedImg;
  String verifyText;
  String email;
  var products;
  var orders;
  String sales;

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    title: json["title"],
    description: json["description"],
    deliveryPickupLatitude: json["delivery_pickup_latitude"]??"",
    deliveryPickupLongitude: json["delivery_pickup_longitude"]??"",
    logo: json["logo"],
    packageInvalidAt: json["package_invalid_at"],
    productUploadLimit: json["product_upload_limit"],
    sellerPackage: json["seller_package"],
    sellerPackageImg: json["seller_package_img"],
    uploadId: json["upload_id"],
    sliders: List<String>.from(json["sliders"].map((x) => x)),
    slidersId: json["sliders_id"],
    address: json["address"],
    adminToPay: json["admin_to_pay"],
    phone: json["phone"],
    facebook: json["facebook"],
    google: json["google"],
    twitter: json["twitter"],
    instagram: json["instagram"],
    youtube: json["youtube"],
    cashOnDeliveryStatus: json["cash_on_delivery_status"],
    bank_payment_status: json["bank_payment_status"],
    bankName: json["bank_name"],
    bankAccName: json["bank_acc_name"],
    bankAccNo: json["bank_acc_no"],
    bankRoutingNo: json["bank_routing_no"]??"",
    rating: json["rating"].toDouble(),
    verified: json["verified"],
    verifiedImg: json["verified_img"],
    verifyText: json["verify_text"],
    email: json["email"],
    products: json["products"],
    orders: json["orders"],
    sales: json["sales"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "title": title,
    "description": description,
    "delivery_pickup_latitude": deliveryPickupLatitude,
    "delivery_pickup_longitude": deliveryPickupLongitude,
    "logo": logo,
    "package_invalid_at": packageInvalidAt,
    "product_upload_limit": productUploadLimit,
    "seller_package": sellerPackage,
    "seller_package_img": sellerPackageImg,
    "upload_id": uploadId,
    "sliders": List<dynamic>.from(sliders.map((x) => x)),
    "sliders_id": slidersId,
    "address": address,
    "admin_to_pay": adminToPay,
    "phone": phone,
    "facebook": facebook,
    "google": google,
    "twitter": twitter,
    "instagram": instagram,
    "youtube": youtube,
    "cash_on_delivery_status": cashOnDeliveryStatus,
    "bank_payment_status": bank_payment_status,
    "bank_name": bankName,
    "bank_acc_name": bankAccName,
    "bank_acc_no": bankAccNo,
    "bank_routing_no": bankRoutingNo,
    "rating": rating,
    "verified": verified,
    "verified_img": verifiedImg,
    "verify_text": verifyText,
    "email": email,
    "products": products,
    "orders": orders,
    "sales": sales,
  };
}
