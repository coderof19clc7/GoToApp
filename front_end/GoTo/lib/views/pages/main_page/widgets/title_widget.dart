import 'package:flutter/material.dart';
import 'package:go_to/configs/app_configs.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/configs/injection.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key, this.isCustomer = true}) : super(key: key);

  final bool isCustomer;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${StringConstants.app} ${injector<AppConfig>().appName} ${StringConstants.for_.toLowerCase()} "
          "${(isCustomer ? StringConstants.customer : StringConstants.driver).toLowerCase()}",
      style: TextStyle(
        fontSize: DimenConstants.getProportionalScreenWidth(
            context, 20),
        fontWeight: FontWeight.w600,
        color: ColorConstants.baseWhite,
      ),
    );
  }
}
