// To parse this JSON data, do
//
//     final shopResponse = shopResponseFromJson(jsonString);
/*
import 'dart:convert';

ShopResponse shopResponseFromJson(String str) => ShopResponse.fromJson(json.decode(str));

String shopResponseToJson(ShopResponse data) => json.encode(data.toJson());
/*
class ShopResponse {
  ShopResponse({
    this.id,
    this.userId,
    this.name,
    this.logo,
    this.sliders,
    this.phone,
    this.address,
    this.rating,
    this.numOfReviews,
    this.numOfSale,
    this.sellerPackageId,
    this.productUploadLimit,
    this.packageInvalidAt,
    this.verificationStatus,
    this.verificationInfo,
    this.cashOnDeliveryStatus,
    this.adminToPay,
    this.facebook,
    this.google,
    this.twitter,
    this.youtube,
    this.slug,
    this.metaTitle,
    this.metaDescription,
    this.pickUpPointId,
    this.shippingCost,
    this.deliveryPickupLatitude,
    this.deliveryPickupLongitude,
    this.bankName,
    this.bankAccName,
    this.bankAccNo,
    this.bankRoutingNo,
    this.bankPaymentStatus,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int id;
  int userId;
  String name;
  dynamic logo;
  dynamic sliders;
  dynamic phone;
  String address;
  double rating;
  var numOfReviews;
  var numOfSale;
  dynamic sellerPackageId;
  var productUploadLimit;
  dynamic packageInvalidAt;
  var verificationStatus;
  String verificationInfo;
  var cashOnDeliveryStatus;
  double adminToPay;
  String facebook;
  String google;
  String twitter;
  String youtube;
  String slug;
  String metaTitle;
  String metaDescription;
  dynamic pickUpPointId;
  var shippingCost;
  dynamic deliveryPickupLatitude;
  dynamic deliveryPickupLongitude;
  dynamic bankName;
  dynamic bankAccName;
  dynamic bankAccNo;
  dynamic bankRoutingNo;
  var bankPaymentStatus;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  factory ShopResponse.fromJson(Map<String, dynamic> json) => ShopResponse(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    logo: json["logo"],
    sliders: json["sliders"],
    phone: json["phone"],
    address: json["address"],
    rating: double.parse(json["rating"].toString()),
    numOfReviews: json["num_of_reviews"],
    numOfSale: json["num_of_sale"],
    sellerPackageId: json["seller_package_id"],
    productUploadLimit: json["product_upload_limit"],
    packageInvalidAt: json["package_invalid_at"],
    verificationStatus: json["verification_status"],
    verificationInfo: json["verification_info"],
    cashOnDeliveryStatus: json["cash_on_delivery_status"],
    adminToPay: json["admin_to_pay"].toDouble(),
    facebook: json["facebook"],
    google: json["google"],
    twitter: json["twitter"],
    youtube: json["youtube"],
    slug: json["slug"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
    pickUpPointId: json["pick_up_point_id"],
    shippingCost: json["shipping_cost"],
    deliveryPickupLatitude: json["delivery_pickup_latitude"],
    deliveryPickupLongitude: json["delivery_pickup_longitude"],
    bankName: json["bank_name"],
    bankAccName: json["bank_acc_name"],
    bankAccNo: json["bank_acc_no"],
    bankRoutingNo: json["bank_routing_no"],
    bankPaymentStatus: json["bank_payment_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "logo": logo,
    "sliders": sliders,
    "phone": phone,
    "address": address,
    "rating": rating,
    "num_of_reviews": numOfReviews,
    "num_of_sale": numOfSale,
    "seller_package_id": sellerPackageId,
    "product_upload_limit": productUploadLimit,
    "package_invalid_at": packageInvalidAt,
    "verification_status": verificationStatus,
    "verification_info": verificationInfo,
    "cash_on_delivery_status": cashOnDeliveryStatus,
    "admin_to_pay": adminToPay,
    "facebook": facebook,
    "google": google,
    "twitter": twitter,
    "youtube": youtube,
    "slug": slug,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "pick_up_point_id": pickUpPointId,
    "shipping_cost": shippingCost,
    "delivery_pickup_latitude": deliveryPickupLatitude,
    "delivery_pickup_longitude": deliveryPickupLongitude,
    "bank_name": bankName,
    "bank_acc_name": bankAccName,
    "bank_acc_no": bankAccNo,
    "bank_routing_no": bankRoutingNo,
    "bank_payment_status": bankPaymentStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user": user.toJson(),
  };
}*/

class User {
  User({
    this.id,
    this.referredBy,
    this.providerId,
    this.userType,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.verificationCode,
    this.newEmailVerificiationCode,
    this.deviceToken,
    this.avatar,
    this.avatarOriginal,
    this.address,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.phone,
    this.balance,
    this.banned,
    this.referralCode,
    this.customerPackageId,
    this.remainingUploads,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  dynamic referredBy;
  dynamic providerId;
  String userType;
  String name;
  String email;
  DateTime emailVerifiedAt;
  dynamic verificationCode;
  dynamic newEmailVerificiationCode;
  String deviceToken;
  String avatar;
  dynamic avatarOriginal;
  String address;
  String country;
  dynamic state;
  String city;
  String postalCode;
  dynamic phone;
  int balance;
  int banned;
  String referralCode;
  dynamic customerPackageId;
  dynamic remainingUploads;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    referredBy: json["referred_by"],
    providerId: json["provider_id"],
    userType: json["user_type"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
    verificationCode: json["verification_code"],
    newEmailVerificiationCode: json["new_email_verificiation_code"],
    deviceToken: json["device_token"],
    avatar: json["avatar"],
    avatarOriginal: json["avatar_original"],
    address: json["address"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    postalCode: json["postal_code"],
    phone: json["phone"],
    balance: json["balance"],
    banned: json["banned"],
    referralCode: json["referral_code"],
    customerPackageId: json["customer_package_id"],
    remainingUploads: json["remaining_uploads"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "referred_by": referredBy,
    "provider_id": providerId,
    "user_type": userType,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt.toIso8601String(),
    "verification_code": verificationCode,
    "new_email_verificiation_code": newEmailVerificiationCode,
    "device_token": deviceToken,
    "avatar": avatar,
    "avatar_original": avatarOriginal,
    "address": address,
    "country": country,
    "state": state,
    "city": city,
    "postal_code": postalCode,
    "phone": phone,
    "balance": balance,
    "banned": banned,
    "referral_code": referralCode,
    "customer_package_id": customerPackageId,
    "remaining_uploads": remainingUploads,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}*/
