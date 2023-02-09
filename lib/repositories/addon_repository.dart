

import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/addon_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class AddonRepository{

Future<List<AddonResponse>>  getAddonList()async{
  Uri url = Uri.parse("${AppConfig.BASE_URL}/addon-list");

  var reqHeader={
    "App-Language": app_language.$,
    "Authorization": "Bearer ${access_token.$}",
    "Content-Type":"application/json"
  };
  print("getAddonList url  "+url.toString());
  final response = await http.get(url, headers:reqHeader
  );
  print("getAddonList res  "+response.body.toString());
  return addonResponseFromJson(response.body);
  }

}