import 'dart:convert';

import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/common_response.dart';
import 'package:active_ecommerce_seller_app/data_model/order_detail_response.dart';
import 'package:active_ecommerce_seller_app/data_model/order_mini_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class OrderRepository {
  Future<OrderListResponse> getOrderList(
      {page = 1, payment_status = "", delivery_status = ""}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/orders" +
        "?page=${page}&payment_status=${payment_status}&delivery_status=${delivery_status}");

    print("get order list url "+url.toString());

    final response = await http.get(url, headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
    });
    return orderListResponseFromJson(response.body);
  }

  Future<OrderDetailResponse> getOrderDetails({@required int id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL_WITH_PREFIX}/orders/details/" + id.toString());
    print("details url:" + url.toString());
    final response = await http.get(url, headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
    });
    //print("url:" +url.toString());
    print("order details " + response.body);
    return orderDetailResponseFromJson(response.body);
  }

 Future<CommonResponse> updateDeliveryStatus({@required int id = 0, @required String status,String paymentType=""}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/orders/update-delivery-status");

    var post_body = jsonEncode({"order_id": "$id", "status": "$status","payment_type":paymentType});
    print(post_body);

    final response = await http.post(url, body: post_body, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
    });
    print("update result" + response.body);

    return commonResponseFromJson(response.body);
  }



  Future<CommonResponse>  updatePaymentStatus({@required int id = 0, @required String status}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/orders/update-payment-status");

    var post_body = jsonEncode({"order_id": "$id", "status": "$status"});

    final response = await http.post(url, body: post_body, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
    });
    print("update result" + response.body);

    return commonResponseFromJson(response.body);
  }
}
