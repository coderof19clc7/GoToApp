import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';

class CustomerBookingInformation extends StatelessWidget {
  const CustomerBookingInformation({
    Key? key, required this.startPoint, required this.endPoint,
    required this.customerName, required this.customerPhone,
    required this.timeEstimate, required this.distance,
    required this.timeEstimateToCustomer, required this.distanceToCustomer,
  }) : super(key: key);

  final String customerName, customerPhone, startPoint, endPoint;
  final String timeEstimate, distance, timeEstimateToCustomer, distanceToCustomer;

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
          fontWeight: FontWeight.w400,
          color: ColorConstants.baseBlack,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 20),),
        _buildInformationRow(
          "${StringConstants.customer} $customerName ($customerPhone) "
              "${StringConstants.want.toLowerCase()} ${StringConstants.go.toLowerCase()}",
          "",
        ),
        SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 10),),
        _buildInformationRow(
          StringConstants.from,
          "$startPoint (${StringConstants.need} ${distanceToCustomer}km - ${timeEstimateToCustomer}p "
              "${StringConstants.from.toLowerCase()} ${StringConstants.you.toLowerCase()})",
        ),
        SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 10),),
        _buildInformationRow(
          StringConstants.arrive,
          "$endPoint (${StringConstants.need} ${distance}km - ${timeEstimate}p "
              "${StringConstants.from.toLowerCase()} ${StringConstants.customer.toLowerCase()})",
        ),
        SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 20),),
      ],
    );
  }
}
