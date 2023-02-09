import 'package:active_ecommerce_seller_app/const/app_style.dart';
import 'package:active_ecommerce_seller_app/custom/common_style.dart';
import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/route_transaction.dart';
import 'package:active_ecommerce_seller_app/custom/submitButton.dart';
import 'package:active_ecommerce_seller_app/data_model/shop_info_response.dart';
import 'package:active_ecommerce_seller_app/data_model/shop_response.dart';
import 'package:active_ecommerce_seller_app/data_model/withdraw_list_response.dart';
import 'package:active_ecommerce_seller_app/dummy_data/withdrawList.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/shop_repository.dart';
import 'package:active_ecommerce_seller_app/repositories/withdraw_repository.dart';
import 'package:active_ecommerce_seller_app/screens/withdraw_req.dart';
import 'package:flutter/material.dart';

class MoneyWithdraw extends StatefulWidget {
  const MoneyWithdraw({Key key}) : super(key: key);

  @override
  State<MoneyWithdraw> createState() => _MoneyWithdrawState();
}

class _MoneyWithdrawState extends State<MoneyWithdraw> {
  List<Withdraw> _withdraws = [];

  ShopInfo _shop;

  bool _isLoadData = false;
  bool _isLoadShop = false;
  int _page = 1;

  Future<bool> getReviews() async {
    var response = await WithdrawRepository().getList(_page);
    _withdraws.addAll(response.data);
    _isLoadData = true;

    setState(() {});
    return true;
  }

  Future<bool> getShop() async {
    var response = await ShopRepository().getShopInfo();
    _shop = response.shopInfo;
    _isLoadShop = true;
    setState(() {});
    return true;
  }

  fetchData() async {
    await getReviews();
    await getShop();
  }

  clearData() async {
    _withdraws = [];
    _isLoadData = false;
    _shop = null;
    _isLoadShop = false;
    setState(() {});
  }

  Future<void> reFresh() async {
    clearData();
    await fetchData();
    return Future.delayed(const Duration(microseconds: 100));
  }

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: MyAppBar(
                context: context,
                title: LangText(context: context)
                    .getLocal()
                    .dashboard_money_withdraw)
            .show(),
        body: LayoutBuilder(builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: reFresh,
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        buildTop2BoxContainer(context),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: _isLoadData
                              ? withdrawListContainer()
                              : ShimmerHelper().buildListShimmer(
                                  item_count: 15, item_height: 80.0),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }/*

  SingleChildScrollView buildSingleChildScrollView(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        child: Column(
          children: [
            buildTop2BoxContainer(context),
            SizedBox(
              height: 20,
            ),
            Container(
              child: _isLoadData
                  ? productsContainer()
                  : ShimmerHelper()
                      .buildListShimmer(item_count: 20, item_height: 80.0),
            ),
          ],
        ),
      ),
    );
  }*/

  Container buildTop2BoxContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(

        children: [
          MyWidget.customCardView(
              padding: EdgeInsets.all(10),
              //decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              //   //border: Border.all(color: MyTheme.app_accent_border),
              //   color: MyTheme.app_accent_color,
              // ),
              borderRadius: 10,
              backgroundColor: MyTheme.app_accent_color,
              elevation: 5,
              height: 75,
              width: DeviceInfo(context).getWidth() / 2 - 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    LangText(context: context)
                        .getLocal()
                        .money_withdraw_screen_pending_balance,
                    style: MyTextStyle().dashboardBoxText(context),
                  ),
                  Text(
                    _isLoadShop ? _shop.adminToPay.toString() : "...",
                    style: MyTextStyle().dashboardBoxNumber(context),
                  ),
                ],
              )),
          SizedBox(width: AppStyles.itemMargin,),
          SubmitBtn.show(
            elevation: 5,
            alignment: Alignment.center,
              radius: 10,
              borderColor: MyTheme.app_accent_color,
              onTap: () {
                MyTransaction(context: context)
                    .push(SendAWithdrwRequest())
                    .then((value) {
                  reFresh();
                });
              },
              backgroundColor: MyTheme.app_accent_color_extra_light,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              //   border: Border.all(color: MyTheme.app_accent_color),
              //   color: MyTheme.app_accent_color_extra_light,
              // ),
              height: 75,
              width: DeviceInfo(context).getWidth() / 2 - 25,
              child: Container(
                height: 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      LangText(context: context)
                          .getLocal()
                          .money_withdraw_screen_send_withdraw_request,
                      style: MyTextStyle()
                          .dashboardBoxText(context)
                          .copyWith(color: MyTheme.app_accent_color),
                    ),
                    Image.asset(
                      'assets/icon/add.png',
                      color: MyTheme.app_accent_color,
                      height: 18,
                      width: 18,
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget withdrawListContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _withdraws.length + 1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // print(index);
                if (index == _withdraws.length) {
                  return SizedBox(
                    height: 80,
                  );
                }
                return withdrawItem(index, _withdraws[index].status,
                    _withdraws[index].createdAt, _withdraws[index].amount);
              }),
        ],
      ),
    );
  }

  Container withdrawItem(
      int id, String withdrawStatus, withdrawCreatedAt, String withdrawPrice) {
    return MyWidget.customCardView(
      backgroundColor: MyTheme.white,
      alignment: Alignment.center,
      elevation: 5,
        height: 90,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        width: DeviceInfo(context).getWidth(),
        margin: EdgeInsets.only(bottom: 20),
        borderColor: MyTheme.light_grey,
        borderRadius: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: DeviceInfo(context).getWidth() - 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    withdrawStatus,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color:withdrawStatus=="Pending"?MyTheme.grey_153: MyTheme.app_accent_color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/icon/calender.png",
                        width: 12,
                        height: 12,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        withdrawCreatedAt,
                        style: TextStyle(
                          fontSize: 12,
                          color: MyTheme.grey_153,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(withdrawPrice,
                style:
                    TextStyle(fontSize: 16,fontWeight: AppStyles.bold, color: MyTheme.app_accent_color)),
          ],
        ));
  }
}
