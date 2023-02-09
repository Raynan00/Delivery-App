import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/route_transaction.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/helpers/file_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/file_upload_repository.dart';
import 'package:active_ecommerce_seller_app/repositories/profile_repository.dart';
import 'package:active_ecommerce_seller_app/screens/shop_settings/shop_banner_settings.dart';
import 'package:active_ecommerce_seller_app/screens/shop_settings/shop_delivery_boy_pickup_point_setting.dart';
import 'package:active_ecommerce_seller_app/screens/shop_settings/shop_general_setting.dart';
import 'package:active_ecommerce_seller_app/screens/shop_settings/shop_social_media_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShopSettings extends StatefulWidget {
  const ShopSettings({Key key}) : super(key: key);

  @override
  _ShopSettingsState createState() => _ShopSettingsState();
}

class _ShopSettingsState extends State<ShopSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
              title: AppLocalizations.of(context).drawer_shop_Settings,
              context: context)
          .show(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              FlatButton(
                color: MyTheme.app_accent_color,
                minWidth: DeviceInfo(context).getWidth(),
                height: 75,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  MyTransaction(context: context).push(ShopGeneralSetting());
                },
                child: Container(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0,left: 4),
                        child: Image.asset("assets/icon/general_setting.png",height: 17,width: 17,),
                      ),

                      Text(
                        LangText(context: context)
                            .getLocal()
                            .shop_setting_screen_general_setting,
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.navigate_next_rounded,
                        size: 20,
                        color: MyTheme.white,
                      )
                    ],
                  ),
                ),
              ),


              Visibility(
                visible: delivery_boy_addon.$,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      color: MyTheme.app_accent_color,
                      minWidth: DeviceInfo(context).getWidth(),
                      height: 75,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        MyTransaction(context: context)
                            .push(ShopDeliveryBoyPickupPoint());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0,left: 4),
                            child: Image.asset("assets/icon/delivery_boy_setting.png",height: 17,width: 17,),
                          ),
                          Text(
                            LangText(context: context)
                                .getLocal()
                                .shop_setting_screen_delivery_boy_pickup_point,
                            style: TextStyle(
                                fontSize: 14,
                                color: MyTheme.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Icon(
                            Icons.navigate_next_rounded,
                            size: 20,
                            color: MyTheme.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  color: MyTheme.app_accent_color,
                  minWidth: DeviceInfo(context).getWidth(),
                  height: 75,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    MyTransaction(context: context).push(ShopBannerSettings());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0,left: 4),
                        child: Image.asset("assets/icon/banner_setting.png",height: 17,width: 17,),
                      ),

                      Text(
                        LangText(context: context)
                            .getLocal()
                            .shop_setting_screen_banner_settings,
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.navigate_next_rounded,
                        size: 20,
                        color: MyTheme.white,
                      )
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  color: MyTheme.app_accent_color,
                  minWidth: DeviceInfo(context).getWidth(),
                  height: 75,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    MyTransaction(context: context)
                        .push(ShopSocialMedialSetting());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0,left: 4),
                        child: Image.asset("assets/icon/social_setting.png",height: 17,width: 17,),
                      ),

                      Text(
                        LangText(context: context)
                            .getLocal()
                            .shop_setting_screen_social_media_link,
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.navigate_next_rounded,
                        size: 20,
                        color: MyTheme.white,
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
