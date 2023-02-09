import 'dart:convert';

import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/common_response.dart';
import 'package:active_ecommerce_seller_app/data_model/coupon_create_response.dart';
import 'package:active_ecommerce_seller_app/data_model/coupon_list_response.dart';
import 'package:active_ecommerce_seller_app/data_model/edit_coupon_response.dart';
import 'package:active_ecommerce_seller_app/data_model/product_for_coupon_response.dart';
import 'package:active_ecommerce_seller_app/data_model/products_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:http/http.dart'as http;


class CouponRepository{


  Future<CouponListResponse> getCoupons() async {

    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/coupon/all");

    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await http.get(url, headers:header );
    print("create coupon res "+response.body);
    return couponListResponseFromJson(response.body);
  }


  Future<CouponCreateResponse> createCoupon(var post_body) async {

    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/coupon/create");

    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    print("create coupon body "+post_body);

    final response = await http.post(url, headers:header,body: post_body );

    print("create coupon res "+response.body);

    return couponCreateResponseFromJson(response.body);

  }

  Future<EditCouponResponse> editCoupon(String id) async {

    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/coupon/edit/$id");

    Map<String,String> header=  {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await http.get(url, headers:header);

    print("edit coupon"+response.body.toString());

    return editCouponResponseFromJson(response.body);
  }

  Future<CouponCreateResponse> updateCoupon(var post_body,String id) async {

    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/coupon/update/$id");

    Map<String,String> header={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    print("update coupon body "+post_body);
    print("update coupon url "+url.toString());

    final response = await http.post(url, headers:header,body: post_body );

    print("update coupon res "+response.body);

    return couponCreateResponseFromJson(response.body);
  }

  Future<CommonResponse> deleteCoupon(String id) async {

    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/coupon/delete/$id");

    Map<String,String> header=  {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await http.get(url, headers:header);


    return commonResponseFromJson(response.body);
  }

  Future<ProductForCouponResponse> searchProducts(String name)async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/coupon/for-product?coupon_type=product_base&name=$name");
    var reqHeader={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type":"application/json"
    };

    final response = await http.get(url, headers:reqHeader
    );
    print("product res  "+response.body.toString());
    return productForCouponResponseFromJson(response.body);
  }





}