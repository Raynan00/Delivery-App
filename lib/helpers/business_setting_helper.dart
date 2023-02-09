import 'package:active_ecommerce_seller_app/data_model/business_setting_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/repositories/business_setting_repository.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class BusinessSettingHelper {
  setBusinessSettingData() async {
    List<BusinessSettingListResponse> businessLists =
        await BusinessSettingRepository().getBusinessSettingList();

    businessLists.forEach((element) {
      switch (element.type) {
        case 'conversation_system':
          {
            if (element.value.toString() == "1") {
              conversation_activation.$ = true;
            } else {
              conversation_activation.$ = false;
            }
          }
          break;
        case 'coupon_system':
          {
            if (element.value.toString() == "1") {
              coupon_activation.$ = true;
            } else {
              coupon_activation.$ = false;
            }
          }
          break;
        case 'product_manage_by_admin':
          {
            if (element.value.toString() == "1") {
              seller_product_manage_admin.$ = true;
            } else {
              seller_product_manage_admin.$ = false;
            }
            print("seller_product_manage_admin.${seller_product_manage_admin.$}");
          }
          break;
        default:
          {}
          break;
      }
    });
  }
}
