


import 'dart:convert';

import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/RefundOrderResponse.dart';
import 'package:active_ecommerce_seller_app/data_model/common_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class RefundOrderRepository{

  Future<RefundOrderResponse> getRefundOrderList({int page = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/refunds?page=${page}");

    print("product url "+url.toString());
    print("user token "+access_token.$);

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    print("product res  "+response.body.toString());

    return refundOrderResponseFromJson(response.body);
  }


  Future<CommonResponse> approveRefundSellerStatusRequest(id) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/refunds/approve");

    var post_body = jsonEncode({
      "refund_id":id
    });
    print("refund id ${id}");
    var header = {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
    };
    final response = await http.post(url, headers: header,body: post_body);

    print("product res  "+response.body.toString());

    return commonResponseFromJson(response.body);
  }

    Future<CommonResponse> rejectRefundSellerStatusRequest(id,message) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/refunds/reject");

    var post_body = jsonEncode({
      "refund_id":id,
      "reject_reason": message
    });
    var header = {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",

      };
    final response = await http.post(url,headers: header,body: post_body);

    print("product res  "+response.body.toString());

    return commonResponseFromJson(response.body);
  }


}