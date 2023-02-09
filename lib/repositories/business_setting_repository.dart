
import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/business_setting_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BusinessSettingRepository{
  Future<List<BusinessSettingListResponse>> getBusinessSettingList()async{
    Uri url = Uri.parse("${AppConfig.BASE_URL}/business-settings");

   var businessSettings = [
     "conversation_system",
     "coupon_system",
     "product_manage_by_admin"
    ];
  String params= businessSettings.join(',');
    var body = {
      //'keys':params
      "keys":params
    };
    print("business ${body}");
    var response = await http.post(url,body: body);

    print("business ${response.body}");

    return businessSettingListResponseFromJson(response.body);
  }
}