import 'dart:convert';
import 'dart:ui';
import 'package:active_ecommerce_seller_app/const/app_style.dart';
import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/input_decorations.dart';
import 'package:active_ecommerce_seller_app/custom/loading.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/multi_select.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/submitButton.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/data_model/products_response.dart';
import 'package:active_ecommerce_seller_app/const/newCouponOptions.dart';

import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/coupon_repository.dart';
import 'package:active_ecommerce_seller_app/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:validators/validators.dart';

class EditCoupon extends StatefulWidget {
  final String id;

  EditCoupon({Key key, this.id}) : super(key: key);

  @override
  State<EditCoupon> createState() => _EditCouponState();
}

class _EditCouponState extends State<EditCoupon> {
  String _couponInformation;
  String _couponInformation_key;
  List<dynamic> _errors = [];
  bool fetchData = false;
  BuildContext loadingContext;

  List<CouponDiscountOptions> _couponDiscountTypeList =
      CouponDiscountOptions().getList();

  List<SelectProduct> _searchProductList = [];
  List<SelectProduct> _selectedProducts = [];



  TextEditingController _couponCodeEditController = TextEditingController();
  TextEditingController _discountAmountEditController = TextEditingController();
  TextEditingController _minimumShoppingEditController =
      TextEditingController();
  TextEditingController _maximumDiscountAmountEditController =
      TextEditingController();

  String _couponProductText;
  String _seachName = "t";
  String _errorMessage = "";
  String _couponCode = "";
  String _discountAmount = "";
  String _minimumShoppingAmount = "";
  String _maximumDiscountAmount = "";
  String _couponId = "";

  bool hasError = true;

  CouponDiscountOptions _couponDiscountTypeText;

  String _statAndEndTime =
      DateFormat('MM/d/y').format(DateTime.now()).toString() +
          " - " +
          DateFormat('MM/d/y').format(DateTime.now()).toString();

  _sendEditCouponReq() async {


    var res = await CouponRepository().editCoupon(widget.id);

    if (res.data != null) {
      fetchData = true;
      var decode = jsonDecode(res.data.details);
      print(decode);
      var data = decode['data'];
      _couponInformation_key =res.data.type;
      if (res.data.type == "product_base") {
        _couponInformation = "For Product";

        for (var product in data) {
          _searchProductList.add(SelectProduct(
              id: product["id"],
              name: product["name"].toString(),
              isSelect: true));
          _selectedProducts.add(SelectProduct(
              id: product["id"],
              name: product["name"].toString(),
              isSelect: true));
        }
      } else {
        _couponInformation = "For Total Orders";
        _minimumShoppingAmount = decode["min_buy"];
        _maximumDiscountAmount = decode["max_discount"];

        _minimumShoppingEditController.text = _minimumShoppingAmount;
        _maximumDiscountAmountEditController.text = _maximumDiscountAmount;
      }

      _couponId = res.data.id.toString();
      _discountAmount = res.data.discount.toString();
      _discountAmountEditController.text = _discountAmount;
      _couponCode = res.data.code;
      _couponCodeEditController.text = _couponCode;

      _couponDiscountTypeText = res.data.discountType == "amount"
          ? _couponDiscountTypeList.first
          : _couponDiscountTypeList.last;
      _statAndEndTime = res.data.startDate + " - " + res.data.endDate;
      setState(() {});
    }
  }

  _sendUpdateCouponReq() async {
    _errors=[];
    var posBody;
    if (_couponInformation == "For Product") {
      List productIds = [];
      _selectedProducts.forEach((element) {
        productIds.add(element.id);
      });

      posBody = jsonEncode({
        "type": "product_base",
        "code": _couponCode,
        "discount": int.parse(_discountAmount),
        "discount_type": _couponDiscountTypeText.key,
        "product_ids": productIds,
        "date_range": _statAndEndTime
      });
    } else {
      posBody = jsonEncode({
        "type": "cart_base",
        "code": _couponCode,
        "discount": int.parse(_discountAmount),
        "discount_type": _couponDiscountTypeText.key,
        "min_buy": _minimumShoppingAmount,
        "max_discount": _maximumDiscountAmount,
        "date_range": _statAndEndTime
      });
    }
    show();
    var res = await CouponRepository().updateCoupon(posBody,_couponId);
Navigator.pop(loadingContext);
    if (res.result) {
      ToastComponent.showDialog(res.message ,gravity: Toast.center,duration: 3);
    }else{
      _errors.addAll(res.message);
    }
  }
/*
  bool hasErrors() {
    bool hasError = true;

    if (_couponCode.isEmpty) {
      _errorMessage =
          LangText(context: context).getLocal().common_error_coupon_code;
      hasError = true;
    } else if (_discountAmount.isEmpty || !isNumeric(_discountAmount)) {
      _errorMessage =
          LangText(context: context).getLocal().common_error_discount_amount;
      hasError = true;
    } else if (_couponInformation == "product_base") {
      if (_selectedProducts.isEmpty) {
        _errorMessage =
            LangText(context: context).getLocal().common_error_products;
        hasError = true;
      } else {
        _errorMessage = "";
        hasError = false;
      }
    } else if (_couponInformation == "cart_base") {
      if (!isNumeric(_minimumShoppingAmount)) {
        _errorMessage =
            LangText(context: context).getLocal().common_error_minimum_shopping;
        hasError = true;
      } else if (!isNumeric(_maximumDiscountAmount)) {
        _errorMessage =
            LangText(context: context).getLocal().common_error_maximum_discount;
        hasError = true;
      } else {
        _errorMessage = "";
        hasError = false;
      }
    } else {
      _errorMessage = "";
      hasError = false;
    }
    return hasError;
  }*/


  formValidation() {
    _errors = [];
    _couponCode = _couponCodeEditController.text;
    _discountAmount = _discountAmountEditController.text;
    _minimumShoppingAmount = _minimumShoppingEditController.text;
    _maximumDiscountAmount = _maximumDiscountAmountEditController.text;
    if (_couponCode.isEmpty) {
      _errors.add(LangText(context: context).getLocal().common_error_coupon_code);
    } if (_discountAmount.isEmpty || !isNumeric(_discountAmount)) {
      _errors.add(LangText(context: context).getLocal().common_error_discount_amount);

    }
    if (_couponInformation == "product_base") {
      if (_selectedProducts.isEmpty) {
        _errors.add(LangText(context: context).getLocal().common_error_products);
      }
    } else if (_couponInformation == "cart_base") {
      if (!isNumeric(_minimumShoppingAmount)) {
        _errors.add(LangText(context: context).getLocal().common_error_minimum_shopping);

      } else if (!isNumeric(_maximumDiscountAmount)) {
        _errors.add(
            LangText(context: context).getLocal().common_error_maximum_discount);

      }
    }
    setState(() {

    });
  }

  @override
  void initState() {
    _sendEditCouponReq();
    //getSearchedProductList();

    //_couponInformationList.addAll(CouponInformationOptions().getList());
    // TODO: implement initState

    //_couponInformation = "select";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //loading = Loading(context);
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title:
            LangText(context: context).getLocal().edit_coupons_screen_title,
      ).show(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return fetchData
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 14,
              ),
              buildCouponInformationContainer(context),
              SizedBox(
                height: 14,
              ),
              buildShowBox(context)
            ],
          )
        : buildLoadingContainer();
  }

  Widget buildLoadingContainer() {
    return Container(
      height: DeviceInfo(context).getHeight(),
      child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                  width: 2,
                ),
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                  width: 2,
                ),
              ],
            ),
          ),
    );
  }

  Column buildShowBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCouponCodeContainer(context),
        SizedBox(
          height: 14,
        ),
        _couponInformation == "For Product"
            ? buildCouponProductContainer()
            : buildForOrderContainer(context),
        SizedBox(
          height: 14,
        ),
        buildCouponDateContainer(),
        SizedBox(
          height: 14,
        ),
        buildCouponDiscountContainer(),
        SizedBox(
          height: 14,
        ),
        buildCouponDiscountTextField(context),
        SizedBox(height: 14,),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_errors.length, (index) => Text(_errors[index],style: TextStyle(fontSize: 15,color: MyTheme.red),)),
        ),
        SizedBox(
          height: 30,
        ),
        SubmitBtn.show(
            radius: 6.0,
            alignment: Alignment.center,
            elevation: 5,
            width: DeviceInfo(context).getWidth(),
            backgroundColor: MyTheme.app_accent_color,
            height: 48,
            padding: EdgeInsets.zero,
            onTap: () {
              formValidation();
              if (_errors.isEmpty) {
                _sendUpdateCouponReq();
              }
            },
            child: Text(
              LangText(context: context).getLocal().common_save,
              style: TextStyle(fontSize: 17, color: MyTheme.white),
            )),
      ],
    );
  }

  Column buildCouponDiscountContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context).getLocal().common_discount,
          style: TextStyle(
              fontSize: 12,
              color: MyTheme.font_grey,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(height: 50, child: _buildCouponDiscountList()),
      ],
    );
  }

  Column buildCouponCodeContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context)
              .getLocal()
              .coupons_screen_add_your_products_base_coupon,
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
            controller: _couponCodeEditController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: "Coupon Code",
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.light_grey),
          ),
        ),
      ],
    );
  }

  Column buildCouponDiscountTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context).getLocal().coupons_screen_add_amount,
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
            controller: _discountAmountEditController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: "Amount",
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.light_grey),
          ),
        ),
      ],
    );
  }

  Column buildForOrderContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context).getLocal().coupons_screen_minimum_shopping,
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
            keyboardType: TextInputType.number,
            controller: _minimumShoppingEditController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: LangText(context: context)
                    .getLocal()
                    .coupons_screen_minimum_shopping,
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.light_grey),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          LangText(context: context)
              .getLocal()
              .coupons_screen_maximum_discount_amount,
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
            keyboardType: TextInputType.number,
            controller: _maximumDiscountAmountEditController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: LangText(context: context)
                    .getLocal()
                    .coupons_screen_maximum_discount_amount,
                borderColor: MyTheme.light_grey,
                hintTextColor: MyTheme.light_grey),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Column buildCouponInformationContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context)
              .getLocal()
              .coupons_screen_coupon_information_adding,
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
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              alignment: Alignment.centerLeft,
                height: 50, child: Text(_couponInformation))),
      ],
    );
  }

  Column buildCouponProductContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context).getLocal().common_product,
          style: TextStyle(
              fontSize: 12,
              color: MyTheme.font_grey,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          child: FlatButton(
              padding: EdgeInsets.zero,
              focusColor: MyTheme.white,
              splashColor: MyTheme.white,
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setSate) {
                        return Container(
                          height: 200,
                          child: AlertDialog(
                            content: dialogBox(context, setSate),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    _selectedProducts = [];
                                    if (_searchProductList.isNotEmpty) {
                                      _searchProductList.forEach((element) {
                                        if (element.isSelect) {
                                          _selectedProducts.add(element);
                                          print(element.id);
                                        }
                                      });
                                      setState(() {});
                                    }
                                    Navigator.pop(context, _selectedProducts);
                                  },
                                  child: Text("Ok"))
                            ],
                          ),
                        );
                      });
                    });
              },
              child:         MyWidget.customCardView(
                alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16,top: 16),
                  backgroundColor: MyTheme.white,
                  width: DeviceInfo(context).getWidth(),
                  height: 45,
                  borderRadius: 10,
                  elevation: 5,
                  child: Text(
                    LangText(context: context)
                        .getLocal()
                        .coupons_screen_select_products,
                    style: TextStyle(color: MyTheme.light_grey),
                  ))),
          //_buildCouponProductList()
        ),
        SizedBox(
          height: 5,
        ),
        build_selectedProductsroductList()
      ],
    );
  }

  Container build_selectedProductsroductList() {
    return Container(

      width: DeviceInfo(context).getWidth()-34,
      child: Wrap(

        children: List.generate(
            _selectedProducts.length,
            (index) => Container(

                constraints: BoxConstraints(maxWidth: (DeviceInfo(context).getWidth()-50)/3),
                margin: EdgeInsets.only(right: 5,bottom: 5),
                child: MyWidget.customCardView(
                  backgroundColor: MyTheme.white,
                  width: DeviceInfo(context).getWidth(),
                  height: 20,
                  alignment: Alignment.centerLeft,
                  borderRadius: 10,
                  elevation: 5,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                          constraints: BoxConstraints(maxWidth: 90),
                          child: Text(
                            _selectedProducts[index].name.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          )),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                          //   color: MyTheme.grey_153
                          // ),
                          child: InkWell(
                            child:
                                Icon(Icons.highlight_remove, size: 15, color: MyTheme.red),
                            onTap: () {
                              _searchProductList.removeWhere((element) {
                                if (element.id == _selectedProducts[index].id) {
                                  return true;
                                }
                                return false;
                              });
                              _selectedProducts.removeAt(index);
                              setState(() {});
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  Column buildCouponDateContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context).getLocal().common_date,
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
            padding: EdgeInsets.symmetric(horizontal: AppStyles.layoutMargin),
            child: InkWell(
              onTap: () async {
                // showDateDialog();
                DateTimeRange time;
                time = await _buildCouponDate();
                setState(() {
                  _statAndEndTime = DateFormat('MM/d/y').format(time.start) +
                      " - " +
                      DateFormat('MM/d/y').format(time.end);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(_statAndEndTime),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.calendar_today,
                      size: 12,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  // Widget showDateDialog(){
  //
  //   showDialog(context: context, builder: (context){
  //     return AlertDialog(
  //       content: DateRangePickerDialog(
  //
  //         initialDateRange:DateTimeRange(start:DateTime.now(),end: DateTime.now() ) ,
  //         saveText: "Select",
  //         initialEntryMode: DatePickerEntryMode.calendarOnly,
  //         firstDate:_start,lastDate: DateTime.utc(2050),)
  //     );
  //   });
  // }

  Future<DateTimeRange> _buildCouponDate() async {
    DateTimeRange p;
    p = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.utc(2050),
        builder: (context, child) {
          return Container(
            color: MyTheme.red,
            width: 500,
            height: 500,
            child: DateRangePickerDialog(
              initialDateRange:
                  DateTimeRange(start: DateTime.now(), end: DateTime.now()),
              saveText: "Select",
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              firstDate: DateTime.now(),
              lastDate: DateTime.utc(2050),
            ),
          );
        });

    return p;
  }

/*
  Widget _buildCouponInformationList() {
    return MyWidget().myContainer(
      borderRadius: 6.0,
      borderColor: MyTheme.light_grey,
      paddingY: 14.0,
      width: DeviceInfo(context).getWidth(),
      child: DropdownButton<CouponInformationOptions>(
        isDense: true,
        underline: Container(),
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            _couponInformation = value;
          });
        },
        icon: Icon(Icons.arrow_drop_down),
        value: _couponInformation,
        items: _couponInformationList
            .map((value) => DropdownMenuItem<CouponInformationOptions>(
          enabled: !widget.isEdit,
          child: Text(
            value.value,
          ),
          value: value,
        ))
            .toList(),
      ),
    );
  }*/

/*
  Widget _buildCouponProductList() {
    return MyWidget().myContainer(
      borderRadius: 6.0,
      borderColor: MyTheme.light_grey,
      paddingY: 14.0,
      width: DeviceInfo(context).getWidth(),
      child: SmartSelect<CouponProduct>.multiple(
        modalType: S2ModalType.bottomSheet,
          modalFilter:true ,
          title: "Choose Product",
          modalConfig:S2ModalConfig(title: "Search Product") ,
          choiceItems: List<S2Choice<CouponProduct>>.generate(_productList.length, (index) =>
              S2Choice<CouponProduct>(value: _productList[index], title:_productList[index].name),
          ),
          value: _chosenProduct,
        onChange: (onChange){
          setState(() {
            _chosenProduct = onChange.value;
          });
      },)
    );
  }*/

  Widget _buildCouponDiscountList() {
    return         MyWidget.customCardView(
      backgroundColor: MyTheme.white,
      width: DeviceInfo(context).getWidth(),
      height: 45,
      borderRadius: 10,
      elevation: 5,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
      child: DropdownButton<CouponDiscountOptions>(
        isDense: true,
        underline: Container(),
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            _couponDiscountTypeText = value;
          });
        },
        icon: Icon(Icons.arrow_drop_down),
        value: _couponDiscountTypeText,
        items: _couponDiscountTypeList
            .map((value) => DropdownMenuItem(
                  child: Text(
                    value.value,
                  ),
                  value: value,
                ))
            .toList(),
      ),
    );
  }

  Widget dialogBox(BuildContext context, setState) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 300,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: DeviceInfo(context).getWidth(),
            height: 60,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                hintText: "Product Name",
                border: OutlineInputBorder(
                    gapPadding: 40.0, borderRadius: BorderRadius.circular(20)),
              ),
              onChanged: (string) {
                searchProduct(string, setState);
              },
            ),
          ),
          Container(
            height: 240,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _searchProductList.isNotEmpty
                    ? List.generate(
                        _searchProductList.length,
                        (index) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: DeviceInfo(context).getWidth() / 2,
                                  child: Text(
                                    _searchProductList[index].name,
                                    maxLines: 1,
                                  ),
                                ),
                                Checkbox(
                                    value: _searchProductList[index].isSelect,
                                    onChanged: (value) {
                                      setState(() {
                                        _searchProductList[index].isSelect =
                                            value;
                                        _selectedProducts = [];
                                        _searchProductList.forEach((element) {
                                          if (element.isSelect) {
                                            _selectedProducts.add(element);
                                            print(element.id);
                                          }
                                        });
                                      });
                                    })
                              ],
                            ))
                    : List.generate(1, (index) => Text("No Product")),
              ),
            ),
          ),
        ],
      ),
    );
  }

  searchProduct(String value, setState) async {
    _searchProductList.removeWhere((element) {
      if (element.isSelect) {
        return false;
      }
      return true;
    });

    var response = await CouponRepository().searchProducts(value);

    response.data.forEach((element) {
      bool idHas = false;
      _searchProductList.forEach((element2) {
        if (element.id == element2.id) {
          idHas = true;
        }
      });
      if (!idHas) {
        _searchProductList.add(
            SelectProduct(id: element.id, name: element.name, isSelect: false));
      }
    });
    setState(() {});
  }


  show(){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          //setDialogContext.add(context);
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
