import 'package:flutter/material.dart';

class DimenConstants {
  static double baseWidth = 392.72727272727275;
  static double baseHeight = 737.4545454545455;
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static double getProportionalScreenWidth(BuildContext context, double width) {
    return (width / baseWidth) * getScreenWidth(context);
  }
  static double getProportionalScreenHeight(BuildContext context, double height) {
    return (height / baseHeight) * getScreenHeight(context);
  }
}