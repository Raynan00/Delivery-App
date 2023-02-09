import 'package:active_ecommerce_seller_app/const/DeliveryStatus.dart';
import 'package:active_ecommerce_seller_app/const/PaymentStatus.dart';
import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/loading.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/data_model/order_detail_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/order_repository.dart';
import 'package:active_ecommerce_seller_app/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:one_context/one_context.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';

class OrderDetails extends StatefulWidget {
  int id;
  bool go_back;

  OrderDetails({Key key, this.id, this.go_back = true}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  ScrollController _mainScrollController = ScrollController();
  var _steps = [
    'pending',
    'confirmed',
    'on_delivery',
    'picked_up',
    'on_the_way',
    'delivered'
  ];

  TextEditingController _refundReasonController = TextEditingController();

  //init
  int _stepIndex = 0;
  var _orderDetails = null;

  bool _orderItemsInit = false;
  bool _showReasonWarning = false;
  bool Order = true;

  List<DropdownMenuItem<PaymentStatus>> _dropdownPaymentStatusItems;
  List<DropdownMenuItem<DeliveryStatus>> _dropdownDeliveryStatusItems;
  PaymentStatus _selectedPaymentStatus;
  DeliveryStatus _selectedDeliveryStatus;

  Loading loading = Loading();

  //= DeliveryStatus('pending', LangText(context: OneContext().context).getLocal().order_list_screen_pending);

  List<PaymentStatus> _paymentStatusList =
      PaymentStatus.getPaymentStatusListForUpdater();
  List<DeliveryStatus> _deliveryStatusList =
      DeliveryStatus.getDeliveryStatusListForUpdate();

  @override
  void initState() {
    fetchAll();
    super.initState();

    print(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchAll() {
    _dropdownPaymentStatusItems =
        buildDropdownPaymentStatusItems(_paymentStatusList);

    _dropdownDeliveryStatusItems =
        buildDropdownDeliveryStatusItems(_deliveryStatusList);
    _selectedDeliveryStatus = _deliveryStatusList[0];
    fetchOrderDetails();
  }

  fetchOrderDetails() async {
    _selectedPaymentStatus = _paymentStatusList.first;
    var orderDetailsResponse =
        await OrderRepository().getOrderDetails(id: widget.id);

    if (orderDetailsResponse.data.length > 0) {
      _orderDetails = orderDetailsResponse.data[0];
      //_selectedDeliveryStatus=
      _deliveryStatusList.forEach((element) {
        if (element.option_key == _orderDetails.deliveryStatus) {
          _selectedDeliveryStatus = element;
        }
      });
      _paymentStatusList.forEach((element) {
        if (element.option_key == _orderDetails.paymentStatus) {
          _selectedPaymentStatus = element;
        }
      });
      //Order = !_orderDetails.manualPayment;
    }
    setState(() {});
  }

  setStepIndex(key) {
    _stepIndex = _steps.indexOf(key);
    setState(() {});
  }

  reset() {
    _stepIndex = 0;
    _orderDetails = null;
    _orderItemsInit = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  _updateDeliveryStatus(String status) async {
    loading.show(context);
    var response = await OrderRepository().updateDeliveryStatus(
        id: widget.id,
        status: status,
        paymentType: _orderDetails.paymentMethod);
    ToastComponent.showDialog(response.message,
        gravity: Toast.center, duration: Toast.lengthLong);

    loading.hide();
  }

  _updatePaymentStatus(String status) async {
    loading.show(context);
    var response = await OrderRepository()
        .updatePaymentStatus(id: widget.id, status: status);
    loading.hide();
    ToastComponent.showDialog(response.message,
        gravity: Toast.center, duration: Toast.lengthLong);
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(
          context: context,
          title: LangText(context: context)
              .getLocal()
              .order_details_screen_order_details,
        ).show(),
        body: RefreshIndicator(
          color: MyTheme.app_accent_color,
          backgroundColor: Colors.white,
          onRefresh: _onPageRefresh,
          child: CustomScrollView(
            controller: _mainScrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverToBoxAdapter(
                child: !seller_product_manage_admin.$
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(
                                LangText(context: context)
                                    .getLocal()
                                    .order_list_screen_payment_status,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: MyTheme.font_grey),
                              ),
                              width: DeviceInfo(context).getWidth() / 2 - 20,
                            ),
                            Container(
                              child: Text(
                                LangText(context: context)
                                    .getLocal()
                                    .order_list_screen_delivery_status,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: MyTheme.font_grey),
                              ),
                              width: DeviceInfo(context).getWidth() / 2 - 20,
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ),
              SliverToBoxAdapter(
                child: !seller_product_manage_admin.$
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _orderDetails != null
                            ? buildPaymentAndDeliveryChangeSection(context)
                            : buildTimeLineShimmer())
                    : Container(),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _orderDetails != null
                      ? buildOrderDetailsTopCard()
                      : ShimmerHelper().buildBasicShimmer(height: 150.0),
                ),
              ])),
              SliverList(
                  delegate: SliverChildListDelegate([
                Center(
                  child: Text(
                    LangText(context: context)
                        .getLocal()
                        .order_details_screen_ordered_product,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                buildOrderedProductSection(context)
              ])),
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 75,
                      ),
                      buildBottomSection()
                    ],
                  ),
                )
              ])),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderedProductSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _orderDetails != null
          ? buildOrderedProductList()
          : ShimmerHelper().buildBasicShimmer(height: 150.0),
      // _orderedItemList.length == 0 && _orderItemsInit
      //     ? ShimmerHelper().buildBasicShimmer(height: 100.0)
      //     : (_orderedItemList.length > 0
      //         ? buildOrderedProductList()
      //         : Container(
      //             height: 100,
      //             child: Text(
      //               LangText(context: context)
      //                   .getLocal()
      //                   .order_details_screen_ordered_product,
      //               style: TextStyle(color: MyTheme.font_grey),
      //             ),
      //           )),
    );
  }

  buildBottomSection() {
    return Expanded(
      child: _orderDetails != null
          ? Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            LangText(context: context)
                                .getLocal()
                                .order_details_screen_sub_total,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.subtotal,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            LangText(context: context)
                                .getLocal()
                                .order_details_screen_tax,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.tax,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            LangText(context: context)
                                .getLocal()
                                .order_details_screen_shipping_cost,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.shippingCost,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            LangText(context: context)
                                .getLocal()
                                .order_details_screen_discount,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.couponDiscount,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            LangText(context: context)
                                .getLocal()
                                .order_details_screen_grand_total,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.total,
                          style: TextStyle(
                              color: MyTheme.app_accent_color,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            )
          : ShimmerHelper().buildBasicShimmer(height: 100.0),
    );
  }

  buildTimeLineShimmer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 20, width: 250.0),
        )
      ],
    );
  }

  /*buildTimeLineTiles() {
    print(_orderDetails.delivery_status);
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isFirst: true,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _orderDetails.delivery_status == "pending" ? 36 : 30,
                    height:
                        _orderDetails.delivery_status == "pending" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.redAccent, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.list_alt,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      LangText(context: context).getLocal()
                          .order_details_screen_timeline_tile_order_placed,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 0 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 0
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            afterLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails.delivery_status == "confirmed" ? 36 : 30,
                    height:
                        _orderDetails.delivery_status == "confirmed" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.thumb_up_sharp,
                      color: Colors.blue,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      LangText(context: context).getLocal()
                          .order_details_screen_timeline_tile_confirmed,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 1 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 1
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _orderDetails.delivery_status == "on_delivery"
                        ? 36
                        : 30,
                    height: _orderDetails.delivery_status == "on_delivery"
                        ? 36
                        : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.amber, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      LangText(context: context).getLocal()
                          .order_details_screen_timeline_tile_on_delivery,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 2 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 2
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 5
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isLast: true,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails.delivery_status == "delivered" ? 36 : 30,
                    height:
                        _orderDetails.delivery_status == "delivered" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.purple, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.done_all,
                      color: Colors.purple,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      LangText(context: context).getLocal()
                          .order_details_screen_timeline_tile_delivered,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 5 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 5
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 5
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
        ],
      ),
    );
  }*/

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

  buildPaymentAndDeliveryChangeSection(BuildContext context) {
    return Container(
      color: MyTheme.white,
      height: 40,
      child: Row(
        mainAxisAlignment:
            Order ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
        children: [
          Order
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(color: MyTheme.light_grey)
                      /* border: Border.symmetric(
                vertical:
                BorderSide(color: MyTheme.light_grey, width: .5),
                horizontal:
                BorderSide(color: MyTheme.light_grey, width: 1))*/
                      ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: 36,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: DropdownButton<PaymentStatus>(
                    isExpanded: true,
                    icon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.expand_more, color: Colors.black54),
                    ),
                    hint: Text(
                      _selectedPaymentStatus.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    iconSize: 14,
                    underline: SizedBox(),
                    value: _selectedPaymentStatus.option_key == "paid"
                        ? null
                        : _selectedPaymentStatus,
                    items: _selectedPaymentStatus.option_key == "paid"
                        ? null
                        : _dropdownPaymentStatusItems,
                    onChanged: (PaymentStatus selectedFilter) {
                      setState(() {
                        _selectedPaymentStatus = selectedFilter;
                      });
                      _updatePaymentStatus(_selectedPaymentStatus.option_key);
                    },
                  ),
                )
              : Container(),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(color: MyTheme.light_grey)
                /* border: Border.symmetric(
                    vertical:
                        BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))*/
                ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 36,
            width: MediaQuery.of(context).size.width / 2 - 20,
            child: DropdownButton<DeliveryStatus>(
              isExpanded: true,
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Icon(Icons.expand_more, color: Colors.black54),
              ),
              hint: Text(
                _selectedDeliveryStatus.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              iconSize: 14,
              underline: SizedBox(),
              value: _selectedDeliveryStatus.option_key == "cancelled"
                  ? null
                  : _selectedDeliveryStatus,
              items: _selectedDeliveryStatus.option_key == "cancelled" ||
                      _selectedDeliveryStatus.option_key == "delivered"
                  ? null
                  : _dropdownDeliveryStatusItems,
              onChanged: (DeliveryStatus selectedFilter) {
                setState(() {
                  _selectedDeliveryStatus = selectedFilter;
                });
                //changeDeliveryStatus(selectedFilter.option_key);
                _updateDeliveryStatus(_selectedDeliveryStatus.option_key);
              },
            ),
          ),
        ],
      ),
    );
  }

  Card buildOrderDetailsTopCard() {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Order Code",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Shipping Method",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 2),
              child: Row(
                children: [
                  Text(
                    _orderDetails.orderCode,
                    style: TextStyle(
                        color: MyTheme.app_accent_color,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.shippingType,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Order Date",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Payment Method",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 2),
              child: Row(
                children: [
                  Text(
                    _orderDetails.orderDate,
                    style: TextStyle(
                        color: MyTheme.grey_153,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.paymentType,
                    style: TextStyle(
                        color: MyTheme.grey_153,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Payment Status",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Delivery Status",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 2),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      _orderDetails.paymentStatus.toString().replaceRange(
                          0,
                          1,
                          _orderDetails.paymentStatus
                              .toString()
                              .characters
                              .first
                              .toString()
                              .toUpperCase()),
                      style: TextStyle(
                          color: _orderDetails.paymentStatus == "paid"
                              ? MyTheme.green
                              : MyTheme.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.deliveryStatus,
                    style: TextStyle(
                        color: MyTheme.grey_153,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  _orderDetails.shippingAddress != null
                      ? "Shipping Address"
                      : "Pickup Point",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Total Amount",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - (32.0)) / 2,
                    // (total_screen_width - padding)/2
                    child: _orderDetails.shippingAddress != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _orderDetails.shippingAddress.name != null
                                  ? Text(
                                      "${LangText(context: context).getLocal().order_details_screen_name}: ${_orderDetails.shippingAddress.name}",
                                      maxLines: 3,
                                      style: TextStyle(
                                          color: MyTheme.grey_153,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )
                                  : Container(),
                              _orderDetails.shippingAddress.email != null
                                  ? Text(
                                      "${LangText(context: context).getLocal().order_details_screen_email}: ${_orderDetails.shippingAddress.email}",
                                      maxLines: 3,
                                      style: TextStyle(
                                          color: MyTheme.grey_153,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )
                                  : Container(),
                              Text(
                                "${LangText(context: context).getLocal().order_details_screen_address}: ${_orderDetails.shippingAddress.address}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().order_details_screen_city}: ${_orderDetails.shippingAddress.city}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().order_details_screen_country}: ${_orderDetails.shippingAddress.country}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().order_details_screen_state}: ${_orderDetails.shippingAddress.state}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().order_details_screen_phone}: ${_orderDetails.shippingAddress.phone}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().order_details_screen_postal_code}: ${_orderDetails.shippingAddress.postalCode}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _orderDetails.pickupPoint.name != null
                                  ? Text(
                                      "${LangText(context: context).getLocal().order_details_screen_name}: ${_orderDetails.pickupPoint.name}",
                                      maxLines: 3,
                                      style: TextStyle(
                                          color: MyTheme.grey_153,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )
                                  : Container(),
                              Text(
                                "${LangText(context: context).getLocal().order_details_screen_address}: ${_orderDetails.pickupPoint.address}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().address_screen_phone}: ${_orderDetails.pickupPoint.phone}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.total,
                    style: TextStyle(
                        color: MyTheme.app_accent_color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderedProductItemsCard(index) {
    return MyWidget().productContainer(
        width: DeviceInfo(context).getWidth(),
        height: 120,
        borderRadius: 10,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        margin: EdgeInsets.only(bottom: 10),
        borderColor: MyTheme.light_grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "" + _orderDetails.orderItems[index].name,
              maxLines: 2,
              style: TextStyle(fontSize: 11, color: MyTheme.font_grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _orderDetails.orderItems[index].description.toString(),
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.font_grey),
                ),
                Text(
                  _orderDetails.orderItems[index].price.toString(),
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.app_accent_color),
                ),
              ],
            ),
            Text(
              _orderDetails.orderItems[index].deliveryStatus,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.font_grey),
            ),
          ],
        ));
  }

  getRefundRequestLabelColor(status) {
    if (status == 0) {
      return Colors.blue;
    } else if (status == 2) {
      return Colors.orange;
    } else if (status == 1) {
      return Colors.green;
    } else {
      return MyTheme.font_grey;
    }
  }

  buildOrderedProductList() {
    return ListView.builder(
      itemCount: _orderDetails.orderItems.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: buildOrderedProductItemsCard(index),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
            onPressed: () {
              if (widget.go_back == false) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Main();
                }));
              } else {
                return Navigator.of(context).pop();
              }
            }),
      ),
      title: Text(
        LangText(context: context)
            .getLocal()
            .order_details_screen_order_details,
        style: TextStyle(fontSize: 16, color: MyTheme.app_accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

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
}
