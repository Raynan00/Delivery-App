import 'package:active_ecommerce_seller_app/custom/common_style.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:flutter/material.dart';

class MyAppBar {
  bool centerTitle = false;
  String title;
  BuildContext context;

  MyAppBar({this.title,this.context,this.centerTitle});

  AppBar show() {
    return AppBar(

      leadingWidth:0.0,
      centerTitle: centerTitle,
      elevation: 5,
      title: Row(
        children: [
          Container(
            width:24,
            height: 24,
            child: IconButton(
              splashRadius: 15,
              padding: EdgeInsets.all(0.0),
              onPressed: (){
                Navigator.pop(context);
              }, icon: Image.asset(
              'assets/icon/back_arrow.png',
              height: 20,
              width: 20,
              color: MyTheme.app_accent_color,
              //color: MyTheme.dark_grey,
            ),),
          ),
          SizedBox(width: 10,),
          Text(title,style: MyTextStyle().appbarText(),),
        ],
      ),
      backgroundColor: Colors.white,
      /*leading:Container(
        margin: EdgeInsets.only(left: 10),
        child: IconButton(

          iconSize: 20,
          splashRadius: 15,
          padding: EdgeInsets.zero,
            onPressed: (){
          Navigator.pop(context);
        }, icon: Image.asset(
          'assets/icon/back_arrow.png',
          height: 20,
          width: 20,
          //color: MyTheme.dark_grey,
        ),),
      ),*/
    );
  }
}
