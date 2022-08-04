import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/generated/flutter_gen/assets.gen.dart';

class StartLocationIcon extends StatelessWidget {
  const StartLocationIcon({
    Key? key, this.size = DimenConstants.baseIconSize,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Assets.svgs.doubleCircle.svg(
      width: DimenConstants.getProportionalScreenWidth(context, size),
      height: DimenConstants.getProportionalScreenWidth(context, size),
      color: ColorConstants.baseBlueAccent,
    );
  }
}