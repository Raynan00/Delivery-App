

import 'package:intl/intl.dart';

class CustomDateTime{
  static String getDate = DateFormat('dMMMM,y').format(DateTime.now());
  static String getDayName = DateFormat('EEEE').format(DateTime.now());
  static String getLast7Date = DateFormat('EEEE').format(DateTime.now());


}