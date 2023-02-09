import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:one_context/one_context.dart';

class DeliveryStatus {
  String option_key;
  String name;

  DeliveryStatus(this.option_key, this.name);

  static List<DeliveryStatus> getDeliveryStatusList() {
    return <DeliveryStatus>[
      DeliveryStatus('', LangText(context: OneContext().context).getLocal().order_list_screen_all),
      DeliveryStatus('pending', LangText(context: OneContext().context).getLocal().order_list_screen_pending),
      DeliveryStatus('confirmed', LangText(context: OneContext().context).getLocal().order_list_screen_confirmed),
      DeliveryStatus('picked_up', LangText(context: OneContext().context).getLocal().order_list_screen_picked_up),
      DeliveryStatus('on_the_way', LangText(context: OneContext().context).getLocal().order_list_screen_on_the_way),
      DeliveryStatus('delivered', LangText(context: OneContext().context).getLocal().order_list_screen_delivered),
      DeliveryStatus('cancelled', LangText(context: OneContext().context).getLocal().order_list_screen_cancelled),
    ];
  }

    static List<DeliveryStatus> getDeliveryStatusListForUpdate() {
    return <DeliveryStatus>[
      DeliveryStatus('pending', LangText(context: OneContext().context).getLocal().order_list_screen_pending),
      DeliveryStatus('confirmed', LangText(context: OneContext().context).getLocal().order_list_screen_confirmed),
      DeliveryStatus('picked_up', LangText(context: OneContext().context).getLocal().order_list_screen_picked_up),
      DeliveryStatus('on_the_way', LangText(context: OneContext().context).getLocal().order_list_screen_on_the_way),
      DeliveryStatus('delivered', LangText(context: OneContext().context).getLocal().order_list_screen_delivered),
      DeliveryStatus('cancelled', LangText(context: OneContext().context).getLocal().order_list_screen_cancelled),
    ];
  }

}