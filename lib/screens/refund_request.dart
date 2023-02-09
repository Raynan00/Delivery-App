import 'package:active_ecommerce_seller_app/const/app_style.dart';
import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/dummy_data/refundList.dart';
import 'package:active_ecommerce_seller_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_seller_app/main.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/refund_order_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class RefundRequest extends StatefulWidget {
  const RefundRequest({Key key}) : super(key: key);

  @override
  State<RefundRequest> createState() => _RefundRequestState();
}

class _RefundRequestState extends State<RefundRequest> {
  var _refundOrderList = [];
  int _page = 0;
  bool _showLoadingContainer = false;
  bool _faceData = false;
  RefundOptions _refundOptions;

  ScrollController _scrollController = ScrollController();
  TextEditingController rejectReasonController= TextEditingController() ;
  String _rejectReason;

  getRefundOrders() async {
    var response =
        await RefundOrderRepository().getRefundOrderList(page: _page);

    if (response.data.isEmpty) {
      ToastComponent.showDialog(
          LangText(context: context).getLocal().common_no_more_refund_requests,
          gravity: Toast.center,
          backgroundColor: MyTheme.white,
          textStyle:TextStyle(color: Colors.black) );
    }

    if (response.success) {
      _refundOrderList.addAll(response.data);
    }
    _showLoadingContainer = false;

    _faceData = true;
    print("data face" + _faceData.toString());
    setState(() {});
  }

  approveRefundReq(id) async {
    var response = await RefundOrderRepository().approveRefundSellerStatusRequest(id);
    refresh();
    ToastComponent.showDialog(response.message,
        gravity: Toast.bottom,
        duration: 2,
        backgroundColor:  MyTheme.white );

  }

  rejectRefundReq(id) async {
    var sms = getDataFromTextEditingController();

    if(sms.isEmpty){
      ToastComponent.showDialog("Please provide reason.",
          gravity: Toast.bottom,
          duration: 2,
          backgroundColor: MyTheme.white);
      return;
    }
    print("true");
    var response = await RefundOrderRepository().rejectRefundSellerStatusRequest(id,sms);
    refresh();
    ToastComponent.showDialog(response.message,
        gravity: Toast.bottom,
        duration: 2,
        backgroundColor:  MyTheme.white  );

  }

  scrollControllerListener() {
    _scrollController.addListener(() {
     // print("position: " + _scrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }


  setDataInTextEditingController(text){
    rejectReasonController.text= text??"";
    setState(() {
    });
  }

 String getDataFromTextEditingController(){
     return rejectReasonController.text.trim();
  }

  fetchData() {
    getRefundOrders();
  }

  clearData() {
    _faceData = false;
    _refundOrderList = [];
    _page = 0;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> refresh() async {
    clearData();
    fetchData();
  }

  @override
  void initState() {
    // TODO: implement initState
    scrollControllerListener();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
              context: context,
              title: LangText(context: context)
                  .getLocal()
                  .dashboard_refund_requests)
          .show(),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: !_faceData
                          ? ShimmerHelper().buildListShimmer(
                              item_count: 10, item_height: 100.0)
                          : _refundOrderList.isNotEmpty
                              ? ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _refundOrderList.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == _refundOrderList.length) {
                                      return moreLoading();
                                    }
                                    return refundReqItem(context, index);
                                  })
                              : Container(
                                  height: DeviceInfo(context).getHeight() / 1.5,
                                  child: Center(
                                      child: Text(LangText(context: context)
                                          .getLocal()
                                          .common_no_data_available)),
                                ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  refundReqItem(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        showStatusChangeDialog(_refundOrderList[index].id,_refundOrderList[index].refundStatus,_refundOrderList[index].seller_approval,_refundOrderList[index].refundReson,_refundOrderList[index].rejectReson);

      },
      child: MyWidget.customCardView(

        backgroundColor: MyTheme.app_accent_color_extra_light,
        elevation: 5,
        height: 96,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        width: DeviceInfo(context).getWidth(),
        margin: EdgeInsets.only(top: AppStyles.listItemsMargin),
        borderColor: MyTheme.app_accent_border,
        borderWidth: 1,
        alignment: Alignment.center,
        borderRadius: 6,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: DeviceInfo(context).getWidth() / 2,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _refundOrderList[index].orderCode,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: MyTheme.app_accent_color),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icon/calender.png',
                            width: 12,
                            height: 12,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            _refundOrderList[index].date,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: MyTheme.font_grey),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icon/refund.png',
                            width: 12,
                            height: 12,
                            color: MyTheme.font_grey,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Refund Status - ",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: MyTheme.font_grey),
                          ),
                          Text(
                            _refundOrderList[index].refundLabel,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: MyTheme.font_grey),
                          ),
                          SizedBox(width: 5,),
                          _refundOrderList[index].refundStatus == 1
                              ? Icon(
                                  Icons.check_circle,
                                  color: MyTheme.green,
                                  size: 14,
                                )
                              : _refundOrderList[index].refundStatus == 0
                                  ? Icon(
                                      Icons.error,
                                      color: Colors.yellow,
                                      size: 14,
                                    )
                                  : Icon(
                                      Icons.cancel,
                                      color: MyTheme.red,
                                      size: 14,
                                    )
                        ],
                      ),

                    ]),
              ),
              Container(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height:16,
                      width:8,
                      child: Image.asset("assets/icon/ios-back-arrow.png",height: 12,width: 8,color: MyTheme.app_accent_color,),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      _refundOrderList[index].productPrice.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyTheme.app_accent_color),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  Future showStatusChangeDialog(id,refundStatus ,seller_approval,String refundSMS,rejectReason) {
    _refundOptions = seller_approval==2?RefundOptions.Reject:RefundOptions.Approve;
    setDataInTextEditingController(rejectReason);

    var showFullText = false;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context,setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.only( top: 15,right: 20,left: 20,bottom: 0),
                insetPadding: EdgeInsets.zero,
                content: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: setAlertDialogHeight(refundSMS,  DeviceInfo(context).getWidth()*.7,showFullText),
                  width: DeviceInfo(context).getWidth()*.7,
                  child: Container(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Refund Reason ",style: TextStyle(fontSize: 14,color: MyTheme.app_accent_color)),
                        SizedBox(height: 5,),
                        Text(refundSMS,style: TextStyle(fontSize: 14,color: Colors.grey),
                          maxLines:showFullText?textLines(refundSMS, DeviceInfo(context).getWidth()*.7): 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Visibility(
                          visible: textIsOverFlow(refundSMS, DeviceInfo(context).getWidth()*.7),
                          child: InkWell(
                            onTap: (){
                              setState((){
                                showFullText =!showFullText;
                              });
                            },
                            child: Text(showFullText?"less":"read more",style: TextStyle(fontSize: 14,color: MyTheme.app_accent_color,decoration: TextDecoration.underline,),),
                          ),
                        ),
                        Visibility(
                          visible: refundStatus !=2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15,),

                              Text("Seller Approval",style: TextStyle(fontSize: 15,color: MyTheme.app_accent_color,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Visibility(
                                    visible: seller_approval==0 || seller_approval==1,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 15,
                                          width: 15,
                                          child: Radio(
                                            toggleable: true,
                                            value: RefundOptions.Approve,
                                            groupValue: _refundOptions,
                                            onChanged: (newValue) {
                                              if(seller_approval==0) {
                                                setState(() {
                                                  _refundOptions = newValue;
                                                });
                                              }
                                            }),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(seller_approval==1?LangText(context: context).getLocal().common_approved:LangText(context: context).getLocal().common_approve,
                                          style: TextStyle(fontSize: 14,color: MyTheme.app_accent_color),
                                        ),
                                        SizedBox(width: 30,),
                                      ],
                                    ),
                                  ),

                                  Visibility(
                                  visible: seller_approval==0 || seller_approval==2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          child: Radio(
                                              value: RefundOptions.Reject,
                                              groupValue: _refundOptions,
                                              onChanged: (newValue) {
                                                if(seller_approval==0) {
                                                  setState(() {
                                                    _refundOptions = newValue;
                                                  });
                                                }
                                              }),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(seller_approval==2?LangText(context: context).getLocal().common_rejected:LangText(context: context).getLocal().common_reject,style: TextStyle(fontSize: 14,color: MyTheme.app_accent_color),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: _refundOptions.index==1,
                                  child: MyWidget.customContainer(
                                    backgroundColor: MyTheme.app_accent_color_extra_light,
                                    borderColor:  MyTheme.app_accent_color,
                                padding: EdgeInsets.all(5.0),
                                margin: EdgeInsets.only(top: 10),
                                borderRadius: 5.0,
                                height:_refundOptions.index==0?0:70,
                                    alignment: Alignment.topLeft,
                                    child: SingleChildScrollView(
                                      child: TextField(
                                        readOnly:seller_approval!=0 ,
                                        controller: rejectReasonController,
                                        style:  TextStyle(fontSize: 14,color: MyTheme.app_accent_color,),
                                        scrollPhysics:  AlwaysScrollableScrollPhysics(),
                                       // scrollController:,
                                        maxLines:4,
                                        decoration: InputDecoration.collapsed(hintText: "Type reason",hintStyle: TextStyle(fontSize: 14,color: MyTheme.app_accent_border)),

                                      ),
                                    ),
                                    width: double.infinity,

                              ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                actions: [
                  FlatButton(
                    color: MyTheme.app_accent_color,
                      onPressed: (){
                    Navigator.pop(context);
                  }, child: Text(LangText(context: context).getLocal().common_close,style: TextStyle(color: MyTheme.white,fontSize: 12),)),
                  Visibility(
                    visible: seller_approval==0 && refundStatus !=2,
                    child: FlatButton(
                        color: MyTheme.app_accent_color,
                        onPressed: (){
                      if(_refundOptions.index==0){
                        approveRefundReq(id);
                      }if(_refundOptions.index==1){
                        rejectRefundReq(id);
                      }

                      Navigator.pop(context);

                    }, child: Text(LangText(context: context).getLocal().common_submit,style: TextStyle(color: MyTheme.white,fontSize: 12))),
                  ),
                ],
              );
            }
          );
        });
  }


 double setAlertDialogHeight(mytext,maxWidth,showFullText){
    var height;
    if(_refundOptions.index==0 && textIsOverFlow(mytext, maxWidth) && showFullText){
      height= 120+textLineHeight(mytext,DeviceInfo(context).getWidth()*.7);
    }else if(_refundOptions.index==0 && textIsOverFlow(mytext, maxWidth)){
      height= 140.0;
    }else if(_refundOptions.index==0){
      height= 120.0;
   }
    else if (_refundOptions.index==1 && textIsOverFlow(mytext, maxWidth) && showFullText) {
      height= 220+textLineHeight(mytext,DeviceInfo(context).getWidth()*.7);
   }else if(_refundOptions.index==1 )
     {
       height= 220.0;
     }
    print(height);
  return height;
  }

 bool textIsOverFlow(mytext,maxWidth){
    // Build the textspan
    var span = TextSpan(
      text: mytext,
      style: TextStyle(fontSize: 12),
    );

    // Use a textpainter to determine if it will exceed max lines
    var tp = TextPainter(
      maxLines: 2,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      text: span,
    );

    // trigger it to layout
    tp.layout(maxWidth: maxWidth);

    // whether the text overflowed or not
    var exceeded = tp.didExceedMaxLines;
    return exceeded;

  }

 double textLineHeight(mytext,maxWidth){
    // Build the textspan
    var span = TextSpan(
      text: mytext,
      style: TextStyle(fontSize: 12),
    );

    // Use a textpainter to determine if it will exceed max lines
    var tp = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      text: span,
    );

    // trigger it to layout
    tp.layout(maxWidth: maxWidth);

    // whether the text overflowed or not
    var exceeded = tp.height;
    return exceeded;

  }

 int textLines(mytext,maxWidth){
    // Build the textspan
    var span = TextSpan(
      text: mytext,
      style: TextStyle(fontSize: 12),
    );

    // Use a textpainter to determine if it will exceed max lines
    var tp = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      text: span,
    );

    // trigger it to layout
    tp.layout(maxWidth: maxWidth);

    // whether the text overflowed or not
    var exceeded = tp.computeLineMetrics().length;
    return exceeded;

  }


  Widget moreLoading() {
    return _showLoadingContainer
        ? Container(
            alignment: Alignment.center,
            child: SizedBox(
              height: 40,
              width: 40,
              child: Row(
                children: [
                  SizedBox(
                    width: 2,
                    height: 2,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          )
        : SizedBox(
            height: 5,
            width: 5,
          );
  }
}

enum RefundOptions { Approve, Reject }
