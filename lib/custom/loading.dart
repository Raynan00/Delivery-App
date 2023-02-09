import 'dart:async';

import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';



class Loading{
  BuildContext _context;

  Future show(BuildContext context)async{

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        setData(context);
        print("dialog");
        return  AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                const SizedBox(
                  width: 10,
                ),
                Text(LangText(context: context).getLocal().common_loading),
              ],
            ));
      },);
  }

  hide(){
    Navigator.pop(getData());

  }


  setData(BuildContext context){

    this._context=context;


  }

  BuildContext getData(){

    return this._context;

  }


 static Widget bottomLoading(bool value){
     return value? Container(
       alignment: Alignment.center,
       child: SizedBox(
         height: 20,
           width: 20,
           child: CircularProgressIndicator()),
     ):SizedBox(height: 5,width: 5,);
   }

}