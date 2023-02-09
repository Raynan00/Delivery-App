

import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/commission_history_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:http/http.dart'as http;

class CommissionRepository{

 Future<CommissionHistoryResponse> getList({int page =1})async{

    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/commission-list?page=$page");

    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await http.get(url, headers:header );
    print("create coupon res "+response.body);
    return commissionHistoryResponseFromJson(response.body);

  }

}