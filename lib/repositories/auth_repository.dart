import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/login_response.dart';
import 'package:active_ecommerce_seller_app/data_model/logout_response.dart';
import 'package:active_ecommerce_seller_app/data_model/password_confirm_response.dart';
import 'package:active_ecommerce_seller_app/data_model/password_forget_response.dart';
import 'package:active_ecommerce_seller_app/data_model/resend_code_response.dart';
import 'package:active_ecommerce_seller_app/data_model/user_by_token.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class AuthRepository {
  Future<LoginResponse> getLoginResponse(
      @required String email, @required String password) async {
    var post_body = jsonEncode({
      "email": "${email}",
      "password": "$password",
      "identity_matrix": AppConfig.purchase_code,
      "user_type": "seller"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/login");

    //print("login url " + url.toString());
   // print("login body " + post_body.toString());

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "App-Language": app_language.$,
        },
        body: post_body);

    //print("login re ${response.body}");
    return loginResponseFromJson(response.body);
  }


  Future<LogoutResponse> getLogoutResponse() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/logout");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );

    //print(response.body);

    return logoutResponseFromJson(response.body);
  }

  // Future<ResendCodeResponse> getResendCodeResponse(
  //     @required int user_id, @required String verify_by) async {
  //   var post_body =
  //       jsonEncode({"user_id": "$user_id", "register_by": "$verify_by"});
  //
  //   Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/resend_code");
  //   final response = await http.post(url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "App-Language": app_language.$,
  //       },
  //       body: post_body);
  //
  //   return resendCodeResponseFromJson(response.body);
  // }
  //
  // Future<ConfirmCodeResponse> getConfirmCodeResponse(
  //     @required int user_id, @required String verification_code) async {
  //   var post_body = jsonEncode(
  //       {"user_id": "$user_id", "verification_code": "$verification_code"});
  //
  //   Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/confirm_code");
  //   final response = await http.post(url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "App-Language": app_language.$,
  //       },
  //       body: post_body);
  //
  //   return confirmCodeResponseFromJson(response.body);
  // }
  //
  // Future<PasswordForgetResponse> getPasswordForgetResponse(
  //     @required String email_or_phone, @required String send_code_by) async {
  //   var post_body = jsonEncode(
  //       {"email_or_phone": "$email_or_phone", "send_code_by": "$send_code_by"});
  //
  //   Uri url = Uri.parse(
  //     "${AppConfig.BASE_URL}/auth/password/forget_request",
  //   );
  //   final response = await http.post(url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "App-Language": app_language.$,
  //       },
  //       body: post_body);
  //
  //   //print(response.body.toString());
  //
  //   return passwordForgetResponseFromJson(response.body);
  // }
  //
  // Future<PasswordConfirmResponse> getPasswordConfirmResponse(
  //     @required String verification_code, @required String password) async {
  //   var post_body = jsonEncode(
  //       {"verification_code": "$verification_code", "password": "$password"});
  //
  //   Uri url = Uri.parse(
  //     "${AppConfig.BASE_URL}/auth/password/confirm_reset",
  //   );
  //   final response = await http.post(url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "App-Language": app_language.$,
  //       },
  //       body: post_body);
  //
  //   return passwordConfirmResponseFromJson(response.body);
  // }

  // Future<ResendCodeResponse> getPasswordResendCodeResponse(
  //     @required String email_or_code, @required String verify_by) async {
  //   var post_body = jsonEncode(
  //       {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});
  //
  //   Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/password/resend_code");
  //   final response = await http.post(url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "App-Language": app_language.$,
  //       },
  //       body: post_body);
  //
  //   return resendCodeResponseFromJson(response.body);
  // }

  Future<UserByTokenResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.$}"});
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-user-by-access_token");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return userByTokenResponseFromJson(response.body);
  }



  Future<PasswordForgetResponse> getPasswordForgetResponse(
      @required String email_or_phone, @required String send_code_by) async {
    var post_body = jsonEncode(
        {"email_or_phone": "$email_or_phone", "send_code_by": "$send_code_by"});

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/auth/password/forget_request",
    );

    // print("forget pass url ${url.toString()}");
    // print("forget pass body ${post_body.toString()}");


    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    // print("response.body.toString()${response.body.toString()}");

    return passwordForgetResponseFromJson(response.body);
  }


  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      @required String verification_code, @required String password) async {
    var post_body = jsonEncode(
        {"verification_code": "$verification_code", "password": "$password"});

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/auth/password/confirm_reset",
    );
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return passwordConfirmResponseFromJson(response.body);
  }


  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      @required String email_or_code, @required String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/password/resend_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return resendCodeResponseFromJson(response.body);
  }



}
