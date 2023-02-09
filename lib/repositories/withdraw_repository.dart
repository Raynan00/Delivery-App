import 'dart:convert';

import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/common_response.dart';
import 'package:active_ecommerce_seller_app/data_model/withdraw_list_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class WithdrawRepository{

 Future<WithdrawListResponse> getList(int page)async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/withdraw-request?page=$page");

    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await http.get(url, headers:header );
    print("withdraw list "+response.body);
    return withdrawListResponseFromJson(response.body);

  }

 Future<CommonResponse> sendWithdrawReq(String message,String amount)async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/withdraw-request/store");

    var post_body = jsonEncode({"amount": "$amount", "message": "$message"});

    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
    };

    final response = await http.post(url, headers:header ,body: post_body);
    print("withdraw list "+response.body);
    return commonResponseFromJson(response.body);

  }


}