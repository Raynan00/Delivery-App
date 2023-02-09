import 'package:active_ecommerce_seller_app/const/app_style.dart';
import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/loading.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/data_model/commission_history_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/commission_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommissionHistory extends StatefulWidget {
  const CommissionHistory({Key key}) : super(key: key);

  @override
  _CommissionHistoryState createState() => _CommissionHistoryState();
}

class _CommissionHistoryState extends State<CommissionHistory> {
  List<Commission> _commission = [];
  bool _isFetchAllData=false;
  bool _showMoreCommissionLoading=false;
  ScrollController _scrollController = new ScrollController(initialScrollOffset: 0);
  int _page =1;


  Future<bool> getCommissionList() async {
    var response = await CommissionRepository().getList(page: _page);
    _commission.addAll(response.data);
    _showMoreCommissionLoading=false;
    setState(() {});
    return true;
  }
  
 Future<bool> fetchData() async{
  await  getCommissionList();
  _isFetchAllData = true;
    setState(() {
    });
    return true;
  }
  
  clearData() {
    _scrollController = new ScrollController(initialScrollOffset: 0);
    _page=1;
    _isFetchAllData= false;
    _commission = [];
    setState(() {
    });
  }

 Future<bool> resetData() {
    clearData();
   return fetchData();
  }

 Future<void>refresh()async{
    await resetData();
    return Future.delayed(const Duration(seconds: 0));
  }


  scrollControllerPosition(){

    _scrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {

        _showMoreCommissionLoading = true;
        setState(() {
          _page++;
        });
        getCommissionList();
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
              title: AppLocalizations.of(context).drawer_commission_history,
              context: context)
          .show(),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                child: _isFetchAllData
                    ? commissionListContainer()
                    : ShimmerHelper()
                        .buildListShimmer(item_count: 20, item_height: 80.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commissionListContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _commission.length+1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // print(index);
                if(index==_commission.length){
                  return Loading.bottomLoading(_showMoreCommissionLoading);
                }
                return commissionItem(
                  index,
                    _commission[index].orderCode,
                    _commission[index].adminCommission.toString(),
                    _commission[index].createdAt,
                    _commission[index].sellerEarning.toString());
              }),
        ],
      ),
    );
  }

  Container commissionItem(int index,String orderCode,String adminCommission,String date,String sellerEarning){
    return MyWidget.customCardView(
      backgroundColor: MyTheme.app_accent_color_extra_light,
      elevation: 5,
        height: 90,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 14),
        width: DeviceInfo(context).getWidth(),
        margin: EdgeInsets.only(bottom: 20,top: index==0?20:0),
        borderColor: MyTheme.light_grey,
        borderRadius: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(orderCode,style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: MyTheme.app_accent_color),maxLines: 1,overflow: TextOverflow.ellipsis,),
            SizedBox(height: 5,),
            Container(
              width: DeviceInfo(context).getWidth(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: DeviceInfo(context).getWidth()/2,
                    child: Row(
                      children: [
                        Text(LangText(context: context).getLocal().commission_history_screen_admin_commission+" : "+adminCommission,style: TextStyle(fontSize: 12,color: MyTheme.app_accent_color,),maxLines:1,overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),

                  Text(sellerEarning,style: TextStyle(fontSize: 16,color: MyTheme.app_accent_color,fontWeight: AppStyles.bold,)),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Container(
              width: DeviceInfo(context).getWidth()/3,
              child: Row(
                children: [
                  Image.asset("assets/icon/calender.png",width: 12,height: 12,),
                  SizedBox(width: 8,),
                  Text(date,style: TextStyle(fontSize: 12,color: MyTheme.grey_153,),maxLines:1,overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),
          ],
        )
    );
  }

}
