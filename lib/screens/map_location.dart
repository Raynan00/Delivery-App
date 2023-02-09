///
/// AVANCED EXAMPLE:
/// Screen with map and search box on top. When the user selects a place through autocompletion,
/// the screen is moved to the selected location, a path that demonstrates the route is created, and a "start route"
/// box slides in to the screen.
///

import 'dart:async';
import 'dart:convert';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/other_config.dart';
import 'package:active_ecommerce_seller_app/repositories/shop_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:toast/toast.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MapLocation extends StatefulWidget {
  MapLocation({Key key, this.lng,this.lat}) : super(key: key);
  var lat ,lng;

  @override
  State<MapLocation> createState() => MapLocationState();
}

class MapLocationState extends State<MapLocation>
    with SingleTickerProviderStateMixin {
  PickResult selectedPlace;
  static LatLng kInitialPosition = LatLng(
      51.52034098371205, -0.12637399200000668); // London , arbitary value

  GoogleMapController _controller;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller.setMapStyle(value);
    //setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if ((widget.lat =="" && widget.lng=="") || (widget.lat== null && widget.lng== null)) {
      print("no lat");
      setDummyInitialLocation();
    }else{
      print("widget.lat ${widget.lat}");
      setInitialLocation();
    }
  }

  setInitialLocation() {
    kInitialPosition = LatLng(double.parse(widget.lat) ,double.parse(widget.lng) );
    setState(() {});
  }

  setDummyInitialLocation() {
    kInitialPosition = LatLng(
        51.52034098371205, -0.12637399200000668); // London , arbitary value
    setState(() {});
  }

/*
  updateInfo()async{

    loadingShow(context);

    Navigator.pop(loadingContext);

    if (response.result) {
      ToastComponent.showDialog(response.message, context,
          backgroundColor: MyTheme.green, duration: 2, gravity: Toast.center);
    }else{
      ToastComponent.showDialog(response.message, context,
          backgroundColor: MyTheme.red, duration: 2, gravity: Toast.center);
    }

  }*/

  onTapPickHere(selectedPlace) async {

    var  postBody = jsonEncode({
      "delivery_pickup_longitude": selectedPlace.geometry.location.lng.toString(),
      "delivery_pickup_latitude": selectedPlace.geometry.location.lat.toString(),
    });
    var response = await ShopRepository().updateShopSetting(postBody);

      ToastComponent.showDialog(response.message, 
          gravity: Toast.center, duration: Toast.lengthLong);


  }

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      hintText:  AppLocalizations.of(context).map_location_screen_your_delivery_location,
      apiKey: OtherConfig.GOOGLE_MAP_API_KEY,
      initialPosition: kInitialPosition,
      useCurrentLocation: false,
      selectInitialPosition: true,
      //onMapCreated: _onMapCreated,
      //initialMapType: MapType.terrain,

      //usePlaceDetailSearch: true,
      onPlacePicked: (result) {
        print("kkkkkkkkkkk");
        ToastComponent.showDialog(result.geometry.location.lat.toString(),);
        print("kkkkkkkkkkk");
        print(result.geometry.location.lat);
        print(result.geometry.location.lng);
        selectedPlace = result;
        // Navigator.of(context).pop();
        // setState(() {});
      },
      //forceSearchOnZoomChanged: true,
      //automaticallyImplyAppBarLeading: false,
      //autocompleteLanguage: "ko",
      //region: 'au',
      //selectInitialPosition: true,
      selectedPlaceWidgetBuilder:
          (BuildContext context, selectedPlace, state, isSearchBarFocused) {
        print("state: $state, isSearchBarFocused: $isSearchBarFocused");
        print(selectedPlace.toString());

        if(state==SearchingState.Searching){
          print("------Searching-------");
        }else{
          print("-------$selectedPlace------");
        }
        print("-------$selectedPlace------");

        /*
        if(!isSearchBarFocused && state != SearchingState.Searching){
          ToastComponent.showDialog("Hello", context,
              gravity: Toast.center, duration: Toast.lengthLong);
        }*/
        return isSearchBarFocused
            ? Container()
            : FloatingCard(
                height: 50,
                bottomPosition: 120.0,
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
                          AppLocalizations.of(context).map_location_screen_calculating,
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
                                  AppLocalizations.of(context).map_location_screen_update_location,
                                  style: TextStyle(color: Colors.white,fontSize: 10),
                                ),
                                onPressed: () {
                                  // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                  //            this will override default 'Select here' Button.
                                  /*print("do something with [selectedPlace] data");
                                  print(selectedPlace.formattedAddress);
                                  print(selectedPlace.geometry.location.lat);
                                  print(selectedPlace.geometry.location.lng);*/

                                  onTapPickHere(selectedPlace);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              );
      },
      pinBuilder: (context, state) {
        print("poin stat ${state.name}");
        if (state == PinState.Idle) {
          return Image.asset(
            'assets/icon/delivery_map_icon.png',
            height: 60,
          );
        } else {
          return Image.asset(
            'assets/icon/delivery_map_icon.png',
            height: 80,
          );
        }
      },
    );
  }
}

