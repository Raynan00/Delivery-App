import 'dart:convert';

import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/chat_list_response.dart';
import 'package:active_ecommerce_seller_app/data_model/common_response.dart';
import 'package:active_ecommerce_seller_app/data_model/messages_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ChatRepository {
  Future<ChatListResponse> getChatList() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/conversations");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "App-Language": app_language.$,
        "Authorization": "Bearer ${access_token.$}",
      },
    );

    print("chat list "+response.body.toString());

    return chatListResponseFromJson(response.body);
  }

  Future<MessageResponse> getMessages(id) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/conversations/show/$id");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "App-Language": app_language.$,
        "Authorization": "Bearer ${access_token.$}",
      },
    );

    print("chat list "+response.body.toString());

    return messageResponseFromJson(response.body);
  }

    Future<CommonResponse> sendMessages(@required id,@required message) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL_WITH_PREFIX}/conversations/message/store");

    var post_body = jsonEncode({
        "conversation_id":id,
        "message":message
    });
    print(post_body);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "App-Language": app_language.$,
        "Authorization": "Bearer ${access_token.$}",
      },
      body: post_body
    );

    print("chat list "+response.body.toString());

    return commonResponseFromJson(response.body);
  }





}
