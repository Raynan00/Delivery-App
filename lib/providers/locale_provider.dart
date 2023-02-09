import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale;
  Locale get locale {
    return _locale = Locale(app_mobile_language.$, '');
  }

  void setLocale(String code) {
    _locale = Locale(code, '');
    notifyListeners();
  }
}
