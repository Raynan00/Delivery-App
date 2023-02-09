import 'dart:async';

import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/data_model/messages_response.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class Conversation extends StatefulWidget {
  final id;
  final userImgUrl;
  final name;

  const Conversation({Key key, this.id, this.userImgUrl, this.name}) : super(key: key);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  List<Message> _messages = [];
  bool _faceData = false;

  Timer timer;

  TextEditingController messageTextController = TextEditingController();
  String _messege = "";

  getMessages() async {
    var response = await ChatRepository().getMessages(widget.id);
    _messages.addAll(response.data);
    _faceData = true;
    setState(() {});
  }

  clearTypeSMSTextController(){
    messageTextController.text ="";
    setState(() {

    });

  }


  sendMessage()async{
    clearTypeSMSTextController();
    var response = await ChatRepository().sendMessages(widget.id,_messege);

    if(response.result){
      refresh();
    }
  }

  faceData() {
    getMessages();
  }

  clearData() {
    _messages = [];

  }

  Future<bool> resetData() async {
    clearData();
    faceData();
    return true;
  }

  Future<void> refresh() async {
    print("refresh");
    await resetData();
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    faceData();
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => refresh());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(
        children: [
         _faceData ? conversations(): chatShimmer(),
          typeSmsSection(),
        ],
      ),
    );
  }
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leadingWidth: 40,
      centerTitle: false,
      elevation: 8,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  margin: EdgeInsets.only(right: 14),
                  child: Stack(
                    children: [
                      MyWidget.roundImageWithPlaceholder(elevation: 4,
                      borderWidth: 1,
                      url: widget.userImgUrl, width: 35.0, height: 35.0, fit: BoxFit.cover,borderRadius: 16),
                      Visibility(
                        visible: false,
                        child: Positioned(
                            right: 1,
                            top: 2,
                            child: MyWidget().myContainer(
                                height: 7,
                                width: 7,
                                borderRadius: 7,
                                borderColor: Colors.white,
                                bgColor: true ? Colors.green : MyTheme.grey_153,
                                borderWith: 1)),
                      )
                    ],
                  ),
                ),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: DeviceInfo(context).getWidth() / 3,
                        child: Text(
                          widget.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: MyTheme.app_accent_color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            /*Row(
              children: [
                IconButton(
                    splashRadius: 20.0,
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/icon/audio_call.png",
                      width: 20,
                      height: 20,
                    )),
                IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 20.0,
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/icon/video_call.png",
                      width: 20,
                      height: 20,
                    )),
              ],
            ),*/
          ],
        ),
      ),
      backgroundColor: Colors.white,
      leading: Container(
        margin: EdgeInsets.only(left: 10),
        child: FlatButton(
          splashColor: Color.fromRGBO(255, 255, 255, 0),
          hoverColor: Color.fromRGBO(255, 255, 255, 0),
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/icon/back_arrow.png',
            height: 20,
            width: 20,
            //color: MyTheme.dark_grey,
          ),
        ),
      ),
    );
  }
  conversations() {
    return SingleChildScrollView(
      reverse: true,
      child: Container(
        margin:const EdgeInsets.only(bottom: 60),
        child: ListView.builder(
          reverse: true,
          itemCount: _messages.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            //print(_messages[index+1].year.toString());
            return Container(
              padding:
                  const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
              //margin: EdgeInsets.only(right: messages[index].messageType == "receiver"?0:50,left:messages[index].messageType == "receiver"? 50:0),
              child: Column(
                children: [
                  (index==_messages.length-1) || _messages[index].year!=_messages[index+1].year || _messages[index].month!=_messages[index+1].month?
                  MyWidget().myContainer(
                    width: 100,
                    height: 20,
                    borderRadius: 5,
                    borderColor: MyTheme.light_grey,
                    child: Text(""+
                        _messages[index].date.toString(),
                      style:const TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ):Container(),
                 const SizedBox(height: 5,),
                  Align(
                    alignment: (_messages[index].sendType=="seller"
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: smsContainer(index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Container smsContainer(int index) {

    return Container(
      constraints: BoxConstraints(
        minWidth: 80,
        maxWidth: DeviceInfo(context).getWidth()/1.6,
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 3, right: 10, left: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1,color:MyTheme.noColor),
        borderRadius: BorderRadius.only(

          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft:
              _messages[index].sendType=="seller" ? Radius.circular(16) : Radius.circular(0),
          bottomRight:
              _messages[index].sendType=="seller" ? Radius.circular(0) : Radius.circular(16),
        ),
        color: (_messages[index].sendType=="seller"
            ? MyTheme.app_accent_color
            : MyTheme.app_accent_color_extra_light),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 2,
            right: _messages[index].sendType=="seller" ? 2 : null,
            left: _messages[index].sendType=="seller" ? null : 2,
            child: Text(_messages[index].dayOfMonth.toString()
              +" "+_messages[index].time.toString(),
              style: TextStyle(fontSize: 8, color:  (_messages[index].sendType=="seller"
                  ? MyTheme.light_grey
                  : MyTheme.grey_153),
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(" "+
              _messages[index].message.toString(),
              style: TextStyle(fontSize: 12, color:  (_messages[index].sendType=="seller"
                  ? MyTheme.white
                  : Colors.black),
            ),
          ),)
        ],
      ),
    );
  }

  Widget typeSmsSection() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding:const EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        color: MyTheme.white,
        child: Row(
          children: <Widget>[
             Expanded(
              child: Container(
                padding:const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: MyTheme.app_accent_color_extra_light,
                ),
                child: TextField(
                  onChanged: (text){
                    if(text.trim().isEmpty){
                      messageTextController.text="";
                    }
                    _messege = text.trim().toString();
                    setState(() {

                    });
                  },

                  controller: messageTextController,
                  decoration:const InputDecoration(
                      hintText: "Write message...",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none),
                ),
              ),
            ),
           const SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: messageTextController.text.trim().isNotEmpty?() {
                print(_messege);
                sendMessage();
              }:null,
              child:const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: MyTheme.app_accent_color,
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }

  chatShimmer(){
    return SingleChildScrollView(
      reverse: true,
      child: Container(
        margin:const EdgeInsets.only(bottom: 60),
        child: ListView.builder(
          reverse: true,
          itemCount: 10,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            //print(_messages[index+1].year.toString());
            return Container(
              padding:
              const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
              //margin: EdgeInsets.only(right: messages[index].messageType == "receiver"?0:50,left:messages[index].messageType == "receiver"? 50:0),
              child: Align(
                alignment: (index.isOdd
                    ? Alignment.topRight
                    : Alignment.topLeft),
                child: smsShimmer(index),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget smsShimmer(int index) {
    return Shimmer.fromColors(
      baseColor: MyTheme.shimmer_base,
      highlightColor: MyTheme.shimmer_highlighted,
      child: Container(
        constraints: BoxConstraints(
          minWidth: 150,
          maxWidth: DeviceInfo(context).getWidth()/1.6,
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 3, right: 10, left: 10),
        decoration: BoxDecoration(
          border: Border.all(width: 1,color:index.isOdd? MyTheme.app_accent_color: MyTheme.grey_153),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft:
            index.isOdd? Radius.circular(16) : Radius.circular(0),
            bottomRight:
            index.isOdd? Radius.circular(0) : Radius.circular(16),
          ),
          color: (index.isOdd
              ? MyTheme.app_accent_color
              : MyTheme.app_accent_color_extra_light),
        ),
        child: Stack(
          children: [
            Positioned(
                bottom: 2,
                right: index.isOdd ? 2 : null,
                left: index.isOdd ? null : 2,
                child: Text(
                    "    ",
                  style: TextStyle(fontSize: 8, color:  (index.isOdd
                      ? MyTheme.light_grey
                      : MyTheme.grey_153),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text("    ",
                style: TextStyle(fontSize: 12, color:  (index.isOdd
                    ? MyTheme.white
                    : Colors.black),
                ),
              ),)
          ],
        ),
      ),
    );
  }
}
