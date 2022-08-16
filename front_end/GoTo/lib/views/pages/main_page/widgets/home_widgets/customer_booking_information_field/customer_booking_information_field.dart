import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/enums/booking_status_enums.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/driver_home_page/blocs/driver_home_cubit.dart';
import 'package:go_to/views/pages/main_page/widgets/home_widgets/customer_booking_information_field/widgets/customer_booking_information.dart';
import 'package:go_to/views/widgets/buttons/rounded_rectangle_ink_well_button.dart';

class CustomerBookingInformationField extends StatelessWidget {
  const CustomerBookingInformationField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverHomeCubit, DriverHomeState>(
      builder: (contextHome, state) {
        if (state.driverBookingStatusEnums == DriverBookingStatusEnums.none) {
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
                child: _buildChild(context, contextHome.read<DriverHomeCubit>(), state,),
              ),

              SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 30),),

              if (state.driverBookingStatusEnums == DriverBookingStatusEnums.clientFound
                  || state.driverBookingStatusEnums == DriverBookingStatusEnums.accepted
                  || state.driverBookingStatusEnums == DriverBookingStatusEnums.clientPickedUp
              )...[
                _buildButton(context, contextHome.read<DriverHomeCubit>(), state),
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildChild(BuildContext context, DriverHomeCubit cubit, DriverHomeState state) {
    switch(state.driverBookingStatusEnums) {
      case DriverBookingStatusEnums.clientFound:
      case DriverBookingStatusEnums.accepted:
      case DriverBookingStatusEnums.clientPickedUp:
      case DriverBookingStatusEnums.finished:
        return CustomerBookingInformation(
          customerName: state.customerName ?? "",
          customerPhone: state.customerPhone ?? "",
          startPoint: state.mapChosenSuggested?["startPoint"]?.name ?? "",
          endPoint: state.mapChosenSuggested?["endPoint"]?.name ?? "",
          timeEstimate: state.timeEstimate.toString(),
          distance: state.distance.toString(),
          timeEstimateToCustomer: state.timeEstimateToCustomer.toString(),
          distanceToCustomer: state.driverBookingStatusEnums.toString(),
        );
      default: return const SizedBox();
    }
  }

  Widget _buildButton(BuildContext context, DriverHomeCubit cubit, DriverHomeState state) {
    final hasTwoBtn = state.driverBookingStatusEnums == DriverBookingStatusEnums.clientFound;
    late String mainBtnText;
    switch(state.driverBookingStatusEnums) {
      case DriverBookingStatusEnums.accepted:{
        mainBtnText = "${StringConstants.had} ${StringConstants.pickUp} ${StringConstants.customer}";
        break;
      }
      case DriverBookingStatusEnums.clientFound: {
        mainBtnText = StringConstants.accept;
        break;
      }
      case DriverBookingStatusEnums.clientPickedUp: {
        mainBtnText = "${StringConstants.had} ${StringConstants.arrive} ${StringConstants.endPoint}";
        break;
      }
      default: {
        mainBtnText = "";
        break;
      }
    }
    return Row(
      children: [
        if (hasTwoBtn) ...[
          RoundedRectangleInkWellButton(
            width: DimenConstants.getScreenWidth(context) * 0.4,
            height: DimenConstants.getProportionalScreenHeight(context, 60),
            paddingVertical: DimenConstants.getProportionalScreenHeight(context, 10),
            bgColor: ColorConstants.baseGrey,
            onTap: () {
              cubit.onBookingOrderCanceled("reject");
            },
            child: Text(
              StringConstants.reject,
              style: TextStyle(
                color: ColorConstants.baseBlack,
                fontSize: DimenConstants.getProportionalScreenWidth(context, 20),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: DimenConstants.getScreenWidth(context) * 0.2,),
        ],

        RoundedRectangleInkWellButton(
          width: hasTwoBtn
              ? DimenConstants.getScreenWidth(context) * 0.4
              : DimenConstants.getScreenWidth(context),
          height: DimenConstants.getProportionalScreenHeight(context, 60),
          paddingVertical: DimenConstants.getProportionalScreenHeight(context, 10),
          bgLinearGradient: LinearGradient(colors: ColorConstants.defaultOrangeList),
          onTap: () {
            switch(state.driverBookingStatusEnums) {
              case DriverBookingStatusEnums.accepted:
                print('user picked up or arrived end point');
                break;
              case DriverBookingStatusEnums.clientFound:
                cubit.onAcceptBookingOrder();
                break;
              case DriverBookingStatusEnums.clientPickedUp:
                cubit.onFinishTrip();
                break;
              default: break;
            }
          },
          child: Text(
            mainBtnText,
            style: TextStyle(
              color: ColorConstants.baseWhite,
              fontSize: DimenConstants.getProportionalScreenWidth(context, hasTwoBtn ? 20 : 25),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
