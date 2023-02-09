import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/input_decorations.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/submitButton.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:flutter/material.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({Key key}) : super(key: key);

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context: context,title: LangText(context: context).getLocal().create_ticket_screen_title).show(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LangText(context: context)
                    .getLocal()
                    .create_ticket_screen_subject,
                style: TextStyle(
                    fontSize: 12,
                    color: MyTheme.font_grey,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecorations.buildInputDecoration_1(
                    hint_text: LangText(context: context)
                        .getLocal()
                        .create_ticket_screen_subject,
                    borderColor: MyTheme.light_grey,
                    hintTextColor: MyTheme.grey_153),
              ),
            ],
          ),
            SizedBox(height: 14,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LangText(context: context)
                      .getLocal()
                      .create_ticket_screen_provide_a_detailed_description,
                  style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.font_grey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                MyWidget().myContainer(
                  paddingY: 8.0,
                  height: 80,
                  width: DeviceInfo(context).getWidth(),
                  borderColor: MyTheme.light_grey,
                  borderRadius: 6,
                  child: TextField(
                    decoration: InputDecoration.collapsed(hintText: "Type your reply",hintStyle: TextStyle(color: MyTheme.grey_153,fontSize: 12)),
                    maxLines: 6,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LangText(context: context)
                      .getLocal()
                      .common_photo,
                  style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.font_grey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                MyWidget().myContainer(
                    width: DeviceInfo(context).getWidth(),
                    height: 36,
                    borderRadius: 6.0,
                    borderColor: MyTheme.light_grey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Text(
                            "Choose file",
                            style: TextStyle(fontSize: 12, color: MyTheme.grey_153),
                          ),
                        ),
                        Container(
                            alignment: Alignment.center,
                            height: 36,
                            width: 80,
                            color: MyTheme.light_grey,
                            child: Text(
                              "Browse",
                              style: TextStyle(fontSize: 12, color: MyTheme.grey_153),
                            )),
                      ],
                    ))
              ],
            ),
            SizedBox(height: 18,),
            Container(
              width: DeviceInfo(context).getWidth(),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SubmitBtn.show(height: 30.0,width: 120.0,child: Text(LangText(context: context)
                      .getLocal()
                      .common_cancel,style: TextStyle(color: MyTheme.white,fontSize: 13),),backgroundColor: MyTheme.grey_153,onTap: (){
                    Navigator.pop(context);
                  },
                    radius: 2.0
                  ),
                  SizedBox(width: 14,),
                  SubmitBtn.show(height: 30.0,width: 120.0,child: Text(LangText(context: context)
                      .getLocal()
                      .create_ticket_screen_send_ticket,style: TextStyle(color: MyTheme.white,fontSize: 13),),backgroundColor: MyTheme.app_accent_color,onTap: (){},
                    radius: 2.0
                  ),
                ],
              ),
            )

          ],),
        ),
      ),
    );
  }
}
