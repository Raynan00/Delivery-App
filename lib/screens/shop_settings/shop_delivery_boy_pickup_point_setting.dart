import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/submitButton.dart';

import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/other_config.dart';
import 'package:active_ecommerce_seller_app/repositories/google_map_location_repository.dart';
import 'package:active_ecommerce_seller_app/repositories/shop_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:toast/toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;


class ShopDeliveryBoyPickupPoint extends StatefulWidget {
  const ShopDeliveryBoyPickupPoint({Key key}) : super(key: key);

  @override
  State<ShopDeliveryBoyPickupPoint> createState() =>
      _ShopDeliveryBoyPickupPointState();
}

class _ShopDeliveryBoyPickupPointState
    extends State<ShopDeliveryBoyPickupPoint> {
  TextEditingController locationSearch = TextEditingController();


  BuildContext loadingContext;


  String _lat="";
  String _lang="";






  bool faceAllData = false;
  LatLng kInitialPosition = LatLng(51.52034098371205, -0.12637399200000668);

  Future<bool> _getAccountInfo() async {
    var response = await ShopRepository().getShopInfo();
     _lat = response.shopInfo.deliveryPickupLatitude.toString();
     _lang = response.shopInfo.deliveryPickupLongitude.toString();

    faceAllData = true;
    if ((_lat == "" && _lang == "") || (_lat == null && _lang == null)) {

      setDummyInitialLocation();
    } else {
      setInitialLocation( response.shopInfo.deliveryPickupLatitude.toString(),response.shopInfo.deliveryPickupLongitude.toString());
    }
    return true;
  }

  setInitialLocation(lat ,lng) {
    kInitialPosition=LatLng(double.parse(lat), double.parse(lng));
    setState((){});
  }

  setDummyInitialLocation() {
    kInitialPosition= LatLng(
        51.52034098371205, -0.12637399200000668);
    setState((){});
  }

  faceData() {
    _getAccountInfo();
  }





  changeLatLang(lat ,lng){
     setState((){
       _lat=lat;
       _lang=lng;
     });


    //kInitialPositionInput.add(LatLng(double.parse(lat), double.parse(lng)));
  }

/*
  updatePickupPoint(selectedPlace) async {

    var  postBody = jsonEncode({
      "delivery_pickup_longitude": selectedPlace.geometry.location.lng.toString(),
      "delivery_pickup_latitude": selectedPlace.geometry.location.lat.toString(),
    });
    var response = await ShopRepository().updateShopSetting(postBody);

    ToastComponent.showDialog(response.message,
        gravity: Toast.center, duration: Toast.lengthLong);


  }*/

  updateInfo()async{

    if( _lat == null || _lat.isEmpty  || _lang == null || _lang.isEmpty ){

      ToastComponent.showDialog("Please Pick a Place",
          backgroundColor: MyTheme.white, duration: Toast.lengthLong, gravity: Toast.center);
      return;
    }
    var  postBody = jsonEncode({
      "delivery_pickup_longitude": _lang,
      "delivery_pickup_latitude": _lat,
    });
    loadingShow(context);
    var response = await ShopRepository().updateShopSetting(postBody);
    Navigator.pop(loadingContext);

      ToastComponent.showDialog(response.message,
          backgroundColor: MyTheme.white, duration: Toast.lengthLong, gravity: Toast.center);


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
                  .shop_setting_screen_delivery_boy_pickup_point)
          .show(),
      body: SingleChildScrollView(
        child: SizedBox(
            child:
            faceAllData?buildBodyContainer():buildLoadingContainer(),
           ),
      ),
    );
  }


  Column buildBodyContainer() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height:DeviceInfo(context).getHeight()/2,
                      child:
                      buildMap(),
                  ),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       const SizedBox(
                          height: 10,
                        ),
                        Text(
                          LangText(context: context).getLocal().common_lat,
                          style: TextStyle(
                              fontSize: 12,
                              color: MyTheme.font_grey,
                              fontWeight: FontWeight.bold),
                        ),
                       const SizedBox(
                          height: 10,
                        ),
                        MyWidget.customCardView(
                          height: 40.0,
                          width: DeviceInfo(context).getWidth(),
                          borderRadius: 10,
                          backgroundColor: MyTheme.white,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(_lat??"",
                            //latLng.latitude.toString(),
                            style: TextStyle(
                                fontSize: 15, color: MyTheme.font_grey),
                          )
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          LangText(context: context).getLocal().common_lng,
                          style: TextStyle(
                              fontSize: 12,
                              color: MyTheme.font_grey,
                              fontWeight: FontWeight.bold),
                        ),
                       const SizedBox(
                          height: 10,
                        ),
                        MyWidget.customCardView(
                          height: 40.0,
                          width: DeviceInfo(context).getWidth(),
                          borderRadius: 10,
                          backgroundColor: MyTheme.white,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          alignment: Alignment.centerLeft,
                          borderColor: MyTheme.noColor,
                          child: Text(_lang??"",
                           // latLng.longitude.toString(),
                            style: TextStyle(
                                fontSize: 15, color: MyTheme.font_grey),
                          ),
                        ),
                       const SizedBox(
                          height: 30,
                        ),
                        SubmitBtn.show(
                            width: DeviceInfo(context).getWidth(),
                            backgroundColor: MyTheme.app_accent_color,
                            height: 48,
                            padding: EdgeInsets.zero,
                            elevation: 5,
                            radius: 10,
                            alignment: Alignment.center,
                            onTap: () {
                               updateInfo();
                            },
                            child: Text(
                              LangText(context: context)
                                  .getLocal()
                                  .map_location_screen_update_location,
                              style: TextStyle(fontSize: 17, color: MyTheme.white),
                            )),
                     ],
                   ),
                 ),
                ],
              );
  }

  Padding buildLoadingContainer() {
    return  Padding(
                padding:  EdgeInsets.only(top:(DeviceInfo(context).getHeight()/2.5)),
                child: Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 5,
                ),),
              );
  }
/*
  Widget buildSearchContainer(BuildContext context) {
    return Container(
      child: TypeAheadField(
        suggestionsCallback: (name) async {
          var countryResponse =
              await GoogleMapLocationRepository().getAutoCompleteAddress(name);
          return countryResponse.predictions;
        },
        loadingBuilder: (context) {
          return Container(
            height: 50,
            child: Center(
                child: Text(
                    LangText(context: context).getLocal().common_no_more_Data,
                    style: TextStyle(color: MyTheme.medium_grey))),
          );
        },
        itemBuilder: (context, location) {
          //print(suggestion.toString());
          return ListTile(
            dense: true,
            title: Text(
              location.description,
              style: TextStyle(color: MyTheme.font_grey),
            ),
          );
        },
        noItemsFoundBuilder: (context) {
          return Container(
            height: 50,
            child: Center(
                child: Text(
                    LangText(context: context).getLocal().common_no_more_Data,
                    style: TextStyle(color: MyTheme.medium_grey))),
          );
        },
        onSuggestionSelected: (location) {
         // onSelectCountryDuringAdd(location);
        },
        textFieldConfiguration: TextFieldConfiguration(
          onTap: () {},
          //autofocus: true,
          controller: locationSearch,
          onSubmitted: (txt) {
            // keep this blank
          },
          decoration: InputDecoration(
              hintText:
                  LangText(context: context).getLocal().common_search_address,
              hintStyle:
                  TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(8.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: MyTheme.textfield_grey, width: 1.0),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(8.0),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0)),
        ),
      ),
    );
  }*/


  loadingShow(BuildContext myContext) {
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

  Widget buildMap() {

    return PlacePicker(
      hintText: LangText(context: context)
          .getLocal()
          .map_location_screen_your_delivery_location,
      apiKey: OtherConfig.GOOGLE_MAP_API_KEY,
      initialPosition: kInitialPosition,
      useCurrentLocation: false,
      selectInitialPosition: true,
      onTapBack: (){},
      onPlacePicked: (pik){
       changeLatLang(pik.geometry.location.lat.toString(), pik.geometry.location.lng.toString());
      },


      selectedPlaceWidgetBuilder:
          (_, selectedPlace, state, isSearchBarFocused) {
        //print("state: $state, isSearchBarFocused: $isSearchBarFocused");
        //print(selectedPlace.toString());
        //print("-------------");
        /*
        if(!isSearchBarFocused && state != SearchingState.Searching){
          ToastComponent.showDialog("Hello", context,
              gravity: Toast.center, duration: Toast.lengthLong);
        }*/
        return isSearchBarFocused
            ? Container()
            : FloatingCard(

          height: 50,
          bottomPosition: 20.0,
          // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
          leftPosition: 0.0,
          rightPosition: 0.0,
          width: 500,
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(8.0),
            bottomLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0),
            bottomRight: const Radius.circular(8.0),
          ),
          child: state == SearchingState.Searching
              ? Center(
              child: Text(
                LangText(context: context).getLocal().map_location_screen_calculating,
                style: TextStyle(color: MyTheme.font_grey),
              ))
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 2.0, right: 2.0),
                        child: Text(
                          selectedPlace.formattedAddress,
                          maxLines: 2,
                          style:
                          TextStyle(color: MyTheme.medium_grey),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    color: MyTheme.app_accent_color,
                    shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(4.0),
                          bottomLeft: const Radius.circular(4.0),
                          topRight: const Radius.circular(4.0),
                          bottomRight: const Radius.circular(4.0),
                        )),
                    child: Text(
                      LangText(context: context).getLocal().map_location_screen_pick_here,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {

                      changeLatLang(selectedPlace.geometry.location.lat.toString(),selectedPlace.geometry.location.lng.toString());
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },

      pinBuilder: (context, state) {
        return Image.asset(
          'assets/icon/delivery_map_icon.png',
          height: 60,
        );
      },
    );
  }
}
