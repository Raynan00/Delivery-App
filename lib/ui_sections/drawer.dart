import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/custom/route_transaction.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/helpers/auth_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/repositories/auth_repository.dart';
import 'package:active_ecommerce_seller_app/screens/commission_history.dart';
import 'package:active_ecommerce_seller_app/screens/conversation.dart';

import 'package:active_ecommerce_seller_app/screens/home.dart';
import 'package:active_ecommerce_seller_app/screens/login.dart';
import 'package:active_ecommerce_seller_app/screens/orders.dart';
import 'package:active_ecommerce_seller_app/screens/payment_history.dart';
import 'package:active_ecommerce_seller_app/screens/product_reviews.dart';
import 'package:active_ecommerce_seller_app/screens/products.dart';
import 'package:active_ecommerce_seller_app/screens/profile.dart';
import 'package:active_ecommerce_seller_app/screens/shop_settings/shop_settings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toast/toast.dart';

class MainDrawer extends StatefulWidget {
  final int index;

  MainDrawer({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  onTapLogout(context) async {
    AuthHelper().clearUserData();

    // var logoutResponse = await AuthRepository().getLogoutResponse();
    //
    // if (logoutResponse.result == true) {
    //   ToastComponent.showDialog(logoutResponse.message, context,
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //
    //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
    //     return Login();
    //   }),(route)=>false);
    // }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Login();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection:
            //app_language_rtl.$ ? TextDirection.rtl :
            TextDirection.ltr,
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.png')
                    // NetworkImage(
                    //   "${}",
                    // ),
                    ),
                //title: Text("${user_name.$}"),
                subtitle: Text("kk"
                    //if user email is not available then check user phone if user phone is not available use empty string
                    ),
              ),
              Divider(),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/home.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).drawer_dashboard,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {
                    if (widget.index == 0) {
                      Navigator.pop(context);
                    } else {
                      MyTransaction(context: context).push(Home());
                    }
                  }),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/profile.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).drawer_profile,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {
                    if (widget.index == 3) {
                      Navigator.pop(context);
                    } else {
                     // MyTransaction(context: context).push(Profile());
                    }
                  }),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/cupon.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).drawer_coupon,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {

                  }),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/orders.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).drawer_orders,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {
                    if (widget.index == 2) {
                      Navigator.pop(context);
                    } else {
                      MyTransaction(context: context).push(Orders());
                    }
                  }),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/product_reviews.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).drawer_product_reviews,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {
                    MyTransaction(context: context).push(ProductReviews());
                  }),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/shop_setting.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).drawer_shop_Settings,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {
                    MyTransaction(context: context).push(ShopSettings());
                  }),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/payment_history.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).drawer_payment_history,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {
                    MyTransaction(context: context).push(PaymentHistory());
                  }),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/withdraw.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).drawer_withdrawal,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {
                    //MyTransaction(context: context).push(Withdraw());
                  }),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/commision.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).drawer_commission_history,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {
                    MyTransaction(context: context).push(CommissionHistory());
                  }),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/chat.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).drawer_conversation,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {
                    MyTransaction(context: context).push(Conversation());
                  }),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/products.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).product_screen_products,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {
                    if (widget.index == 1) {
                      Navigator.pop(context);
                    } else {
                      MyTransaction(context: context).push(
                        Products(),
                      );
                    }
                  }),
              Divider(),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset(
                    "assets/logout.png",
                    height: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  title: Text(
                    AppLocalizations.of(context).drawer_logout,
                    // AppLocalizations.of(context).main_drawer_home,
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  ),
                  onTap: () {
                    onTapLogout(context);
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
