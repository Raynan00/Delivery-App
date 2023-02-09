import 'dart:convert';

import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/submitButton.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/helpers/file_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/file_upload_repository.dart';
import 'package:active_ecommerce_seller_app/repositories/shop_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class ShopBannerSettings extends StatefulWidget {
  const ShopBannerSettings({Key key}) : super(key: key);

  @override
  State<ShopBannerSettings> createState() => _ShopBannerSettingsState();
}

class _ShopBannerSettingsState extends State<ShopBannerSettings> {

  BuildContext loadingContext;

  List<String> _imageUrls = [];
  List<String> _imageIds = [];
  List<String> _errors=[];
  //for image uploading
  final ImagePicker _picker = ImagePicker();
  XFile _file;

  Future<bool> _getAccountInfo() async {
    var response = await ShopRepository().getShopInfo();
    Navigator.pop(loadingContext);

    _imageUrls.addAll(response.shopInfo.sliders) ;

    if(response.shopInfo.slidersId!=null)
   _imageIds= response.shopInfo.slidersId.split(",");

   print(_imageIds.join(','));
    setState(() {});
    return true;
  }

  updateInfo()async{
    var  postBody = jsonEncode({
      "sliders": _imageIds.join(','),
    });
    loadingShow(context);
    var response = await ShopRepository().updateShopSetting(postBody);
    Navigator.pop(loadingContext);

      ToastComponent.showDialog(response.message,
          backgroundColor: MyTheme.white, duration: Toast.lengthLong, gravity: Toast.center);


  }



  resetData(){
    cleanData();
    faceData();
  }
  cleanData(){
     _imageUrls = [];
    _imageIds = [];
   _errors=[];
    //for image uploading
  }

  faceData(){
    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadingShow(context));
    _getAccountInfo();
  }

  chooseAndUploadImage(context) async {
    var status = await Permission.photos.request();

    if (status.isDenied) {
      // We didn't ask for permission yet.
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(LangText(context: context)
                .getLocal()
                .common_photo_permission),
            content: Text(
                LangText(context:context).getLocal().common_app_needs_permission),
            actions: <Widget>[
              CupertinoDialogAction(
                child:
                Text(LangText(context: context).getLocal().common_deny),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: Text(
                    LangText(context: context).getLocal().common_settings),
                onPressed: () => openAppSettings(),
              ),
            ],
          ));
    } else if (status.isRestricted) {
      ToastComponent.showDialog(
          LangText(context: context).getLocal().common_give_photo_permission,
          
          gravity: Toast.center,
          duration: Toast.lengthLong);
    } else if (status.isGranted) {
      //file = await ImagePicker.pickImage(source: ImageSource.camera);
      _file = await _picker.pickImage(source: ImageSource.gallery);

      if (_file == null) {
        ToastComponent.showDialog(
            LangText(context:context).getLocal().common_no_file_chosen, 
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      //return;
      String base64Image = FileHelper.getBase64FormateFile(_file.path);
      String fileName = _file.path.split("/").last;

      var imageUploadResponse = await FileUploadRepository().imageUpload(
        base64Image,
        fileName,
      );

      if (imageUploadResponse.result == false) {
        ToastComponent.showDialog(imageUploadResponse.message, 
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      } else {
        ToastComponent.showDialog(imageUploadResponse.message, 
            gravity: Toast.center, duration: Toast.lengthLong);

        _imageUrls.add(imageUploadResponse.path);
        _imageIds.add(imageUploadResponse.upload_id.toString());
        setState(() {
        });

      }
    }
  }


  formValidation(){
    _errors=[];
    if(_imageIds.isEmpty){
      _errors.add(LangText(context: context).getLocal().shop_banner_setting_screen_error);
    }
    setState(() {

    });

  }

 Future onRefresh(){
    faceData();
    return Future.delayed(Duration(seconds: 0));
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
              title: LangText(context: context)
                  .getLocal()
                  .shop_setting_screen_banner_settings)
          .show(),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      LangText(context: context)
                          .getLocal()
                          .shop_banner_setting_screen_banner,
                      style: TextStyle(
                          fontSize: 12,
                          color: MyTheme.font_grey,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: (){

                        chooseAndUploadImage(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      child: MyWidget().myContainer(
                          width: DeviceInfo(context).getWidth(),
                          height: 36,
                          borderRadius: 6.0,
                          borderColor: MyTheme.light_grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  "Choose file",
                                  style: TextStyle(
                                      fontSize: 12, color: MyTheme.grey_153),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  height: 36,
                                  width: 80,
                                  color: MyTheme.light_grey,
                                  child: Text(
                                    "Browse",
                                    style: TextStyle(
                                        fontSize: 12, color: MyTheme.grey_153),
                                  )),
                            ],
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  LangText(context: context)
                      .getLocal()
                      .shop_banner_setting_screen_banner_file_des,
                  style: TextStyle(fontSize: 8, color: MyTheme.grey_153),
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(

                  children:  List.generate(_imageUrls.length, (index) =>  Stack(
                    children: [
                      MyWidget.imageWithPlaceholder(height: 60.0,width: 60.0,url: _imageUrls[index]),
                      Positioned(
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: MyTheme.white
                          ),
                          child: InkWell(
                            onTap: (){
                              _imageUrls.removeAt(index);
                              _imageIds.removeAt(index);
                              setState(() {
                              });
                            },
                            child: Icon(Icons.close,size: 12,color: MyTheme.red,),),
                        ),
                        top: 0,
                        right: 5,
                      ),
                    ],
                  ),),
                ),
                SizedBox(height: 14,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_errors.length, (index) => Text(_errors[index],style: TextStyle(fontSize: 15,color: MyTheme.red),)),
                ),
                SizedBox(
                  height: 20,
                ),
                SubmitBtn.show(
                  alignment: Alignment.center,
                    onTap: (){
                  formValidation();
                 if(_errors.isEmpty){
                   updateInfo();
                 }
                },height: 48,
                    backgroundColor: MyTheme.app_accent_color,
                    radius: 6.0,
                    width: DeviceInfo(context).getWidth(),
                    child:Text(
                      LangText(context: context).getLocal().common_save,
                      style: TextStyle(fontSize: 17, color: MyTheme.white),
                    )
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


  loadingShow(BuildContext myContext){
    return showDialog(
      //barrierDismissible: false,
        context: myContext,
        builder: (BuildContext context) {
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
