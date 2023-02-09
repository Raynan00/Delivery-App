import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/route_transaction.dart';
import 'package:active_ecommerce_seller_app/data_model/chat_list_response.dart';
import 'package:active_ecommerce_seller_app/dummy_data/chatList.dart';
import 'package:active_ecommerce_seller_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/chat_repository.dart';
import 'package:active_ecommerce_seller_app/screens/conversation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  List<Chat> _chatList= [];
  bool _faceData= false;




  getCouponList() async {
    var response = await ChatRepository().getChatList();
    _chatList.addAll(response.data);
    _faceData=true;
    setState(() {});
  }



  faceData() {
    getCouponList();
  }

  clearData() {
    _chatList = [];
    _faceData=false;
  }

  Future<bool> resetData() async{
    clearData();
    faceData();
    return true;
  }

  Future<void> refresh()async {
    await resetData();
    return Future.delayed(const Duration(seconds: 1));
  }


  @override
  void initState() {
    faceData();
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
              context: context,
              title:
                  LangText(context: context).getLocal().chat_list_screen_title)
          .show(),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: DeviceInfo(context).getWidth(),
                //height: DeviceInfo(context).getHeight(),
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: _faceData?buildChatListView():chatListShimmer(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatListShimmer(){
    return Column(
      children: List.generate(20, (index) =>
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: MyTheme.shimmer_base,
                  highlightColor: MyTheme.shimmer_highlighted,
                  child: Container(
                    height: 35,
                    width: 35,
                    margin: EdgeInsets.only(right: 14),
                    decoration: BoxDecoration(
                      color: MyTheme.red,
                      borderRadius: BorderRadius.circular(30),
                    ),

                  ),
                ),
                ShimmerHelper().buildBasicShimmer(height: 35,width: DeviceInfo(context).getWidth()-80),

              ],
            ),
          )

      ),
    );

  }

  Widget buildChatListView() {
    return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _chatList.length,
            itemBuilder: (context, index) {
              return Container(
                  width: 100,
                  child: buildChatItem(
                    index,
                      _chatList[index].id,
                      _chatList[index].name,
                      _chatList[index].image,
                      _chatList[index].title,
                      true));
            });
  }

  Widget buildChatItem(index,conversationId,String userName, img, sms, bool isActive) {
    return Container(
      margin: EdgeInsets.only(top:index==0?20:0,bottom: 20),
      child: FlatButton(
        padding: EdgeInsets.zero,
        onPressed: (){
          MyTransaction(context: context).push(Conversation(id: conversationId,userImgUrl: img,name: userName,));
        },
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              margin: EdgeInsets.only(right: 14),
              child: Stack(
                children: [
                  MyWidget.roundImageWithPlaceholder(elevation: 4,
                      borderWidth: 1,
                      url: img, width: 35.0, height: 35.0, fit: BoxFit.cover,borderRadius: 16),
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
                            bgColor: isActive ? Colors.green : MyTheme.grey_153,
                            borderWith: 1)),
                  )
                ],
              ),
            ),

            Container(
              width: DeviceInfo(context).getWidth() - 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: DeviceInfo(context).getWidth(),
                    child: Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: MyTheme.app_accent_color),
                    ),
                  ),
                  Container(
                    child: Text(
                      sms,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: MyTheme.grey_153,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
