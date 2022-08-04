import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';

class EndLocationIcon extends StatelessWidget {
  const EndLocationIcon({
    Key? key, this.size = DimenConstants.baseIconSize,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.location_on, color: ColorConstants.baseRed,
      size: DimenConstants.getProportionalScreenWidth(context, size),
    );
  }
}
