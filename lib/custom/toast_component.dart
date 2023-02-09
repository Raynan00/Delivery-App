import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:one_context/one_context.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

class ToastComponent {
  static showDialog(String msg, {duration = 0, gravity = 0,textStyle = const TextStyle(color: MyTheme.font_grey),Color backgroundColor =const Color.fromRGBO(239, 239, 239, .9)}) {
    ToastContext().init(OneContext().context);
    Toast.show(
      msg,
      duration: duration != 0 ? duration : Toast.lengthLong,
      gravity: gravity != 0 ? gravity : Toast.bottom,
        backgroundColor:backgroundColor,
        textStyle:textStyle,
        border: Border(
            top: BorderSide(
              color: Color.fromRGBO(203, 209, 209, 1),
            ),bottom:BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        ),right: BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        ),left: BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        )),
        backgroundRadius: 6
    );
  }
}
