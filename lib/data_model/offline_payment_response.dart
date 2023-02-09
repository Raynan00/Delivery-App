// To parse this JSON data, do
//
//     final offlineWalletRechargeResponse = offlineWalletRechargeResponseFromJson(jsonString);

import 'dart:convert';

OfflinePaymentResponse offlinePaymentResponseFromJson(String str) => OfflinePaymentResponse.fromJson(json.decode(str));

String offlinePaymentResponseToJson(OfflinePaymentResponse data) => json.encode(data.toJson());

class OfflinePaymentResponse {
  OfflinePaymentResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory OfflinePaymentResponse.fromJson(Map<String, dynamic> json) => OfflinePaymentResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
