import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration buildInputDecoration_1({hint_text = "",Color hintTextColor = MyTheme.app_accent_color,Color borderColor = MyTheme.app_accent_border,Color fillColor =const Color.fromRGBO(255, 255, 255, 0)}) {
    return InputDecoration(
      fillColor: fillColor,
        hintText: hint_text,
        hintStyle: TextStyle(fontSize: 12.0, color: hintTextColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.app_accent_color.withOpacity(0.5), width: 1.5),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        contentPadding: EdgeInsets.only(left: 16.0));
  }

  static InputDecoration buildInputDecoration_phone({hint_text = ""}) {
    return InputDecoration(
        hintText: hint_text,
        hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.app_accent_color),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.app_accent_color.withOpacity(0.8), width: 1.0),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.app_accent_color.withOpacity(0.8), width: 1.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0))),
        contentPadding: EdgeInsets.only(left: 16.0));
  }
}
