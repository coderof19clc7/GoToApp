import 'package:flutter/material.dart';
import 'package:go_to/utilities/extensions/color_extensions.dart';

class ColorConstants {
  static const baseOrange = Colors.orange;
  static const baseOrangeAcent = Colors.orangeAccent;
  static final orange = ColorExtensions.fromHex(hexString: "#F37201");
  static final lightOrange = ColorExtensions.fromHex(hexString: "#F7C498");

  static final grey = ColorExtensions.fromHex(hexString: "#C9C9C9");
  static const baseGrey = Colors.grey;

  static const baseRed = Colors.red;

  static const baseGreen = Colors.green;
  static const baseLightGreen = Colors.lightGreen;

  static const baseWhite = Colors.white;
  static Color white200 = ColorExtensions.fromHex(hexString: "#EEEEEE");

  static const baseBlack = Colors.black;

  static const baseBlue = Colors.blue;
  static const baseBlueAccent = Colors.blueAccent;

  static final defaultNotificationColor = ColorExtensions.fromHex(hexString: "#9D50DD");

  static final defaultOrangeList = [
    lightOrange, orange,
  ];
}