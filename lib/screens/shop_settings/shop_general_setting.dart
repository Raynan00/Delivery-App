import 'dart:convert';

import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/input_decorations.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/submitButton.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/data_model/uploaded_file_list_response.dart';
import 'package:active_ecommerce_seller_app/helpers/file_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/file_upload_repository.dart';
import 'package:active_ecommerce_seller_app/repositories/shop_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';


class ShopGeneralSetting extends StatefulWidget {
  const ShopGeneralSetting({Key key}) : super(key: key);

  @override
  State<ShopGeneralSetting> createState() => _ShopGeneralSettingState();
}

class _ShopGeneralSettingState extends State<ShopGeneralSetting> {



  BuildContext loadingContext;

  String avatar_original = "";
  String _imageId = "";
  List<String> _errors=[];

  bool _faceData=false;


  //for image uploading
  final ImagePicker _picker = ImagePicker();
  XFile _file;


  TextEditingController nameEditingController = TextEditingController(text: "");
  TextEditingController addressEditingController = TextEditingController(text: "");
  TextEditingController titleEditingController = TextEditingController(text: "");
  TextEditingController phoneEditingController = TextEditingController(text: "");
  TextEditingController descriptionEditingController = TextEditingController(text: "");

  Future<bool> _getAccountInfo() async {
    var response = await ShopRepository().getShopInfo();
    Navigator.pop(loadingContext);
    avatar_original=response.shopInfo.logo;
    nameEditingController.text=response.shopInfo.name;
    addressEditingController.text=response.shopInfo.address;
    titleEditingController.text=response.shopInfo.title;
    descriptionEditingController.text=response.shopInfo.description;
    phoneEditingController.text=response.shopInfo.phone;
    _imageId = response.shopInfo.uploadId;
    _faceData=true;
    setState(() {});
    return true;
  }


  updateInfo()async{
  var  postBody = jsonEncode({
      "name": nameEditingController.text.trim(),
      "address": addressEditingController.text.trim(),
      "phone": phoneEditingController.text.trim(),
      "meta_title": titleEditingController.text.trim(),
      "meta_description": descriptionEditingController.text.trim(),
      "logo": _imageId,
    });
  loadingShow(context);
  var response = await ShopRepository().updateShopSetting(postBody);
  Navigator.pop(loadingContext);

  if (response.result) {
    ToastComponent.showDialog(response.message,
        backgroundColor: MyTheme.white, duration: Toast.lengthLong, gravity: Toast.center);
  }else{
    ToastComponent.showDialog(response.message,
        backgroundColor: MyTheme.white, duration: Toast.lengthLong, gravity: Toast.center);
  }

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
        avatar_original=imageUploadResponse.path;
        _imageId=imageUploadResponse.upload_id.toString();
        setState(() {
        });

      }
    }
  }


  formValidation(){
    _errors=[];
    if(nameEditingController.text.trim().isEmpty){

      _errors.add(LangText(context: context).getLocal().general_setting_screen_name_error);
    }
    if(phoneEditingController.text.trim().isEmpty){

      _errors.add(LangText(context: context).getLocal().general_setting_screen_phone_error);
    }
    if(addressEditingController.text.trim().isEmpty){
      _errors.add(LangText(context: context).getLocal().general_setting_screen_address_error);
    }
    if(titleEditingController.text.trim().isEmpty){

      _errors.add(LangText(context: context).getLocal().general_setting_screen_title_error);
    }
    if(descriptionEditingController.text.trim().isEmpty){

      _errors.add(LangText(context: context).getLocal().general_setting_screen_description_error);
    }
    if(_imageId.isEmpty){
      _errors.add(LangText(context: context).getLocal().general_setting_screen_logo_error);
    }

setState(() {

});

  }

 Future<void> onRefresh(){
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
                  .shop_setting_screen_general_setting)
          .show(),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                buildShopName(context),
                SizedBox(
                  height: 14,
                ),
                buildShopLogo(context),
                SizedBox(
                  height: 14,
                ),
                buildShopPhone(context),
            SizedBox(
              height: 14,
            ),buildShopAddress(context),
            SizedBox(
              height: 14,
            ),
            buildShopTitle(context),
                SizedBox(
                  height: 14,
                ),
            buildShopDes(context),
                SizedBox(height: 14,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_errors.length, (index) => Text(_errors[index],style: TextStyle(fontSize: 15,color: MyTheme.red),)),
                ),
                SizedBox(height: 20,),
                SubmitBtn.show(
                    radius:6,
                    elevation: 5,
                    alignment: Alignment.center,
                    width: DeviceInfo(context).getWidth(),
                    backgroundColor: MyTheme.app_accent_color,
                    height: 48,
                    padding: EdgeInsets.zero,
                    onTap: (){
                      formValidation();
                      if(_errors.isEmpty){
                        updateInfo();
                      }
                    }, child: Text(LangText(context: context).getLocal().common_save,style: TextStyle(fontSize: 17,color: MyTheme.white),)),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildShopDes(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LangText(context: context)
                  .getLocal()
                  .shop_general_setting_screen_shop_description,
              style: TextStyle(
                  fontSize: 12,
                  color: MyTheme.font_grey,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            MyWidget.customCardView(

              width: DeviceInfo(context).getWidth(),
              backgroundColor: MyTheme.white,

              height: 80,

              padding: EdgeInsets.symmetric(horizontal: 6,vertical: 6),
              borderColor: MyTheme.noColor,
              borderRadius: 6,
              child: TextField(
                controller: descriptionEditingController,
                decoration: InputDecoration.collapsed(hintText: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable",hintStyle: TextStyle(color: MyTheme.grey_153,fontSize: 12)),
                maxLines: 6,
              ),
            ),
          ],
        );
  }

  Column buildShopTitle(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LangText(context: context)
                  .getLocal()
                  .shop_general_setting_screen_shop_title,
              style: TextStyle(
                  fontSize: 12,
                  color: MyTheme.font_grey,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            MyWidget.customCardView(
              height: 40,
              width: DeviceInfo(context).getWidth(),
              backgroundColor: MyTheme.white,
              borderRadius: 10,
              child: TextField(
                controller: titleEditingController,
                decoration: InputDecorations.buildInputDecoration_1(
                    hint_text: "Filon Asset Store",
                    borderColor: MyTheme.noColor,
                    hintTextColor: MyTheme.grey_153),
              ),
            ),

          ],
        );
  }

  Column buildShopPhone(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LangText(context: context)
                      .getLocal()
                      .shop_general_setting_screen_shop_phone,
                  style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.font_grey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                MyWidget.customCardView(
                  elevation: 5,
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                  borderWidth: 0,
                  backgroundColor: MyTheme.white,
                  height: 40,
                  width: DeviceInfo(context).getWidth(),
                  borderColor: MyTheme.light_grey,
                  borderRadius: 6,
                  child: TextField(
                    controller: phoneEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration.collapsed(hintText: "01.....",hintStyle: TextStyle(color: MyTheme.grey_153,fontSize: 12)),
                    maxLines: 6,
                  ),
                ),
              ],
            );
  }

  Column buildShopAddress(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LangText(context: context)
                      .getLocal()
                      .shop_general_setting_screen_shop_address,
                  style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.font_grey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                MyWidget.customCardView(
                  alignment: Alignment.center,
                  backgroundColor: MyTheme.white,
                  elevation: 5,
                  height:65,
                  padding: EdgeInsets.symmetric(vertical: 6,horizontal: 6),
                  width: DeviceInfo(context).getWidth(),
                  borderColor: MyTheme.light_grey,
                  borderRadius: 6,
                  child: TextField(

                    controller: addressEditingController,
                    decoration: InputDecoration.collapsed(hintText: "1348 Fancher Drive Dallas, TX 75225",hintStyle: TextStyle(color: MyTheme.grey_153,fontSize: 12)),
                    maxLines: 6,
                  ),
                ),
              ],
            );
  }

  Column buildShopName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context)
              .getLocal()
              .shop_general_setting_screen_shop_name,
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
            controller: nameEditingController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: "Filon Asset Store",
                borderColor: MyTheme.light_grey,
                hintTextColor: MyTheme.grey_153),
          ),
        ),
      ],
    );
  }

  Widget buildShopLogo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangText(context: context)
              .getLocal()
              .shop_general_setting_screen_shop_logo,
          style: TextStyle(
              fontSize: 12,
              color: MyTheme.font_grey,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: (){
            chooseAndUploadImage(context);
          },
          child:
          MyWidget.customCardView(
              backgroundColor: MyTheme.white,
              width: DeviceInfo(context).getWidth(),
              height: 36,
              borderRadius: 6,
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text(
                      "Choose file",
                      style: TextStyle(fontSize: 12, color: MyTheme.grey_153),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: 36,
                      width: 80,
                      decoration: BoxDecoration(
                        color: MyTheme.light_grey,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(6),topRight: Radius.circular(6),)
                      ),
                      child: Text(
                        "Browse",
                        style: TextStyle(fontSize: 12, color: MyTheme.grey_153),
                      )),
                ],
              )),
        ),
        SizedBox(height: 6,),
        Visibility(
          visible: avatar_original.isNotEmpty,
            child: MyWidget.customCardView(
              height: 120,width: 120,
              elevation: 5,
              backgroundColor: MyTheme.white,
              child: Stack(
                children: [

                  MyWidget.imageWithPlaceholder(height: 120.0,width: 120.0,url: avatar_original),
                  Positioned(
                    child: InkWell(
                      onTap: (){
                        avatar_original="";
                        _imageId = "";
                        setState(() {
                        });
                      },
                      child: Icon(Icons.close,size: 15,color: MyTheme.red,),),
                    top: 0,
                    right: 5,
                  ),
                ],
              ),
            )),
      ],
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
