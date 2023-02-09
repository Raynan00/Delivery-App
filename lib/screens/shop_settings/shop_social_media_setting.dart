import 'dart:convert';

import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/input_decorations.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/shop_repository.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ShopSocialMedialSetting extends StatefulWidget {
  const ShopSocialMedialSetting({Key key}) : super(key: key);

  @override
  State<ShopSocialMedialSetting> createState() =>
      _ShopSocialMedialSettingState();
}

class _ShopSocialMedialSettingState extends State<ShopSocialMedialSetting> {
  TextEditingController facebookEditController = TextEditingController();
  TextEditingController instagramEditController = TextEditingController();
  TextEditingController twitterEditController = TextEditingController();
  TextEditingController googleEditController = TextEditingController();
  TextEditingController youtubeEditController = TextEditingController();


  BuildContext loadingContext;


  Future<bool> _getAccountInfo() async {
    var response = await ShopRepository().getShopInfo();
    Navigator.pop(loadingContext);
    facebookEditController.text=response.shopInfo.facebook;
    instagramEditController.text=response.shopInfo.instagram;
    twitterEditController.text=response.shopInfo.twitter;
    googleEditController.text=response.shopInfo.google;
    youtubeEditController.text=response.shopInfo.youtube;

    setState(() {});
    return true;
  }

  faceData(){
    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadingShow(context));
    _getAccountInfo();
  }



  updateInfo()async{
    var  postBody = jsonEncode({
      "facebook": facebookEditController.text.trim().toString(),
      "instagram": instagramEditController.text.trim().toString(),
      "google": googleEditController.text.trim().toString(),
      "twitter": twitterEditController.text.trim().toString(),
      "youtube": youtubeEditController.text.trim().toString(),
    });
    loadingShow(context);
    var response = await ShopRepository().updateShopSetting(postBody);
    Navigator.pop(loadingContext);


      ToastComponent.showDialog(response.message,
          backgroundColor: MyTheme.white, duration: Toast.lengthLong, gravity: Toast.center);


  }

  Future onRefresh(){
    faceData();
    return Future.delayed(Duration(seconds: 0));
  }



  @override
  void initState() {
    faceData();
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
              context: context,
              title: LangText(context: context)
                  .getLocal()
                  .shop_setting_screen_social_media_link)
          .show(),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: 20,),
                buildFacebookContainer(context),
                SizedBox(
                  height: 14,
                ),
                buildInstagram(context),
                SizedBox(
                  height: 14,
                ),
                buildTwitter(context),
                SizedBox(
                  height: 14,
                ),
                buildGoogle(context),
                SizedBox(
                  height: 14,
                ),
                buildYoutube(context),
                SizedBox(
                  height: 30,
                ),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    minWidth: DeviceInfo(context).getWidth(),
                    color: MyTheme.app_accent_color,
                    height: 48,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      updateInfo();
                    },
                    child: Text(
                      LangText(context: context).getLocal().common_save,
                      style: TextStyle(fontSize: 17, color: MyTheme.white),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildYoutube(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LangText(context: context)
                      .getLocal()
                      .shop_social_media_setting_screen_youtube,
                  style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.font_grey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                MyWidget.customCardView(
                  backgroundColor: MyTheme.white,
                  width: DeviceInfo(context).getWidth(),
                  height: 45,
                  borderRadius: 10,
                  elevation: 5,
                  child: TextField(
                    controller: youtubeEditController,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: LangText(context: context)
                            .getLocal()
                            .shop_social_media_setting_screen_youtube,
                        borderColor: MyTheme.light_grey,
                        hintTextColor: MyTheme.grey_153),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Insert link with https",
                  style: TextStyle(fontSize: 8, color: MyTheme.grey_153),
                )
              ],
            );
  }

  Column buildGoogle(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LangText(context: context)
                      .getLocal()
                      .shop_social_media_setting_screen_google,
                  style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.font_grey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                MyWidget.customCardView(
                  backgroundColor: MyTheme.white,
                  width: DeviceInfo(context).getWidth(),
                  height: 45,
                  borderRadius: 10,
                  elevation: 5,
                  child: TextField(
                    controller: googleEditController,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: LangText(context: context)
                            .getLocal()
                            .shop_social_media_setting_screen_google,
                        borderColor: MyTheme.light_grey,
                        hintTextColor: MyTheme.grey_153),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Insert link with https",
                  style: TextStyle(fontSize: 8, color: MyTheme.grey_153),
                )
              ],
            );
  }

  Column buildTwitter(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LangText(context: context)
                      .getLocal()
                      .shop_social_media_setting_screen_twitter,
                  style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.font_grey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                MyWidget.customCardView(
                  backgroundColor: MyTheme.white,
                  width: DeviceInfo(context).getWidth(),
                  height: 45,
                  borderRadius: 10,
                  elevation: 5,
                  child: TextField(
                    controller: twitterEditController,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: LangText(context: context)
                            .getLocal()
                            .shop_social_media_setting_screen_twitter,
                        borderColor: MyTheme.light_grey,
                        hintTextColor: MyTheme.grey_153),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Insert link with https",
                  style: TextStyle(fontSize: 8, color: MyTheme.grey_153),
                )
              ],
            );
  }

  Column buildInstagram(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LangText(context: context)
                      .getLocal()
                      .shop_social_media_setting_screen_instagram,
                  style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.font_grey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                MyWidget.customCardView(
                  backgroundColor: MyTheme.white,
                  width: DeviceInfo(context).getWidth(),
                  height: 45,
                  borderRadius: 10,
                  elevation: 5,
                  child: TextField(
                    controller: instagramEditController,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: LangText(context: context)
                            .getLocal()
                            .shop_social_media_setting_screen_instagram,
                        borderColor: MyTheme.light_grey,
                        hintTextColor: MyTheme.grey_153),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Insert link with https",
                  style: TextStyle(fontSize: 8, color: MyTheme.grey_153),
                )
              ],
            );
  }

  Column buildFacebookContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context)
              .getLocal()
              .shop_social_media_setting_screen_facebook,
          style: TextStyle(
              fontSize: 12,
              color: MyTheme.font_grey,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        MyWidget.customCardView(
          backgroundColor: MyTheme.white,
          width: DeviceInfo(context).getWidth(),
          height: 45,
          borderRadius: 10,
          elevation: 5,
          child: TextField(
            controller: facebookEditController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: LangText(context: context)
                    .getLocal()
                    .shop_social_media_setting_screen_facebook,
                borderColor: MyTheme.light_grey,
                hintTextColor: MyTheme.grey_153),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Insert link with https",
          style: TextStyle(fontSize: 8, color: MyTheme.grey_153),
        )
      ],
    );
  }


  loadingShow(BuildContext myContext){
    return showDialog(
      //barrierDismissible: false,
        context: myContext,
        builder: (BuildContext context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text("${LangText(context: context).getLocal().common_loading}"),
                ],
              ));
        });
  }

}
