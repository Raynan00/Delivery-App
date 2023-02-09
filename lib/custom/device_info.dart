
import 'package:flutter/cupertino.dart';

class DeviceInfo{
  BuildContext context;

  DeviceInfo(this.context);

 double getWidth(){
    return MediaQuery.of(context).size.width;
}
double getWidthInPercent(){
    return MediaQuery.of(context).size.width/100;
}
double getHeight(){
    return MediaQuery.of(context).size.height;
}
double getHeightInPercent(){
    return MediaQuery.of(context).size.height/100;
}

double getHeightInPercent2(){
    return MediaQuery.of(context).size.aspectRatio;
}



}