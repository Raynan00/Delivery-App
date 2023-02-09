import 'package:active_ecommerce_seller_app/data_model/addon_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/repositories/addon_repository.dart';

class AddonsHelper {
  setAddonsData() async {
    List<AddonResponse> addonsList = await AddonRepository().getAddonList();
    addonsList.forEach((element) {
      switch (element.uniqueIdentifier) {
        case 'refund_request':
          {
            if (element.activated.toString() == "1") {
              refund_addon.$ = true;
            } else {
              refund_addon.$ = false;
            }
          }
          break;
        case 'seller_subscription':
          {
            if (element.activated.toString() == "1") {
              seller_package_addon.$ = true;
            } else {
              seller_package_addon.$ = false;
            }
          }
          break;
        case 'offline_payment':
          {
            if (element.activated.toString() == "1") {
              offline_payment_addon.$ = true;
            } else {
              offline_payment_addon.$ = false;
            }
          }
          break;
        case 'delivery_boy':
          {
            if (element.activated.toString() == "1") {
              delivery_boy_addon.$ = true;
            } else {
              delivery_boy_addon.$ = false;
            }
          }
          break;

        default:
          {}
      }
    });
  }
}
