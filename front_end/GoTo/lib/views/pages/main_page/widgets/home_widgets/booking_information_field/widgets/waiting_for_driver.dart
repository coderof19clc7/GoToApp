import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';

class WaitingForDriver extends StatelessWidget {
  const WaitingForDriver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DimenConstants.getProportionalScreenHeight(context, 300),
      child: Center(
        child: Text(
          StringConstants.findingDriver,
          style: TextStyle(
            fontSize: DimenConstants.getProportionalScreenWidth(context, 20),
            fontWeight: FontWeight.w600,
            color: ColorConstants.baseOrangeAcent,
          ),
        ),
      ),
    );
  }
}
