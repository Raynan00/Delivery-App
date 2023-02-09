import 'package:active_ecommerce_seller_app/data_model/shop_info_response.dart';
import 'package:shared_value/shared_value.dart';

final SharedValue<bool> is_logged_in = SharedValue(
  value: false, // initial value
  key: "is_logged_in", // disk storage key for shared_preferences
);

final SharedValue<String> access_token = SharedValue(
  value: "", // initial value
  key: "access_token", // disk storage key for shared_preferences
);

final SharedValue<int> seller_id = SharedValue(
  value: 0, // initial value
  key: "seller_id", // disk storage key for shared_preferences
);

final SharedValue<String> app_language = SharedValue(
  value: "en", // initial value
  key: "app_language", // disk storage key for shared_preferences
);

final SharedValue<String> app_mobile_language = SharedValue(
  value: "en", // initial value
  key: "app_mobile_language", // disk storage key for shared_preferences
);

final SharedValue<bool> app_language_rtl = SharedValue(
  value: false, // initial value
  key: "app_language_rtl", // disk storage key for shared_preferences
);

final SharedValue<bool> seller_product_manage_admin = SharedValue(
  value: false, // initial value
  key: "seller_product_manage_admin", // disk storage key for shared_preferences
);

// Addons
final SharedValue<bool> seller_package_addon = SharedValue(
  value: false, // initial value
  key: "package_addon", // disk storage key for shared_preferences
);
final SharedValue<bool> refund_addon = SharedValue(
  value: false, // initial value
  key: "refund_addon", // disk storage key for shared_preferences
);
final SharedValue<bool> offline_payment_addon = SharedValue(
  value: false, // initial value
  key: "offline_payment_addon", // disk storage key for shared_preferences
);

final SharedValue<bool> delivery_boy_addon = SharedValue(
  value: false, // initial value
  key: "delivery_boy_addon", // disk storage key for shared_preferences
);

// setting
final SharedValue<bool> conversation_activation = SharedValue(
  value: false, // initial value
  key: "conversation_activation", // disk storage key for shared_preferences
);
final SharedValue<bool> coupon_activation = SharedValue(
  value: false, // initial value
  key: "coupon_activation", // disk storage key for shared_preferences
);


// Shop info
final SharedValue<String> shop_name = SharedValue(
  value: "", // initial value
  key: "shop_name", // disk storage key for shared_preferences
);
final SharedValue<String> seller_email = SharedValue(
  value: "", // initial value
  key: "seller_email", // disk storage key for shared_preferences
);

final SharedValue<String> shop_logo = SharedValue(
  value: "", // initial value
  key: "shop_logo", // disk storage key for shared_preferences
);
final SharedValue<String> shop_rating = SharedValue(
  value: "", // initial value
  key: "shop_rating", // disk storage key for shared_preferences
);

final SharedValue<bool> shop_verify = SharedValue(
  value: false, // initial value
  key: "shop_verify", // disk storage key for shared_preferences
);
