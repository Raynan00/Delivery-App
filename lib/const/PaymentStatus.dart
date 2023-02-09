import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:one_context/one_context.dart';

class PaymentStatus {
  String option_key;
  String name;

  PaymentStatus(this.option_key, this.name);

  static List<PaymentStatus> getPaymentStatusList() {
    return <PaymentStatus>[
      PaymentStatus('', LangText(context: OneContext().context).getLocal().order_list_screen_all),
      PaymentStatus('paid', LangText(context: OneContext().context).getLocal().order_list_screen_paid),
      PaymentStatus('unpaid', LangText(context: OneContext().context).getLocal().order_list_screen_unpaid),
    ];
  }
  static List<PaymentStatus> getPaymentStatusListForUpdater() {
    return <PaymentStatus>[
      PaymentStatus('paid', LangText(context: OneContext().context).getLocal().order_list_screen_paid),
      PaymentStatus('unpaid', LangText(context: OneContext().context).getLocal().order_list_screen_unpaid),
    ];
  }
}

