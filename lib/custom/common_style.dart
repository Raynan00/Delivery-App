import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextStyle{

 static TextStyle smallFontSize(){
    return TextStyle(
      fontSize: 12,
      color: Colors.grey,
      fontWeight: FontWeight.normal
    );
  }
static TextStyle normalStyle(){
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.normal
    );
  }

static TextStyle bigFontSize(){
    return TextStyle(
      fontSize: 18,
      color: Colors.grey,
      fontWeight: FontWeight.w400
    );
  }

 TextStyle dashboardBoxNumber(context){
    return TextStyle(
      fontSize: (DeviceInfo(context).getWidth()/100)*5,
      color: MyTheme.white,
      fontWeight: FontWeight.bold
    );
  }

 TextStyle dashboardBoxText(context){
    return TextStyle(

        fontSize: (DeviceInfo(context).getWidth()/100)*3.5,
      color: MyTheme.white,
      fontWeight: FontWeight.normal
    );
  }





TextStyle appbarText(){
   return TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: MyTheme.app_accent_color);
}
}