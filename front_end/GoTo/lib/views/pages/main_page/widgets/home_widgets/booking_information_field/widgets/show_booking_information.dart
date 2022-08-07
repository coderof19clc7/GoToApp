import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';

class ShowBookingInformation extends StatelessWidget {
  const ShowBookingInformation({
    Key? key, required this.startPoint, required this.endPoint,
    required this.timeEstimate, required this.distance,
  }) : super(key: key);

  final String startPoint, endPoint, timeEstimate, distance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //information field
        _buildInformationField(context),
      ],
    );
  }

  Widget _buildInformationField(BuildContext context) {
    Widget _buildInformationRow(String title, String content) {
      return Text("$title: $content", softWrap: true,
        style: TextStyle(
          fontSize: DimenConstants.getProportionalScreenWidth(context, 17),
          fontWeight: FontWeight.w500,
          color: ColorConstants.baseBlack,
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DimenConstants.getProportionalScreenWidth(context, 17),
      ),
      decoration: BoxDecoration(
        color: ColorConstants.baseWhite,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.grey, offset: const Offset(2, 4), blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 20),),
          _buildInformationRow(StringConstants.startPoint, startPoint,),
          SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 10),),
          _buildInformationRow(StringConstants.endPoint, endPoint,),
          SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 10),),
          _buildInformationRow(StringConstants.distance, "${distance}km",),
          SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 10),),
          _buildInformationRow(StringConstants.endPoint, "${timeEstimate}p",),
          SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 20),),
        ],
      ),
    );
  }
}
