import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/loading.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/route_transaction.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/data_model/coupon_list_response.dart';
import 'package:active_ecommerce_seller_app/dummy_data/coupons.dart';
import 'package:active_ecommerce_seller_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/coupon_repository.dart';
import 'package:active_ecommerce_seller_app/screens/coupon/edit_coupon.dart';
import 'package:active_ecommerce_seller_app/screens/coupon/new_coupon.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Coupons extends StatefulWidget {
  const Coupons({Key key}) : super(key: key);

  @override
  State<Coupons> createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  List<Coupon> _coupons = [];
  Loading _loading = Loading();
  bool _faceData=false;


  getCouponList() async {
    var response = await CouponRepository().getCoupons();
    _coupons.addAll(response.data);
    print(_coupons.isEmpty);
    _faceData=true;
    setState(() {});
  }

  deleteCoupon(String id)async{
    _loading.show(context);
    var response =await CouponRepository().deleteCoupon(id);
    _loading.hide();
   if (response.result){
     ToastComponent.showDialog(response.message,backgroundColor: MyTheme.white,textStyle:TextStyle(color:MyTheme.black) ,gravity: Toast.center,duration: Toast.lengthLong);
     refresh();
   }

  }

  fetchData() {
    getCouponList();
  }

  clearData() {
    _coupons = [];
    _faceData=false;
  }

 Future<bool> resetData() async{
    clearData();
    fetchData();
    setState(() {});
    return true;
  }

 Future<void> refresh()async {
    await resetData();
    return Future.delayed(Duration(seconds: 1));
  }



  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MyAppBar(
              context: context,
              title: LangText(context: context).getLocal().dashboard_coupons)
          .show(),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  SizedBox(
                    height:20,
                  ),
                  buildAddCouponContainer(context),
                  SizedBox(
                    height: 20,
                  ),
                   _faceData?_coupons.isEmpty?Center(child: Text(LangText(context: context).getLocal().common_no_more_Data),):
                   buildCouponsListView():buildShimmerList(context),

                ],
              )),
        ),
      ),
    );
  }

  Widget buildShimmerList(BuildContext context) {
    return Column(
      children: List.generate(
          8,
          (index) => Container(
            margin: EdgeInsets.only(bottom: 20),
              child:ShimmerHelper().buildBasicShimmer(
              height: 96, width: DeviceInfo(context).getWidth()))),
    );
  }

  ListView buildCouponsListView() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _coupons.length,
        itemBuilder: (context, index) {
          return buildCouponItem(index);
        });
  }

  Widget buildCouponItem(int index) {
    return MyWidget.customCardView(
      backgroundColor: MyTheme.white,
      elevation: 5,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 96,
      width: DeviceInfo(context).getWidth(),
      borderColor: MyTheme.light_grey,
      borderRadius: 10,
      child: Row(
        children: [
          Container(
            width: DeviceInfo(context).getWidth() - 85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _coupons[index].code,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: MyTheme.app_accent_color),
                    ),
                    Text(
                      _coupons[index].type,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: MyTheme.app_accent_color),
                    ),
                  ],
                ),
                Text(
                  _coupons[index].startDate+"-"+_coupons[index].startDate,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: MyTheme.grey_153),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  MyTransaction(context: context).push(EditCoupon(id:_coupons[index].id.toString())).then((value) => refresh());
                },
                child: MyWidget.customCardView(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  borderRadius: 15,
                  height:30,
                  width: 30,
                  backgroundColor: MyTheme.app_accent_color,
                  child: Image.asset(
                    'assets/icon/edit.png',
                    width: 10,
                    height: 10,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showDeleteWarningDialog(_coupons[index].id.toString());

                },
                child: MyWidget.customCardView(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  borderRadius: 15,
                  height:30,
                  width: 30,
                  backgroundColor: MyTheme.app_accent_color,
                  child: Image.asset(
                    'assets/icon/delete.png',
                    width: 10,
                    height: 10,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildAddCouponContainer(BuildContext context) {
    return InkWell(
      onTap: () {
        MyTransaction(context: context).push(NewCoupon()).then((value) {
            refresh();
        });
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
                    .coupons_screen_add_new_coupon,
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

  showDeleteWarningDialog(id){
    showDialog(context: context, builder: (context)=>Container(
      width: DeviceInfo(context).getWidth()*1.5,
      child: AlertDialog(
        title: Text(LangText(context: context).getLocal().common_warning,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: MyTheme.red),),
        content: Text(LangText(context: context).getLocal().common_delete_warning_text,style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
        actions: [
          FlatButton(
              color: MyTheme.app_accent_color,
              onPressed: (){
                Navigator.pop(context);
              }, child: Text(LangText(context: context).getLocal().common_no,style: TextStyle(color: MyTheme.white,fontSize: 12),)),
          FlatButton(
              color: MyTheme.app_accent_color,
              onPressed: (){
                Navigator.pop(context);
                deleteCoupon(id);
              }, child: Text(LangText(context: context).getLocal().common_yes,style: TextStyle(color: MyTheme.white,fontSize: 12))),
        ],
      ),
    ));
  }
}
