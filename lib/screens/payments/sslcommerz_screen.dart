import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SslCommerzScreen extends StatefulWidget {
  double amount;
  String payment_type;
  String payment_method_key;

  SslCommerzScreen(
      {Key key,
      this.amount = 0.00,
      this.payment_type = "",
      this.payment_method_key = ""})
      : super(key: key);

  @override
  _SslCommerzScreenState createState() => _SslCommerzScreenState();
}

class _SslCommerzScreenState extends State<SslCommerzScreen> {
  int _combined_order_id = 0;
  bool _order_init = false;

  String _initial_url = "";
  bool _initial_url_fetched = false;

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      getSetInitialUrl();

  }

  getSetInitialUrl() async {
    var sslcommerzUrlResponse = await PaymentRepository().getSslcommerzBeginResponse(
        widget.payment_type, _combined_order_id, widget.amount);

    if (sslcommerzUrlResponse.result == false) {
      ToastComponent.showDialog(sslcommerzUrlResponse.message, 
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.of(context).pop();
      return;
    }

    _initial_url = sslcommerzUrlResponse.url;
    _initial_url_fetched = true;


    setState(() {});

    //print(_initial_url);
    //print(_initial_url_fetched);
  }

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
    _webViewController
        .evaluateJavascript("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      //print(data.toString());

        ToastComponent.showDialog(responseJSON["message"],
            duration: Toast.lengthLong, gravity: Toast.center);
        Navigator.pop(context);

    });
  }



  buildBody() {
/*    String initial_url =
        "${AppConfig.BASE_URL}/sslcommerz/begin?payment_type=${widget.payment_type}&combined_order_id=${_combined_order_id}&amount=${widget.amount}&user_id=${user_id.$}";*/

    //print("init url");
    //print(initial_url);


    if (_initial_url_fetched == false) {
      return Container(
        child: Center(
          child: Text(AppLocalizations.of(context).sslcommerz_screen_fetching_sslcommerz_url),
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

              if (page.contains("/sslcommerz/success")) {
                getData();
              } else if (page.contains("/sslcommerz/cancel") || page.contains("/sslcommerz/fail")) {
                ToastComponent.showDialog("Payment cancelled or failed", 
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
        AppLocalizations.of(context).sslcommerz_screen_pay_with_sslcommerz  ,
        style: TextStyle(fontSize: 16, color: MyTheme.app_accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
