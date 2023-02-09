import 'package:active_ecommerce_seller_app/data_model/uploaded_file_list_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/profile_image_update_response.dart';
import 'package:flutter/material.dart';

class FileUploadRepository{

  Future<ProfileImageUpdateResponse> imageUpload(
      @required String image,@required String filename) async {

    var post_body = jsonEncode({"image": "${image}", "filename": "$filename"});
    //print(post_body.toString());

    Uri url = Uri.parse("${AppConfig.BASE_URL}/file/image-upload");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,},body: post_body );
    print("upload image response"+response.body.toString());
    //print(response.body.toString());
    return profileImageUpdateResponseFromJson(response.body);
  }

    Future<UploadedFilesListResponse> getFiles() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/file-all");
    final response = await http.get(url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,});


    return uploadedFilesListResponseFromJson(response.body);
  }



}