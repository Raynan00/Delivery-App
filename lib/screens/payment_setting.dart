import 'dart:convert';

import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/input_decorations.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/submitButton.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/shop_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:validators/validators.dart';

class PaymentSetting extends StatefulWidget {
  const PaymentSetting({Key key}) : super(key: key);

  @override
  State<PaymentSetting> createState() => _PaymentSettingState();
}

class _PaymentSettingState extends State<PaymentSetting> {

  TextEditingController bankNameEditingController = TextEditingController(text: "");
  TextEditingController accountNameEditingController = TextEditingController(text: "");
  TextEditingController accountNumberEditingController = TextEditingController(text: "");
  TextEditingController bankRoutingNumberEditingController = TextEditingController(text: "");

  BuildContext loadingContext;


  String bankName,accountName,accountNumber,bankRoutingNumber,bankPayment,cashPayment;



  setDataInEditController(){
    bankNameEditingController.text=bankName;
    accountNameEditingController.text = accountName;
    accountNumberEditingController.text = accountNumber;
    bankRoutingNumberEditingController.text = bankRoutingNumber;
  }

  bool _faceData=false;

  String error= "Provide Number";

  setDataInVariable(){
    bankName=bankNameEditingController.text;
    accountName=accountNameEditingController.text ;
    accountNumber=accountNumberEditingController.text ;
    bankRoutingNumber =  bankRoutingNumberEditingController.text ;

  }


  Future<bool> _getAccountInfo() async {
    var response = await ShopRepository().getShopInfo();
    Navigator.pop(loadingContext);
    bankName=response.shopInfo.bankName;
    accountName=response.shopInfo.bankAccName;
    accountNumber=response.shopInfo.bankAccNo;
    bankRoutingNumber=response.shopInfo.bankRoutingNo.toString();
    bankPayment=response.shopInfo.bank_payment_status.toString();
    cashPayment=response.shopInfo.cashOnDeliveryStatus.toString();


    print(bankPayment);

    setDataInEditController();

    _faceData=true;
    setState(() {});
    return true;
  }

  faceData(){
    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadingShow(context));
    _getAccountInfo();
  }



  updateInfo()async{
    setDataInVariable();

    var  postBody = jsonEncode({
      "cash_on_delivery_status": cashPayment,
      "bank_payment_status": bankPayment,
      "bank_name":bankName,
      "bank_acc_name": accountName,
      "bank_acc_no": accountNumber,
      "bank_routing_no": bankRoutingNumber,
    });
    loadingShow(context);
    var response = await ShopRepository().updateShopSetting(postBody);
    Navigator.pop(loadingContext);

    if (response.result) {
      ToastComponent.showDialog(response.message,
        gravity: Toast.center,
        duration: 3,
        textStyle: TextStyle(color: MyTheme.black),
      );
    }else{
      ToastComponent.showDialog(response.message,
        gravity: Toast.center,
        duration: 3,
        textStyle: TextStyle(color: MyTheme.black),
      );
    }

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
                  .dashboard_payment_settings)
          .show(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                width: DeviceInfo(context).getWidth(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LangText(context: context)
                          .getLocal()
                          .payment_setting_screen_bank_payment,
                      style: TextStyle(
                          fontSize: 12,
                          color: MyTheme.font_grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      activeColor: MyTheme.green,
                      inactiveThumbColor: Colors.grey,
                      value: bankPayment=="1",
                      onChanged: (value) {
                        if(value){
                          bankPayment="1";
                        }else{
                          bankPayment="0";
                        }
                        setState(() {

                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                width: DeviceInfo(context).getWidth(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LangText(context: context)
                          .getLocal()
                          .payment_setting_screen_cash_payment,
                      style: TextStyle(
                          fontSize: 12,
                          color: MyTheme.font_grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      activeColor: MyTheme.green,
                      inactiveThumbColor: Colors.grey,
                      value: cashPayment=="1",
                      onChanged: (value) {
                        if(value){
                          cashPayment="1";
                        }else{
                          cashPayment="0";
                        }
                        setState(() {
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),
              buildBankName(context),
              SizedBox(
                height: 14,
              ),
              buildBankAccountName(context),
              SizedBox(
                height: 14,
              ),
              buildBankAccountNumber(context),
              SizedBox(
                height: 14,
              ),
              buildBankRoutingNumber(context),
              SizedBox(
                height: 30,
              ),
              SubmitBtn.show(
                elevation: 5,
                  onTap: () {
                    updateInfo();
                  },
                  alignment: Alignment.center,
                  height: 48,
                  backgroundColor: MyTheme.app_accent_color,
                  radius: 6.0,
                  width: DeviceInfo(context).getWidth(),
                  child: Text(
                    LangText(context: context).getLocal().common_save,
                    style: TextStyle(fontSize: 17, color: MyTheme.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Column buildBankRoutingNumber(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context)
              .getLocal()
              .payment_setting_screen_bank_routing_number,
          style: TextStyle(
              fontSize: 12,
              color: MyTheme.font_grey,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        MyWidget.customCardView(
          width: DeviceInfo(context).getWidth(),
          height: 45,
          borderRadius: 10,
          elevation: 5,
          backgroundColor: MyTheme.white,
          child: TextField(

            onChanged: (data){
              if(!isNumeric(data)){
                bankRoutingNumberEditingController.text="";
              }
              print(data);
            },
            keyboardType:TextInputType.number ,
            controller: bankRoutingNumberEditingController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: "91400554",
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.grey_153),
          ),
        ),
      ],
    );
  }

  Column buildBankAccountNumber(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context)
              .getLocal()
              .payment_setting_screen_bank_account_number,
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
            controller: accountNumberEditingController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: "7131259163",
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.grey_153),
          ),
        ),
      ],
    );
  }

  Column buildBankAccountName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context)
              .getLocal()
              .payment_setting_screen_bank_account_name,
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
            controller: accountNameEditingController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: "Elmira Wisozk",
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.grey_153),
          ),
        ),
      ],
    );
  }

  Column buildBankName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context)
              .getLocal()
              .payment_setting_screen_bank_name,
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
            controller: bankNameEditingController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: "Plains Commerce Bank",
                borderColor: MyTheme.noColor,

                hintTextColor: MyTheme.grey_153),
          ),
        ),
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
