import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/payment_repository.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BkashScreen extends StatefulWidget {
  double amount;
  String payment_type;
  String payment_method_key;

  BkashScreen(
      {Key key,
      this.amount = 0.00,
      this.payment_type = "",
      this.payment_method_key = ""})
      : super(key: key);

  @override
  _BkashScreenState createState() => _BkashScreenState();
}

class _BkashScreenState extends State<BkashScreen> {
  int _combined_order_id = 0;
  bool _order_init = false;
  String _initial_url = "";
  bool _initial_url_fetched = false;

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



      // on cart payment need proper order id
      getSetInitialUrl();
  }



  getSetInitialUrl() async {
    var bkashUrlResponse = await PaymentRepository().getBkashBeginResponse(
        widget.payment_type, _combined_order_id, widget.amount);

    if (bkashUrlResponse.result == false) {
      ToastComponent.showDialog(bkashUrlResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.of(context).pop();
      return;
    }

    _initial_url = bkashUrlResponse.url;
    _initial_url_fetched = true;


    setState(() {});

    print(_initial_url);
    print(_initial_url_fetched);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  void getData() {
    var payment_details = '';
    _webViewController
        .evaluateJavascript("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      //print(data.toString());
      if (responseJSON["result"] == false) {
        ToastComponent.showDialog(responseJSON["message"],
            duration: Toast.lengthLong, gravity: Toast.center);
        Navigator.pop(context);
      } else if (responseJSON["result"] == true) {
        payment_details = responseJSON['payment_details'];
        onPaymentSuccess(payment_details);
      }
    });
  }
  onPaymentSuccess(payment_details) async{

    var bkashPaymentProcessResponse = await PaymentRepository().getBkashPaymentProcessResponse(widget.payment_type, widget.amount,_combined_order_id, payment_details);

    if(bkashPaymentProcessResponse.result == false ){

      ToastComponent.showDialog(bkashPaymentProcessResponse.message,
          duration: Toast.lengthLong, gravity: Toast.center);
      Navigator.pop(context);
      return;
    }

    ToastComponent.showDialog(bkashPaymentProcessResponse.message,
        duration: Toast.lengthLong, gravity: Toast.center);
      Navigator.pop(context);



  }
  

  buildBody() {
     if (_initial_url_fetched == false) {
      return Container(
        child: Center(
          child: Text(AppLocalizations.of(context).bkash_screen_fetching_bkash_url),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _webViewController.loadUrl(_initial_url);
            },
            onWebResourceError: (error) {},
            onPageFinished: (page) {
              //print(page.toString());

              if (page.contains("/bkash/api/success")) {
                getData();
              } else if (page.contains("/bkash/api/fail")) {
                ToastComponent.showDialog("Payment cancelled",
                    gravity: Toast.center, duration: Toast.lengthLong);
                Navigator.of(context).pop();
                return;
              }
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
        AppLocalizations.of(context).bkash_screen_pay_with_bkash,
        style: TextStyle(fontSize: 16, color: MyTheme.app_accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
