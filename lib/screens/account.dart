import 'dart:convert';

import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/route_transaction.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/data_model/shop_info_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shop_info_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/auth_repository.dart';
import 'package:active_ecommerce_seller_app/repositories/shop_repository.dart';
import 'package:active_ecommerce_seller_app/screens/commission_history.dart';
import 'package:active_ecommerce_seller_app/screens/login.dart';
import 'package:active_ecommerce_seller_app/screens/main.dart';
import 'package:active_ecommerce_seller_app/screens/orders.dart';
import 'package:active_ecommerce_seller_app/screens/products.dart';
import 'package:active_ecommerce_seller_app/screens/profile.dart';
import 'package:active_ecommerce_seller_app/screens/upload_file.dart';
import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:toast/toast.dart';

class Account extends StatefulWidget {
  const Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin{



  AnimationController controller;
  Animation animation;

  bool _verify=false;
  bool _faceData= false;

  String _url="",_name="...",_email="...",_rating="...",_verified="..",_package="",_packageImg="";



  Future<bool> _getAccountInfo() async {
    ShopInfoHelper().setShopInfo();
    setData();
    return true;
  }


  getSellerPackage()async{
    var _shopInfo = await ShopRepository().getShopInfo();
    _package=_shopInfo.shopInfo.sellerPackage;
    _packageImg=_shopInfo.shopInfo.sellerPackageImg;
    print(_packageImg);
    setState(() {

    });
  }

  setData(){
    //Map<String, dynamic> json = jsonDecode(shop_info.$.toString());
    _url=shop_logo.$;
    _name=shop_name.$;
    _email=seller_email.$;
    _verify=shop_verify.$;
    _verified=_verify?"Verified":"Unverified";
    _rating=shop_rating.$;
    _faceData = true;
    setState(() {});
  }


  logoutReq()async{
    var response = await AuthRepository().getLogoutResponse();


   if(response.result){
     access_token.$="";
     access_token.save();
     is_logged_in.$=false;
     is_logged_in.save();
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Login(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }),
        (route) => false,
      );
    }else{
     ToastComponent.showDialog(response.message,
       gravity: Toast.center,
       duration: 3,
       textStyle: TextStyle(color: MyTheme.black),
     );
   }
  }

  faceData(){
    _getAccountInfo();
    getSellerPackage();
  }


  loadData()async{
    if(shop_name.$==""){
      _getAccountInfo();
    }else{
      setData();
    }
  }

    @override
  void initState() {
    if(seller_package_addon.$) {
      getSellerPackage();
    }
loadData();
      controller = AnimationController(duration: Duration(seconds: 1), vsync: this);
      animation = Tween(begin: 0.5, end: 1.0).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.app_accent_color,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // This is the back button
            buildBackButtonContainer(context),

            Container(
              color: MyTheme.app_accent_color_extra_light,
              height: 1,
            ),

            SizedBox(height: 20,),

            //header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  MyWidget.roundImageWithPlaceholder(width: 48.0,height: 48.0,borderRadius:24.0,url: _url ,backgroundColor: MyTheme.noColor),
                  /*Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://demo.activeitzone.com/ecommerce_flutter_demo/public/uploads/all/999999999920220118113113.jpg"),
                            fit: BoxFit.cover)),
                  ),*/
                 const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(""+_name.toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: MyTheme.white),),
                      Text(""+_email.toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: MyTheme.app_accent_border.withOpacity(0.8)),),
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        Image.asset('assets/icon/star.png',width: 16,height: 15,),
                        SizedBox(width: 5,),
                        Text(""+_rating,style: TextStyle(fontSize: 12,color: MyTheme.app_accent_border),),
                        SizedBox(width: 10,),
                       // MyWidget.roundImageWithPlaceholder(width: 16.0,height: 16.0,borderRadius:10.0,url: _verifiedImg ),
                        _faceData?Image.asset(_verify?'assets/icon/verify.png':'assets/icon/unverify.png',width: 16,height: 15,):Container(),
                        SizedBox(width: 5,),
                        Text(_verified,style: TextStyle(fontSize: 12,color: MyTheme.app_accent_border),),
                        seller_package_addon.$ && _package.isNotEmpty?Row(
                          children: [
                            SizedBox(width: 10,),
                            MyWidget.roundImageWithPlaceholder(width: 16.0,height: 15.0,borderRadius:0.0,url: _packageImg,backgroundColor: MyTheme.noColor,fit: BoxFit.fill   ),
                            SizedBox(width: 5,),
                            Text(_package,style: TextStyle(fontSize: 12,color: MyTheme.app_accent_border),),
                          ],
                        ):Container(),
                      ],)
                    ],
                  )
                ],
              ),
            ),


            SizedBox(height: 20,),
            Container(
              color: MyTheme.app_accent_color_extra_light,
              height: 1,
            ),
           // SizedBox(height: 20,),
            Container(
              color: MyTheme.app_accent_color,
              height: 1,
            ),
            SizedBox(height: 20,),
            buildItemFeature(context),
            SizedBox(height: 20,),
            Container(
              color: MyTheme.app_accent_color_extra_light,
              height: 1,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 80,
            alignment: Alignment.center,
            child:  Container(
              height: 40,
              child:  FlatButton(
                onPressed: (){
                  logoutReq();

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                  [
                    Row(
                      children: [
                        Image.asset('assets/icon/logout.png',width: 16,height: 16,color: MyTheme.app_accent_border,),
                        SizedBox(width: 26,),
                        Text(LangText(context: context).getLocal().drawer_logout,style: TextStyle(fontSize: 14,color: MyTheme.white),),
                      ],
                    ),
                    Icon(Icons.navigate_next_rounded,size: 20,color: MyTheme.app_accent_border,)

                  ],
                ),
              ),
            ),),
            Container(
              color: MyTheme.app_accent_color_extra_light,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  Container buildBackButtonContainer(BuildContext context) {
    return Container(
            height: 47,
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 47,
              child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 24,
                    color: MyTheme.app_accent_border,
                  ),
              ),
            ),
          );
  }

  Widget buildItemFeature(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
                    children: [
                      Container(
                        height: 40,
                        child:  FlatButton(
                          onPressed: (){
                            MyTransaction(context: context).push(ProfileEdit());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                            [
                              Row(
                                children: [
                                  Image.asset('assets/icon/profile.png',width: 16,height: 16,color: MyTheme.app_accent_border,),
                                  SizedBox(width: 26,),
                                  Text(LangText(context: context).getLocal().drawer_profile,style: TextStyle(fontSize: 14,color: MyTheme.white),),
                                ],
                              ),
                              Icon(Icons.navigate_next_rounded,size: 20,color: MyTheme.app_accent_border,)

                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        child:  FlatButton(
                          onPressed: (){
                            Navigator.pushAndRemoveUntil(context,PageRouteBuilder(pageBuilder: (context,animation,secondaryAnimation)=>Main(),transitionsBuilder: (context,animation,secondaryAnimation,child){
                              return FadeTransition(opacity:animation,child: child, );
                            }), (route) => false,);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                            [
                              Row(
                                children: [
                                  Image.asset('assets/icon/dashboard.png',width: 16,height: 16,color: MyTheme.app_accent_border,),
                                  SizedBox(width: 26,),
                                  Text(LangText(context: context).getLocal().dashboard_menu_dashboard,style: TextStyle(fontSize: 14,color: MyTheme.white),),
                                ],
                              ),
                              Icon(Icons.navigate_next_rounded,size: 20,color: MyTheme.app_accent_border,)

                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        child:  FlatButton(
                          onPressed: (){
                            MyTransaction(context: context).push(Orders());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/icon/orders.png',width: 16,height: 16,color: MyTheme.app_accent_border,),
                                  SizedBox(width: 26,),
                                  Text(LangText(context: context).getLocal().dashboard_menu_orders,style: TextStyle(fontSize: 14,color: MyTheme.white),),
                                ],
                              ),
                              Icon(Icons.navigate_next_rounded,size: 20,color: MyTheme.app_accent_border,)

                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        child:  FlatButton(
                          onPressed: (){
                            MyTransaction(context: context).push(Products());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/icon/products.png',width: 16,height: 16,color: MyTheme.app_accent_border),
                                  SizedBox(width: 26,),
                                  Text(LangText(context: context).getLocal().dashboard_menu_products,style: TextStyle(fontSize: 14,color: MyTheme.white),),
                                ],
                              ),

                              Icon(Icons.navigate_next_rounded,size: 20,color: MyTheme.app_accent_border,)
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        child:  FlatButton(
                          onPressed: (){
                            MyTransaction(context: context).push(CommissionHistory());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/icon/commission_history.png',width: 16,height: 16,color: MyTheme.app_accent_border),
                                  SizedBox(width: 26,),
                                  Text(LangText(context: context).getLocal().drawer_commission_history,style: TextStyle(fontSize: 14,color: MyTheme.white),),
                                ],
                              ),
                              Icon(Icons.navigate_next_rounded,size: 20,color: MyTheme.app_accent_border,)
                            ],
                          ),
                        ),
                      ),
                      /*
                      Container(
                        height: 40,
                        child:  FlatButton(
                          onPressed: (){
                            MyTransaction(context: context).push(UploadFile());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.upload_file,size: 16,color: MyTheme.app_accent_border,),
                                  //Image.asset('assets/icon/commission_history.png',width: 16,height: 16,color: MyTheme.app_accent_border),
                                  SizedBox(width: 26,),
                                  Text(LangText(context: context).getLocal().drawer_upload_file,style: TextStyle(fontSize: 14,color: MyTheme.white),),
                                ],
                              ),
                              Icon(Icons.navigate_next_rounded,size: 20,color: MyTheme.app_accent_border,)
                            ],
                          ),
                        ),
                      ),*/
                    ],
                  ),
    );
  }
}
