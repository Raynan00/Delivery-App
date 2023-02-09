import 'package:active_ecommerce_seller_app/custom/common_style.dart';
import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyWidget {
  BuildContext myContext;
  BuildContext pop;

  MyWidget({this.myContext});

  BuildContext getContext() {
    return myContext;
  }

  Container myContainer(
      {double width = 0.0,
      double borderWith = 1.0,
      double height = 0.0,
      double borderRadius = 0.0,
      Color bgColor = const Color.fromRGBO(255, 255, 255, 0),
      Color borderColor = const Color.fromRGBO(255, 255, 255, 0),
      Widget child,
      double paddingX = 0.0,
      paddingY = 0.0,
      double marginX = 0.0,
      double marginY = 0.0,
      Alignment alignment = Alignment.center}) {
    return Container(
        alignment: alignment,
        padding: EdgeInsets.symmetric(horizontal: paddingY, vertical: paddingX),
        margin: EdgeInsets.symmetric(horizontal: marginY, vertical: marginX),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: borderWith),
          color: bgColor,
        ),
        height: height,
        width: width,
        child: child);
  }

  Container productContainer(
      {double width = 0.0,
      double height = 0.0,
      double borderRadius = 0.0,
      Color backgroundColor = const Color.fromRGBO(255, 255, 255, 0),
      Color borderColor = const Color.fromRGBO(255, 255, 255, 0),
      Widget child,
      EdgeInsets padding,
      EdgeInsets margin,
      Alignment alignment = Alignment.center}) {
    return Container(
        alignment: alignment,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
          color: backgroundColor,
        ),
        height: height,
        width: width,
        child: child);
  }

 static Container customContainer(
      {double width = 0.0,
      double height = 0.0,
      double borderRadius = 0.0,
      Color backgroundColor = const Color.fromRGBO(255, 255, 255, 0),
      Color borderColor = const Color.fromRGBO(255, 255, 255, 0),
      Widget child,
      EdgeInsets padding,
      EdgeInsets margin,
      Alignment alignment = Alignment.center}) {
    return Container(
        alignment: alignment,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
          color: backgroundColor,
        ),
        constraints: BoxConstraints(
          minHeight: height,
          maxWidth: width,
        ),
        child: child);
  }

  Card customCard(
      {double width = 0.0,
      double elevation = 0.0,
      double height = 0.0,
      double borderRadius = 0.0,
      Color backgroundColor = const Color.fromRGBO(255, 255, 255, 0),
      Color borderColor = const Color.fromRGBO(255, 255, 255, 0),
        double borderWidth=0.0,
      Widget child,
      EdgeInsets padding,
        Color shadowColor = MyTheme.app_accent_shado,
      EdgeInsets margin,
      Alignment alignment = Alignment.center}) {
    return Card(

      shadowColor: shadowColor,
      color: backgroundColor,
      margin: margin,
      child: child,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: elevation,
      //color: backgroundColor,
    );
  }

  Container imageContainer(
      {double width = 0.0,
      double height = 0.0,
      BorderRadius borderRadius = BorderRadius.zero,
      Color backgroundColor = const Color.fromRGBO(255, 255, 255, 0),
      Color borderColor = const Color.fromRGBO(255, 255, 255, 0),
      ImageProvider imageProvider,
      Widget child,
      EdgeInsets padding,
      EdgeInsets margin,
      BoxFit fit,
      Alignment alignment = Alignment.center}) {
    return Container(
      alignment: alignment,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: borderColor),
        color: backgroundColor,
        image: DecorationImage(
          image: imageProvider,
          fit: fit,
        ),
      ),
      height: height,
      width: width,
    );
  }

  static Widget imageWithPlaceholder(
      {String url,
      double height = 0.0,
      double elevation = 0.0,
      width = 0.0,
      BorderRadiusGeometry radius = BorderRadius.zero,
        BoxFit fit = BoxFit.cover,
        Color backgroundColor  = Colors.white
      }) {
    return Material(
      color: backgroundColor,
      elevation: elevation,
      borderRadius: radius,

      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: radius
        ),
        child: url != null && url.isNotEmpty
            ? ClipRRect(
          borderRadius: radius,
              child: FadeInImage.assetNetwork(
                  placeholder: "assets/logo/placeholder.png",
                  image: url,
                  height: height,
                  imageErrorBuilder: (context, object, stackTrace) {
                    return Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        image:const DecorationImage(
                          image: AssetImage("assets/logo/placeholder.png"),
                          fit: BoxFit.cover
                        )
                      ),
                    );
                    
                  },
                  width: width,
                  fit: fit,
                ),
            )
            : Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: radius,
              image:const DecorationImage(
                image: AssetImage("assets/logo/placeholder.png"),
              )
          ),
        ),
      ),
    );
  }

  static Widget roundImageWithPlaceholder(
      {String url,
      double height = 0.0,
      double elevation = 0.0,
      double borderWidth = 0.0,
      width = 0.0,
      double paddingX = 0.0,
      double paddingY = 0.0,
      double borderRadius = 0.0,
      Color backgroundColor = Colors.white,
      BoxFit fit = BoxFit.cover}) {
    return Material(
      color: backgroundColor,
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      child: MyWidget().myContainer(
        borderWith: borderWidth,
        width: width,
        height: height,
        paddingY: paddingY,
        paddingX: paddingX,
        borderRadius: borderRadius,
        bgColor: backgroundColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: url != null && url.isNotEmpty
              ? FadeInImage.assetNetwork(
                  placeholder: "assets/logo/placeholder.png",
                  image: url,

                  imageErrorBuilder: (context, object, stackTrace) {
                    return  Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          image:const DecorationImage(
                              image: AssetImage("assets/logo/placeholder.png"),
                              fit: BoxFit.cover
                          )
                      ),
                    );
                  },
                  height: height,
                  width: width,
                  fit: fit,
                )
              : Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                image:const DecorationImage(
                  image: AssetImage("assets/logo/placeholder.png"),
                    fit: BoxFit.cover
                )
            ),
          ),
        ),
      ),
    );
  }

  static Image boxImage(url) {
    return Image.asset(
      url,
      color: MyTheme.white.withOpacity(0.5),
      height: 32,
      width: 32,
    );
  }

  static Widget homePageTopBox(BuildContext context,
      {String title, counter, iconUrl,double elevation = 0.0}) {
    return customCardView(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 14,left: 14),
        borderRadius:10,
        backgroundColor: MyTheme.app_accent_color,
        height: 75,
        width: DeviceInfo(context).getWidth() / 2 - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: MyTextStyle().dashboardBoxText(context),
                ),
                Text(
                  counter,
                  style: MyTextStyle().dashboardBoxNumber(context),
                ),
              ],
            ),
            MyWidget.boxImage(iconUrl)
          ],
        ));
  }

  static Widget customCardView(
      {double width = 0.0,
      double elevation=0.0,
      double blurSize=20.0,
      double height = 0.0,
      double borderRadius = 0.0,
      Color shadowColor =  MyTheme.app_accent_shado,
      Color borderColor = const Color.fromRGBO(255, 255, 255, 0),
      Color backgroundColor = const Color.fromRGBO(255, 255, 255, 0),
      Widget child,
        double borderWidth=0.0,
      EdgeInsets padding,
      EdgeInsets margin,
      Alignment alignment = Alignment.center}) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      padding: padding,

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor,width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(0, 6),
            blurRadius: blurSize,
          ),
        ],
      ),
      child: child,
    );

      /*

      Container(
      margin: margin,
      child: Material(
        elevation:elevation ,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            //color: MyTheme.red,
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          height: height,
          width: width,
          padding: padding,

          child: child,
        ),
      ),
    );*/

  }

/*
  static Widget imageSlider(List<String> imageUrl, BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(height: 400.0),
        items: imageUrl.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                // decoration: BoxDecoration(
                //
                // ),
                child: imageWithPlaceholder(
                    height: 157,
                    width: DeviceInfo(context).getWidth(),
                    fit: BoxFit.cover),
              );
            },
          );
        }).toList(),
      ),
    );
  } */

  static Widget imageSlider({List<String> imageUrl, BuildContext context}) {
    return Container(
      child: CarouselSlider(

          options: CarouselOptions(height: 400.0,aspectRatio: 16/7,viewportFraction: 1,autoPlay: true,enableInfiniteScroll: true),
          items: List.generate(
            imageUrl.length,
            (index) => imageWithPlaceholder(
              url: imageUrl[index],
                height: 157,
                width: DeviceInfo(context).getWidth(),
                fit: BoxFit.cover),
          )),
    );
  }
}
