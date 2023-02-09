import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/data_model/payment_history_response.dart';
import 'package:active_ecommerce_seller_app/dummy_data/payment_history_list.dart';

import 'package:active_ecommerce_seller_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/payment_history_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key key}) : super(key: key);

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  ScrollController _scrollController = new ScrollController(initialScrollOffset: 0);

  int _page=1;
  bool _isFetchAllData= false,_showMoreProductLoadingContainer = false;


  List<Payment> _payments = [];

 Future<bool> getPaymentHistory()async{

    var response = await PaymentHistoryRepository().getList(page: _page);

    _payments.addAll(response.data);
    setState(() {});

    return true;

  }

  fetchData()async{
   await getPaymentHistory();
   _isFetchAllData= true;
   setState(() {

   });

  }

  clearAllData(){
    _scrollController = new ScrollController(initialScrollOffset: 0);
    _page=1;
     _isFetchAllData= false;
    _payments = [];
    setState(() {
    });
  }

  resetData(){
    clearAllData();
    fetchData();
  }


  Future<void> refresh(){
    resetData();
    return Future.delayed(const Duration(seconds: 1));
  }

  scrollControllerPosition(){

    _scrollController.addListener(() {
      print("po");
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {

        _showMoreProductLoadingContainer = true;
        setState(() {
          _page++;
        });
        getPaymentHistory();
      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    scrollControllerPosition();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
              title: AppLocalizations.of(context).drawer_payment_history,
              context: context)
          .show(),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  children: [

                    Container(
                      child:_isFetchAllData? paymentHistoryContainer():ShimmerHelper().buildListShimmer(item_count: 20,item_height: 80.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentHistoryContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _payments.length+1,
              shrinkWrap: true,
              itemBuilder: (context,index){
                // print(index);
                if(index==_payments.length){
                  return moreProductLoading();
                }
                return
                  productItem(index,_payments[index].paymentMethod,_payments[index].paymentDate,_payments[index].amount.toString());
              }),
        ],
      ),
    );

  }

  Container productItem(int index,String paymentMethod,paymentDate,String amount){
    return MyWidget.customCardView(
      backgroundColor: MyTheme.white,
      elevation: 5,
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        width: DeviceInfo(context).getWidth(),
        margin: EdgeInsets.only(bottom: 20,top: index==0?20:0),
        borderColor: MyTheme.light_grey,
        alignment: Alignment.center,
        borderRadius: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(paymentMethod,style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: MyTheme.app_accent_color),maxLines: 1,overflow: TextOverflow.ellipsis,),
                SizedBox(height: 5,),
                Container(
                  width: DeviceInfo(context).getWidth()/3,
                  child: Row(
                    children: [
                      Image.asset("assets/icon/calender.png",width: 12,height: 12,),
                      SizedBox(width: 8,),
                      Text(paymentDate,style: TextStyle(fontSize: 12,color: MyTheme.grey_153,),maxLines:1,overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ],
            ),
            Text(amount,style: TextStyle(fontSize: 16,color: MyTheme.app_accent_color,fontWeight: FontWeight.w500)),
          ],
        )
    );
  }


  Widget moreProductLoading() {
    return _showMoreProductLoadingContainer? Container(
      alignment: Alignment.center,
      child: SizedBox(height: 40,width: 40,child: Row(
        children: [
          SizedBox(width: 2,height: 2,),
          CircularProgressIndicator(),
          SizedBox(width: 2,height: 2,),
        ],
      ),),
    ):SizedBox(height: 5,width: 5,);
  }

}
