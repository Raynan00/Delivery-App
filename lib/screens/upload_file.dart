import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/route_transaction.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/data_model/coupon_list_response.dart';
import 'package:active_ecommerce_seller_app/data_model/uploaded_file_list_response.dart';
import 'package:active_ecommerce_seller_app/helpers/file_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/coupon_repository.dart';
import 'package:active_ecommerce_seller_app/repositories/file_upload_repository.dart';
import 'package:active_ecommerce_seller_app/screens/coupon/new_coupon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';


class UploadFile extends StatefulWidget {
  const UploadFile({Key key}) : super(key: key);

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {



  //for image uploading
  final ImagePicker _picker = ImagePicker();
  XFile _file;

  List<FileInfo> _images = [];
  bool _faceData=false;

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

      var profileImageUpdateResponse = await FileUploadRepository().imageUpload(
        base64Image,
        fileName,
      );

      if (profileImageUpdateResponse.result == false) {
        ToastComponent.showDialog(profileImageUpdateResponse.message,
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      } else {
        ToastComponent.showDialog(profileImageUpdateResponse.message,
            gravity: Toast.center, duration: Toast.lengthLong);
        resetData();
      }
    }
  }

  getImageList() async {
    var response = await FileUploadRepository().getFiles();
    _images.addAll(response.data);
    print(_images.isEmpty);
    _faceData=true;
    setState(() {});
  }


  fetchData() {
    getImageList();
  }

  clearData() {
    _images = [];
    _faceData=false;
  }

  Future<bool> resetData() async{
    clearData();
    fetchData();
    setState(() {});
    return true;
  }

  Future<void> refresh()async {
    await resetData();
    return Future.delayed(Duration(seconds: 1));
  }



  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          context: context,
          title: LangText(context: context).getLocal().upload_file_screen_title)
          .show(),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Stack(
              children: [
                SizedBox(
                  height: 20,
                ),
                _faceData?_images.isEmpty?Center(child: Text(LangText(context: context).getLocal().common_no_more_Data),):
                buildImageListView():buildShimmerList(context),
                buildUploadFileContainer(context),
              ],
            )),
      ),
    );
  }

  Widget buildShimmerList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
            5,
                (index) => Container(
                margin: EdgeInsets.only(bottom: 20),
                child:ShimmerHelper().buildBasicShimmer(
                    height: 96, width: DeviceInfo(context).getWidth()))),
      ),
    );
  }

  Widget buildImageListView() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 80),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return buildImageItem(index);
            }),
      ),
    );
  }

  Widget buildImageItem(int index) {
    return MyWidget().productContainer(
      width: DeviceInfo(context).getWidth(),
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 125,
      borderColor: MyTheme.grey_153,
      borderRadius: 10,
      child: MyWidget.imageWithPlaceholder(url: _images[index].url,height: 100.0,width: 100.0),
    );
  }

  Widget buildUploadFileContainer(BuildContext context) {
    return InkWell(
      onTap: () {
        chooseAndUploadImage(context);
      },
      child: MyWidget().myContainer(
          height: 75,
          width: DeviceInfo(context).getWidth(),
          borderRadius: 10,
          bgColor: MyTheme.app_accent_color_extra_light,
          borderColor: MyTheme.app_accent_color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                LangText(context: context)
                    .getLocal()
                    .common_upload_file,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: MyTheme.app_accent_color),
              ),
              Icon(Icons.upload_file,size: 18,color: MyTheme.app_accent_color,)
              /*
              Image.asset(
                'assets/icon/add.png',
                width: 18,
                height: 18,
                color: MyTheme.app_accent_color,
              )*/
            ],
          )),
    );
  }
}
