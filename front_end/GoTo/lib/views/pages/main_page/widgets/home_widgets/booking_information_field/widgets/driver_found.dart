import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';

class DriverFound extends StatelessWidget {
  const DriverFound({
    Key? key, required this.driverName, required this.driverPhone,
  }) : super(key: key);

  final String driverName, driverPhone;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _getText(),
        style: TextStyle(
          fontSize: DimenConstants.getProportionalScreenWidth(context, 20),
          color: ColorConstants.baseBlack,
        ),
      ),
    );
  }

  String _getText() {
    return "${StringConstants.driver} $driverName ($driverPhone) ${StringConstants.willPickYouUp}";
  }
}
