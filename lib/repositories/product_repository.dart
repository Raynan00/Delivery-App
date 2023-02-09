
import 'dart:convert';

import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/category_response.dart';
import 'package:active_ecommerce_seller_app/data_model/product_delete_response.dart';
import 'package:active_ecommerce_seller_app/data_model/product_duplicate_response.dart';
import 'package:active_ecommerce_seller_app/data_model/product_for_coupon_response.dart';
import 'package:active_ecommerce_seller_app/data_model/product_review_response.dart';
import 'package:active_ecommerce_seller_app/data_model/products_response.dart';
import 'package:active_ecommerce_seller_app/data_model/remainig_product_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductRepository{

  Future<ProductsResponse> getProducts(
      { name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/products/all"
        "?page=${page}&name=${name}");

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    print("product res  "+response.body.toString());
    return productsResponseFromJson(response.body);
  }




/*
    Future<ProductsResponse> duplicateProduct({@required id}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/products/all"
        "?page=${page}&name=${name}");

print("product url "+url.toString());
print("user token "+access_token.$);

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    print("product res  "+response.body.toString());
    return productsResponseFromJson(response.body);
  }
*/


  productDuplicateReq({@required id})async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/product/duplicate/$id");


    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    print("product res  "+response.body.toString());
    return productDuplicateResponseFromJson(response.body);
  }

  productDeleteReq({@required id})async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/product/delete/$id");

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    print("product res  "+response.body.toString());
    return deleteProductFromJson(response.body);
  }

  productStatusChangeReq({@required id,status})async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/product/change-status");

    var post_body = jsonEncode({
      "id": id,
      "status":status
    });
    var reqHeader={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type":"application/json"
    };

    final response = await http.post(url, headers:reqHeader ,body: post_body
    );


    print("product res  "+response.body.toString());
    return deleteProductFromJson(response.body);
  }

  productFeaturedChangeReq({@required id,@required featured})async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/product/change-featured");

    var post_body = jsonEncode({
      "id": id,
      "featured_status":featured
    });
    var reqHeader={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type":"application/json"
    };

    final response = await http.post(url, headers:reqHeader ,body: post_body
    );


    print("product res  "+response.body.toString());
    return deleteProductFromJson(response.body);
  }

  remainingUploadProducts()async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/products/remaining-uploads");


    var reqHeader={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type":"application/json"
    };

    final response = await http.get(url, headers:reqHeader
    );
    print("product res  "+response.body.toString());
    return remainingProductFromJson(response.body);
  }


 Future<ProductReviewResponse> getProductReviewsReq()async{
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/products/reviews");


    var reqHeader={
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type":"application/json"
    };

    final response = await http.get(url, headers:reqHeader
    );
    print("product res  "+response.body.toString());
    return productReviewResponseFromJson(response.body);
  }



}