import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/route_transaction.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/screens/create_ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class SupportTicket extends StatefulWidget {
  const SupportTicket({Key key}) : super(key: key);

  @override
  State<SupportTicket> createState() => _SupportTicketState();
}

class _SupportTicketState extends State<SupportTicket> {
 List<bool> _mailHide = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context: context,title: LangText(context: context).getLocal().dashboard_support_tickets).show(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAddSupportTicketContainer(context),
              SizedBox(height: 20,),
              Container(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 16,
                    itemBuilder: (context,index){
                    _mailHide.add(false);
                    return buildTicketItemContainer(context,index);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTicketItemContainer(BuildContext context,int index) {
    return AnimatedContainer(
      constraints:BoxConstraints(
        minHeight: _mailHide[index]?150:110
      ) ,
      duration: Duration(seconds: 1),
                  padding: EdgeInsets.all(15),
        curve: Curves.fastOutSlowIn,
                  margin: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: MyTheme.light_grey,width: 1),
                      color: MyTheme.app_accent_color_extra_light,
                    ),
                  width: DeviceInfo(context).getWidth(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Damaged Product",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: MyTheme.app_accent_color),),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Image.asset('assets/icon/calender.png',width: 12,height: 12,),
                          SizedBox(width: 8,),
                          Text("Damaged Product",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: MyTheme.font_grey),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Image.asset('assets/icon/ticket_id.png',width: 12,height: 12,),
                          SizedBox(width: 8,),
                          Text("Damaged Product",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: MyTheme.font_grey),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Image.asset('assets/icon/car.png',width: 12,height: 12,),
                          SizedBox(width: 8,),
                          Row(
                            children: [
                              Text(LangText(context: context).getLocal().support_ticket_screen_options+" - ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: MyTheme.font_grey),),
                              InkWell(
                                onTap:(){
                                  print('dd');
                                  setState(() {
                                    _mailHide[index] = !_mailHide[index];
                                  });
                                },
                                child: Text(
                                  LangText(context: context).getLocal().support_ticket_screen_view_details,
                                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: MyTheme.app_accent_color,decoration: TextDecoration.underline ),),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Visibility(
                        visible: _mailHide[index],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Text("Damaged Product",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: MyTheme.app_accent_color),),
                            Container(
                          width: DeviceInfo(context).getWidth(),
                            child: Text("But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur ",
                                style: TextStyle(fontSize: 12,color: MyTheme.font_grey),)),
                          ],
                        ),
                      )
                    ],
                  )
                );
  }




  Widget buildAddSupportTicketContainer(BuildContext context) {
    return InkWell(
      onTap: (){
       MyTransaction(context: context).push(CreateTicket());
      },
      child: MyWidget().myContainer(
          height: 75,
          width: DeviceInfo(context).getWidth(),
          borderRadius: 10,
          bgColor: MyTheme.app_accent_color_extra_light,
          borderColor: MyTheme.app_accent_color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                LangText(context: context)
                    .getLocal()
                    .support_ticket_screen_create_a_Ticket,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: MyTheme.app_accent_color),
              ),
              Image.asset(
                'assets/icon/add.png',
                width: 18,
                height: 18,
                color: MyTheme.app_accent_color,
              )
            ],
          )),
    );
  }
}
