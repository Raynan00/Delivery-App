

import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitBtn{
  static Widget show({EdgeInsetsGeometry padding= EdgeInsets.zero,Color borderColor=const Color.fromRGBO(255, 255, 255, 0.0) ,double elevation=0.0,Alignment alignment = Alignment.centerLeft,Color backgroundColor=MyTheme.app_accent_color,Function onTap ,double height=0.0,double width=0.0,double radius=0.0,Widget child= const Text("")}){
    return  RaisedButton(
      elevation: elevation,
      color: backgroundColor,
      padding: padding,
      onPressed: onTap,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: borderColor)
      ),
      child: Container(
          height: height,
          width: width,
          alignment: alignment,
          child: child),
    );
  }


}