import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class IyzicoScreen extends StatefulWidget {
  double amount;
  String payment_type;
  String payment_method_key;

  IyzicoScreen(
      {Key key,
      this.amount = 0.00,
      this.payment_type = "",
      this.payment_method_key = ""})
      : super(key: key);

  @override
  _IyzicoScreenState createState() => _IyzicoScreenState();
}

class _IyzicoScreenState extends State<IyzicoScreen> {
  int _combined_order_id = 0;
  bool _order_init = false;

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    if (widget.payment_type == "cart_payment") {
      //createOrder();
    }
  }

  // createOrder() async {
  //   var orderCreateResponse = await PaymentRepository()
  //       .getOrderCreateResponse( widget.payment_method_key);
  //
  //   if (orderCreateResponse.result == false) {
  //     ToastComponent.showDialog(orderCreateResponse.message, context,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //     Navigator.of(context).pop();
  //     return;
  //   }
  //
  //   _combined_order_id = orderCreateResponse.combined_order_id;
  //   _order_init = true;
  //   setState(() {});
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
    );
  }

  void getData() {
    print('called.........');
    var payment_details = '';
    _webViewController
        .evaluateJavascript("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data);
      print("iyzico decodedJSON ${decodedJSON.toString()}");

      try {
        Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
        print("iyzico responseJSON ${responseJSON.toString()}");
        if (responseJSON["result"] == false) {
          ToastComponent.showDialog(responseJSON["message"],
              duration: Toast.lengthLong, gravity: Toast.center);

          Navigator.pop(context);
        } else if (responseJSON["result"] == true) {
          print("a");
          payment_details = responseJSON['payment_details'];
          onPaymentSuccess(payment_details);
        }
      } on Exception catch (e) {
        print("error");
        // TODO
      }
    });
  }

  onPaymentSuccess(payment_details) async{
    print("b");

    var iyzicoPaymentSuccessResponse = await PaymentRepository().getIyzicoPaymentSuccessResponse(widget.payment_type, widget.amount,_combined_order_id, payment_details);

    if(iyzicoPaymentSuccessResponse.result == false ){
      print("c");
      ToastComponent.showDialog(iyzicoPaymentSuccessResponse.message,
          duration: Toast.lengthLong, gravity: Toast.center);
      Navigator.pop(context);
      return;
    }
    print("Success package Payment");

    ToastComponent.showDialog(iyzicoPaymentSuccessResponse.message,
        duration: Toast.lengthLong, gravity: Toast.center);
    if (widget.payment_type == "cart_payment") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        //return OrderList(from_checkout: true);
      }));
    } else if (widget.payment_type == "wallet_payment") {
      print("d");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        //return Wallet(from_recharge: true);
      }));
    }


  }


  buildBody() {

    String initial_url =
        "${AppConfig.BASE_URL}/iyzico/init?payment_type=${widget.payment_type}&combined_order_id=${_combined_order_id}&amount=${widget.amount}&user_id=${seller_id.$}";

    //print("init url");
    //print(initial_url);

    if (_order_init == false &&
        _combined_order_id == 0 &&
        widget.payment_type == "cart_payment") {
      return Container(
        child: Center(
          child: Text(AppLocalizations.of(context).common_no),
        ),
      );
    } else {
      return SizedBox.expand(
        child: Container(
          child: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _webViewController.loadUrl(initial_url);
            },
            onWebResourceError: (error) {},
            onPageFinished: (page) {
              print(page.toString());
                getData();
            },
          ),
        ),
      );
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context).iyzico_screen_pay_with_iyzico,
        style: TextStyle(fontSize: 16, color: MyTheme.app_accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
