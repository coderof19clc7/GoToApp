import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';

class TextOnlyInformationWidget extends StatelessWidget {
  const TextOnlyInformationWidget({
    Key? key, required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text, style: TextStyle(
          fontSize: DimenConstants.getProportionalScreenWidth(context, 20),
          fontWeight: FontWeight.w600,
          color: ColorConstants.baseOrangeAcent,
        ),
      ),
    );
  }
}
