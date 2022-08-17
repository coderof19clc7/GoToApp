import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/enums/booking_status_enums.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/client_home_page/blocs/client_home_cubit.dart';
import 'package:go_to/views/pages/main_page/widgets/home_widgets/booking_information_field/widgets/show_booking_information.dart';
import 'package:go_to/views/pages/main_page/widgets/home_widgets/booking_information_field/widgets/text_only_info_widget.dart';
import 'package:go_to/views/widgets/buttons/rounded_rectangle_ink_well_button.dart';

class BookingInformationField extends StatelessWidget {
  const BookingInformationField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientHomeCubit, ClientHomeState>(
      builder: (contextHome, state) {
        if (state.clientBookingStatusEnums == ClientBookingStatusEnums.none) {
          return const SizedBox();
        }
        return Container(
          width: DimenConstants.baseWidth,
          padding: EdgeInsets.only(
            left: DimenConstants.getProportionalScreenWidth(context, 17),
            right: DimenConstants.getProportionalScreenWidth(context, 17),
            bottom: DimenConstants.getProportionalScreenWidth(context, 30),
          ),
          child: Column(
            children: [
              Container(
                width: DimenConstants.baseWidth,
                constraints: BoxConstraints(
                  minHeight: DimenConstants.getProportionalScreenHeight(context, 200),
                ),
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
                child: _buildChild(context, contextHome.read<ClientHomeCubit>(), state,),
              ),

              SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 30),),

              if (state.clientBookingStatusEnums != ClientBookingStatusEnums.none) ...[
                _buildButton(context, contextHome.read<ClientHomeCubit>(), state),
              ]
            ],
          ),
        );
      }
    );
  }

  Widget _buildChild(BuildContext context, ClientHomeCubit cubit, ClientHomeState state) {
    switch(state.clientBookingStatusEnums) {
      case ClientBookingStatusEnums.showBookingInfo: {
        final startPointName = state.mapChosenSuggested?["startPoint"]?.name ?? "";
        final endPointName = state.mapChosenSuggested?["endPoint"]?.name ?? "";

        return ShowBookingInformation(
          startPoint: startPointName.contains(StringConstants.yourLocation)
              ? StringConstants.yourLocation : startPointName,
          endPoint: endPointName.contains(StringConstants.yourLocation)
              ? StringConstants.yourLocation : endPointName,
          timeEstimate: state.timeEstimate.toString(),
          distance: state.distance.toString(),
        );
      }
      case ClientBookingStatusEnums.finding:
        return const TextOnlyInformationWidget(text: StringConstants.findingDriver,);
      case ClientBookingStatusEnums.driverFound:
        return TextOnlyInformationWidget(
          text: "${StringConstants.driver} ${state.driverName ?? ""} "
              "(${state.driverPhone ?? ""}) ${StringConstants.willPickYouUp}",
        );
      case ClientBookingStatusEnums.driverArrived:
        return const TextOnlyInformationWidget(text: StringConstants.driverArrived,);
      case ClientBookingStatusEnums.finished:
        return TextOnlyInformationWidget(
          text: "${StringConstants.had} ${StringConstants.arrive.toLowerCase()} "
              "${StringConstants.endPoint.toLowerCase()} ${StringConstants.you.toLowerCase()} "
              "${StringConstants.booking.toLowerCase().split(" ")[0]}.",
        );
      default: return const SizedBox();
    }
  }

  Widget _buildButton(BuildContext context, ClientHomeCubit cubit, ClientHomeState state) {
    final isShowInfoStatus = state.clientBookingStatusEnums == ClientBookingStatusEnums.showBookingInfo;
    final isFinished = state.clientBookingStatusEnums == ClientBookingStatusEnums.finished;
    return RoundedRectangleInkWellButton(
      width: DimenConstants.getScreenWidth(context),
      height: DimenConstants.getProportionalScreenHeight(context, 60),
      paddingVertical: DimenConstants.getProportionalScreenHeight(context, 10),
      bgLinearGradient: isShowInfoStatus ? LinearGradient(colors: ColorConstants.defaultOrangeList) : null,
      bgColor: ColorConstants.grey,
      onTap: () {
        if (isShowInfoStatus) {
          cubit.booking();
        }
        else if (isFinished) {
          cubit.clearBookingInformation();
        }
        else {
          cubit.canceling();
        }
      },
      child: Text(
        isShowInfoStatus ? StringConstants.booking : (isFinished ? " OK" : StringConstants.cancel),
        style: TextStyle(
          color: isShowInfoStatus ? Colors.white : ColorConstants.baseGrey,
          fontSize: DimenConstants.getProportionalScreenWidth(context, 25),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}