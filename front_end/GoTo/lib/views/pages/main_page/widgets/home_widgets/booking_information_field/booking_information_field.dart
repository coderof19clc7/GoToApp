import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/enums/booking_status_enums.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/blocs/home_cubit.dart';
import 'package:go_to/views/pages/main_page/widgets/home_widgets/booking_information_field/widgets/show_booking_information.dart';
import 'package:go_to/views/widgets/buttons/rounded_rectangle_ink_well_button.dart';

class BookingInformationField extends StatelessWidget {
  const BookingInformationField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
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
              _buildChild(context, contextHome.read<HomeCubit>(), state,),

              SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 30),),

              if (state.clientBookingStatusEnums == ClientBookingStatusEnums.showBookingInfo
                || state.clientBookingStatusEnums == ClientBookingStatusEnums.finding
                || state.clientBookingStatusEnums == ClientBookingStatusEnums.driverFound
              )...[
                _buildButton(context, contextHome.read<HomeCubit>(), state),
              ]
            ],
          ),
        );
      }
    );
  }

  Widget _buildChild(BuildContext context, HomeCubit cubit, HomeState state) {
    switch(state.clientBookingStatusEnums) {
      case ClientBookingStatusEnums.showBookingInfo:
        return ShowBookingInformation(
          startPoint: state.mapChosenSuggested?["startPoint"]?.name ?? "",
          endPoint: state.mapChosenSuggested?["endPoint"]?.name ?? "",
          timeEstimate: state.timeEstimate.toString(),
          distance: state.distance.toString(),
        );
      case ClientBookingStatusEnums.finding:
        return const SizedBox();
      case ClientBookingStatusEnums.driverFound:
        return const SizedBox();
      case ClientBookingStatusEnums.canceled:
        return const SizedBox();
      case ClientBookingStatusEnums.driverCanceled:
        return const SizedBox();
      default: return const SizedBox();
    }
  }

  Widget _buildButton(BuildContext context, HomeCubit cubit, HomeState state) {
    final isShowInfoStatus = state.clientBookingStatusEnums == ClientBookingStatusEnums.showBookingInfo;
    return RoundedRectangleInkWellButton(
      width: DimenConstants.getScreenWidth(context),
      height: DimenConstants.getProportionalScreenHeight(context, 60),
      paddingVertical: DimenConstants.getProportionalScreenHeight(context, 10),
      bgLinearGradient: isShowInfoStatus ? LinearGradient(colors: ColorConstants.defaultOrangeList) : null,
      bgColor: ColorConstants.baseGrey,
      onTap: () {
        if (isShowInfoStatus) {
          cubit.booking();
        }
        else {
          cubit.canceling();
        }
      },
      child: Text(
        isShowInfoStatus ? StringConstants.booking : StringConstants.cancel,
        style: TextStyle(
          color: isShowInfoStatus ? Colors.white : ColorConstants.baseBlack,
          fontSize: DimenConstants.getProportionalScreenWidth(context, 25),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}