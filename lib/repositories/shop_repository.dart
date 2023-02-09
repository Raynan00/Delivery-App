import 'dart:convert';

import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/category_wise_product_response.dart';
import 'package:active_ecommerce_seller_app/data_model/chart_response.dart';
import 'package:active_ecommerce_seller_app/data_model/common_response.dart';
import 'package:active_ecommerce_seller_app/data_model/shop_info_response.dart';
import 'package:active_ecommerce_seller_app/data_model/seller_package_response.dart';
import 'package:active_ecommerce_seller_app/data_model/shop_package_response.dart';
import 'package:active_ecommerce_seller_app/data_model/shop_response.dart';
import 'package:active_ecommerce_seller_app/data_model/top_12_product_response.dart';
import 'package:active_ecommerce_seller_app/dummy_data/categori_wise_product.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class ShopRepository{

/*
  Future<ShopResponse> getShopProfile()async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/shop/profile");

    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    };

    final response = await http.get(url, headers:header );
    print("withdraw list "+response.body);
    return shopResponseFromJson(response.body);
  }*/

 Future<Top12ProductResponse> getTop12ProductRequest()async{
   Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/dashboard/top-12-product");

   Map<String,String> header={
     "App-Language": app_language.$,
     "Authorization": "Bearer ${access_token.$}",
   };
   final response = await http.get(url, headers:header );
   return top12ProductResponseFromJson(response.body);
  }

 Future<List<ChartResponse>> chartRequest()async{
   Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/dashboard/sales-stat");

   Map<String,String> header={
     "App-Language": app_language.$,
     "Authorization": "Bearer ${access_token.$}",
   };
   final response = await http.get(url, headers:header );

   print("chartRequest res"+ response.body.toString());
   return chartResponseFromJson(response.body);
  }


  Future<SellerPackageResponse> getSellerPackageRequest()async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/seller-packages-list");

    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    };

    print("package url "+ url.toString());

    final response = await http.get(url, headers:header );

    print("package res body "+ response.body.toString());

    return sellerPackageResponseFromJson(response.body);
  }


  Future<CommonResponse> purchaseFreePackageRequest(packageId)async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/seller-purchase-package");

    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
    };

    var post_data= jsonEncode({
      "package_id":packageId,
      "payment_option":"No Method",
      "amount":0
    });

    print("package url "+ url.toString());

    final response = await http.post(url, headers:header ,body: post_data);

    print("package res body "+ response.body.toString());

    return commonResponseFromJson(response.body);
  }



  Future<List<CategoryWiseProductResponse>> getCategoryWiseProductRequest()async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/dashboard/category-wise-products");
    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await http.get(url, headers:header );
    return categoryWiseProductResponseFromJson(response.body);
  }

  Future<ShopInfoResponse> getShopInfo()async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/shop/info");
    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await http.get(url, headers:header );
    print("shop info "+response.body.toString());
    return shopInfoResponseFromJson(response.body);
  }

  Future<ShopPackageResponse> getShopPackage()async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/package/info");
    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await http.get(url, headers:header );
    print("shop info "+response.body.toString());
    return shopPackageResponseFromJson(response.body);
  }

  Future<CommonResponse> updateShopSetting(var post_body)async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/shop-update");
    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    print("updateShopSetting body"+post_body.toString());

    final response = await http.post(url, headers:header,body: post_body);

    print("shop info "+response.body.toString());
    return commonResponseFromJson(response.body);
  }




}