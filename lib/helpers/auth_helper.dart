import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/repositories/auth_repository.dart';

class AuthHelper {
  setUserData(loginResponse) {
    if (loginResponse.result == true) {
      is_logged_in.$ = true;
      is_logged_in.save();
      access_token.$ = loginResponse.access_token;
      access_token.save();
      seller_id.$ = loginResponse.user.id;
      seller_id.save();

    }
  }

  clearUserData() {
      is_logged_in.$ = false;
      is_logged_in.save();
      access_token.$ = "";
      access_token.save();
      seller_id.$ = 0;
      seller_id.save();
  }


  fetch_and_set() async {
    var userByTokenResponse = await AuthRepository().getUserByTokenResponse();

    if (userByTokenResponse.result == true) {
      is_logged_in.$ = true;
      is_logged_in.save();
      seller_id.$ = userByTokenResponse.id;
      seller_id.save();

    }else{
      is_logged_in.$ = false;
      is_logged_in.save();
      seller_id.$ = 0;
      seller_id.save();

    }
  }
}
