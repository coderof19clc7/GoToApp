import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  static Color fromHex({required String hexString, int percentOpacity = 100}) {
    String usableHexString = "FFFFFFFF";
    if (hexString.length == 6 || hexString.length == 7) {
      final buffer = StringBuffer();
      buffer.write("FF");
      buffer.write(hexString.replaceFirst("#", ""));
      usableHexString = buffer.toString();
    }

    return Color(int.parse(usableHexString, radix: 16)).withOpacity(percentOpacity / 100);
  }
}