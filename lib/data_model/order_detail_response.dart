// To parse this JSON data, do
//
//     final orderDetailResponse = orderDetailResponseFromJson(jsonString);

import 'dart:convert';

OrderDetailResponse orderDetailResponseFromJson(String str) => OrderDetailResponse.fromJson(json.decode(str));

String orderDetailResponseToJson(OrderDetailResponse data) => json.encode(data.toJson());

class OrderDetailResponse {
  OrderDetailResponse({
    this.data,
  });

  List<DetailedOrder> data;

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) => OrderDetailResponse(
    data: List<DetailedOrder>.from(json["data"].map((x) => DetailedOrder.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DetailedOrder {
  DetailedOrder({
    this.orderCode,
    this.total,
    this.orderDate,
    this.paymentStatus,
    this.paymentType,
    this.deliveryStatus,
    this.shippingType,
    this.paymentMethod,
    this.shippingAddress,
    this.shippingCost,
    this.subtotal,
    this.couponDiscount,
    this.tax,
    this.orderItems,
  });

  String orderCode;
  String total;
  String orderDate;
  String paymentStatus;
  String paymentType;
  String deliveryStatus;
  String shippingType;
  String paymentMethod;
  ShippingAddress shippingAddress;
  String shippingCost;
  String subtotal;
  String couponDiscount;
  String tax;
  List<OrderItem> orderItems;

  factory DetailedOrder.fromJson(Map<String, dynamic> json) => DetailedOrder(
    orderCode: json["order_code"],
    total: json["total"],
    orderDate: json["order_date"],
    paymentStatus: json["payment_status"],
    paymentType: json["payment_type"],
    deliveryStatus: json["delivery_status"],
    shippingType: json["shipping_type"],
    paymentMethod: json["payment_method"],
    shippingAddress: ShippingAddress.fromJson(json["shipping_address"]),
    shippingCost: json["shipping_cost"],
    subtotal: json["subtotal"],
    couponDiscount: json["coupon_discount"],
    tax: json["tax"],
    orderItems: List<OrderItem>.from(json["order_items"].map((x) => OrderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "order_code": orderCode,
    "total": total,
    "order_date": orderDate,
    "payment_status": paymentStatus,
    "payment_type": paymentType,
    "delivery_status": deliveryStatus,
    "shipping_type": shippingType,
    "payment_method": paymentMethod,
    "shipping_address": shippingAddress.toJson(),
    "shipping_cost": shippingCost,
    "subtotal": subtotal,
    "coupon_discount": couponDiscount,
    "tax": tax,
    "order_items": List<dynamic>.from(orderItems.map((x) => x.toJson())),
  };
}

class OrderItem {
  OrderItem({
    this.name,
    this.description,
    this.price,
    this.deliveryStatus
  });

  var name;
  var description;
  String price;
  String deliveryStatus;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    name: json["name"]??"",
    description: json["description"],
    price: json["price"],
    deliveryStatus: json["delivery_status"]
  );

  Map<String, dynamic> toJson() => {
    "name": name??"",
    "description": description,
    "price": price,
    "delivery_status": deliveryStatus,
  };
}

class ShippingAddress {
  ShippingAddress({
    this.name,
    this.email,
    this.address,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.phone,
  });

  String name;
  dynamic email;
  String address;
  String country;
  String state;
  String city;
  String postalCode;
  String phone;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    name: json["name"],
    email: json["email"],
    address: json["address"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    postalCode: json["postal_code"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "address": address,
    "country": country,
    "state": state,
    "city": city,
    "postal_code": postalCode,
    "phone": phone,
  };
}
