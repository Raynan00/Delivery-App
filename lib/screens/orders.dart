import 'package:active_ecommerce_seller_app/const/DeliveryStatus.dart';
import 'package:active_ecommerce_seller_app/const/PaymentStatus.dart';
import 'package:active_ecommerce_seller_app/const/app_style.dart';
import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/order_repository.dart';
import 'package:active_ecommerce_seller_app/screens/order_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shimmer/shimmer.dart';

class Orders extends StatefulWidget {
  final bool fromBottomBar;

  const Orders({Key key, this.fromBottomBar = false}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();

  List<PaymentStatus> _paymentStatusList = PaymentStatus.getPaymentStatusList();
  List<DeliveryStatus> _deliveryStatusList =
  DeliveryStatus.getDeliveryStatusList();

  PaymentStatus _selectedPaymentStatus;
  DeliveryStatus _selectedDeliveryStatus;

  List<DropdownMenuItem<PaymentStatus>> _dropdownPaymentStatusItems;
  List<DropdownMenuItem<DeliveryStatus>> _dropdownDeliveryStatusItems;

  //------------------------------------
  List<dynamic> _orderList = [];
  bool _isInitial = true;
  int _page = 1;
  int _totalData = 0;
  bool _showLoadingContainer = false;
  String _defaultPaymentStatusKey = '';
  String _defaultDeliveryStatusKey = '';

  @override
  void initState() {
    init();
    super.initState();

    fetchData();

    _xcrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //_scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  init() {
    _dropdownPaymentStatusItems =
        buildDropdownPaymentStatusItems(_paymentStatusList);

    _dropdownDeliveryStatusItems =
        buildDropdownDeliveryStatusItems(_deliveryStatusList);

    for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
      if (_dropdownPaymentStatusItems[x].value.option_key ==
          _defaultPaymentStatusKey) {
        _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value;
      }
    }

    for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
      if (_dropdownDeliveryStatusItems[x].value.option_key ==
          _defaultDeliveryStatusKey) {
        _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value;
      }
    }
  }

  reset() {
    _orderList.clear();
    _isInitial = true;
    _page = 1;
    _totalData = 0;
    _showLoadingContainer = false;
  }

  resetFilterKeys() {
    _defaultPaymentStatusKey = '';
    _defaultDeliveryStatusKey = '';

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    resetFilterKeys();
    for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
      if (_dropdownPaymentStatusItems[x].value.option_key ==
          _defaultPaymentStatusKey) {
        _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value;
      }
    }

    for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
      if (_dropdownDeliveryStatusItems[x].value.option_key ==
          _defaultDeliveryStatusKey) {
        _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value;
      }
    }
    setState(() {});
    fetchData();
  }

  fetchData() async {
    var orderResponse = await OrderRepository().getOrderList(
        page: _page,
        payment_status: _selectedPaymentStatus.option_key,
        delivery_status: _selectedDeliveryStatus.option_key);
    //print("or:"+orderResponse.toJson().toString());
    _orderList.addAll(orderResponse.data);
    _isInitial = false;
    _totalData = orderResponse.meta.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  List<DropdownMenuItem<PaymentStatus>> buildDropdownPaymentStatusItems(
      List _paymentStatusList) {
    List<DropdownMenuItem<PaymentStatus>> items = List();
    for (PaymentStatus item in _paymentStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<DeliveryStatus>> buildDropdownDeliveryStatusItems(
      List _deliveryStatusList) {
    List<DropdownMenuItem<DeliveryStatus>> items = List();
    for (DeliveryStatus item in _deliveryStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.end,
          children: [
           buildTopSection(context),
            buildOrderListList(),
          ],
        ));
  }

  Column buildTopSection(BuildContext context) {
    return Column(
            children: [
              buildAppBar(context),
              buildFilterSection(context),
            ],
          );
  }

  Visibility buildAppBar(BuildContext context) {
    return Visibility(
                  visible: !widget.fromBottomBar,
                  child: SizedBox(
                    height: AppBar().preferredSize.height + 20,
                    child: MyAppBar(

                        context: context,
                        title:
                        LangText(context: context)
                            .getLocal()
                            .drawer_orders)
                        .show(),
                  ));
  }

  buildOrderListList() {
    // if ( _isInitial && _orderList.length == 0) {
    //   return buildOrderShimmer();
    // }
    return RefreshIndicator(
      color: MyTheme.app_accent_color,
      backgroundColor: Colors.white,
      displacement:0,
      onRefresh: _onRefresh,
      child:
      _isInitial && _orderList.length == 0?buildOrderShimmer():
      Container(
        height: DeviceInfo(context).getHeight()-((widget.fromBottomBar?100:78)+AppBar().preferredSize.height),
        child: CustomScrollView(
          controller: _xcrollController,
          slivers: [
            SliverToBoxAdapter(
              child:  _orderList.length > 0
                  ? ListView.separated(
                separatorBuilder:(context,index) {
                  return SizedBox(height: 20,);
                },
                padding: EdgeInsets.only(
                  top: 20,
                    left: AppStyles.layoutMargin,
                    right: AppStyles.layoutMargin,
                  bottom: widget.fromBottomBar?95:15,
                ),
                // physics: const BouncingScrollPhysics(
                //     parent: AlwaysScrollableScrollPhysics()),

                itemCount: _orderList.length,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(
                    parent: NeverScrollableScrollPhysics()),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return OrderDetails(
                              id: _orderList[index].id,
                            );
                          }));
                    },
                    child: buildOrderListItemCard(index),
                  );
                },
              )
                  : SizedBox(
                height: DeviceInfo(context).getHeight() -
                    (AppBar().preferredSize.height + 75),
                child: Center(
                    child: Text(LangText(context: context)
                        .getLocal()
                        .common_no_data_available)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildOrderShimmer() {
    return Container(
      height: DeviceInfo(context).getHeight() -
          (AppBar().preferredSize.height + 90),
      child: SingleChildScrollView(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 10,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Shimmer.fromColors(
                  baseColor: MyTheme.shimmer_base,
                  highlightColor: MyTheme.shimmer_highlighted,
                  child: Container(
                    height: 75,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget buildOrderListItemCard(int index) {
    return MyWidget.customCardView(

      alignment: Alignment.center,
      backgroundColor: MyTheme.app_accent_color_extra_light,
      width: DeviceInfo(context).getWidth(),
      elevation: 5.0,
      borderRadius: 10,
      height: 120,
      borderColor: MyTheme.app_accent_border,
      borderWidth: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _orderList[index].orderCode,
                    style: TextStyle(
                        color: MyTheme.app_accent_color,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: app_language_rtl.$
                            ? const EdgeInsets.only(left: 8.0)
                            : const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: MyTheme.font_grey,
                        ),
                      ),
                      Text(_orderList[index].orderDate,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: app_language_rtl.$
                            ? const EdgeInsets.only(left: 8.0)
                            : const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.credit_card,
                          size: 16,
                          color: MyTheme.font_grey,
                        ),
                      ),
                      Text(
                          "${LangText(context: context)
                              .getLocal()
                              .order_list_screen_payment_status} - ",
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                      Text(
                          _orderList[index]
                              .paymentStatus
                              .toString()
                              .replaceRange(
                              0,
                              1,
                              _orderList[index]
                                  .paymentStatus
                                  .toString()
                                  .characters
                                  .first
                                  .toString()
                                  .toUpperCase()),
                          style: TextStyle(
                              color: _orderList[index].paymentStatus == "paid"
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      /*Padding(
                        padding: app_language_rtl.$
                            ? const EdgeInsets.only(right: 8.0)
                            : const EdgeInsets.only(left: 8.0),
                        child: buildPaymentStatusCheckContainer(
                            _orderList[index].paymentStatus),
                      ),*/
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: app_language_rtl.$
                          ? const EdgeInsets.only(left: 8.0)
                          : const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.local_shipping_outlined,
                        size: 16,
                        color: MyTheme.font_grey,
                      ),
                    ),
                    Text(
                        "${LangText(context: context)
                            .getLocal()
                            .order_list_screen_delivery_status} -",
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400)),
                    Text(_orderList[index].deliveryStatus,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ],
            ),
            Text(
              _orderList[index].total,
              style: TextStyle(
                  color: MyTheme.app_accent_color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

/*
  Container buildPaymentStatusCheckContainer(String payment_status) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: payment_status == "paid" ? Colors.green : Colors.red),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(
            payment_status == "paid" ? FontAwesome.check : FontAwesome.times,
            color: Colors.white,
            size: 10),
      ),
    );
  }
  */
  buildFilterSection(BuildContext context) {
    return Container(

        margin: EdgeInsets.only(top: 10),
        height: 40,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppStyles.layoutMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyWidget.customCardView(
                borderRadius: 6,
                elevation: 5,
                borderColor: MyTheme.light_grey,
                backgroundColor: Colors.white,

                // decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(6.0),
                //     border: Border.all(color: MyTheme.light_grey)
                //     /* border: Border.symmetric(
                //       vertical:
                //           BorderSide(color: MyTheme.light_grey, width: .5),
                //       horizontal:
                //           BorderSide(color: MyTheme.light_grey, width: 1))*/
                //     ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 36,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * .42,
                child: new DropdownButton<PaymentStatus>(
                  isExpanded: true,
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.expand_more, color: Colors.black54),
                  ),
                  hint: Text(
                    LangText(context: context)
                        .getLocal()
                        .order_list_screen_all,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  iconSize: 14,
                  underline: SizedBox(),
                  value: _selectedPaymentStatus,
                  items: _dropdownPaymentStatusItems,
                  onChanged: (PaymentStatus selectedFilter) {
                    setState(() {
                      _selectedPaymentStatus = selectedFilter;
                    });
                    reset();
                    fetchData();
                  },
                ),
              ),
              MyWidget.customCardView(
                borderRadius: 6,
                elevation: 5,
                borderColor: MyTheme.light_grey,
                backgroundColor: MyTheme.white,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 36,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * .42,
                child: new DropdownButton<DeliveryStatus>(
                  isExpanded: true,
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(Icons.expand_more, color: Colors.black54),
                  ),
                  hint: Text(
                    LangText(context: context)
                        .getLocal()
                        .order_list_screen_all,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  iconSize: 14,
                  underline: SizedBox(),
                  value: _selectedDeliveryStatus,
                  items: _dropdownDeliveryStatusItems,
                  onChanged: (DeliveryStatus selectedFilter) {
                    setState(() {
                      _selectedDeliveryStatus = selectedFilter;
                    });
                    reset();
                    fetchData();
                  },
                ),
              ),
              /*MyWidget().myContainer(
              borderRadius: 6.0,
              borderColor: MyTheme.light_grey,
              height: 36,
              width: 36,
              child: IconButton(
                splashRadius: 20,
                  onPressed: (){
              }, icon: Image.asset('assets/icon/search.png',width:16,height:16)),
            )*/
            ],
          ),
        ));
  }
}
