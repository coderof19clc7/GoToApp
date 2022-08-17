import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/enums/booking_status_enums.dart';
import 'package:go_to/configs/constants/enums/location_enums.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/client_home_page/blocs/client_home_cubit.dart';
import 'package:go_to/views/pages/main_page/widgets/home_widgets/booking_information_field/booking_information_field.dart';
import 'package:go_to/views/widgets/map_field/map_field.dart';
import 'package:go_to/views/widgets/input_fields/address_input_field/address_input_field.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientHomeCubit(),
      child: const ClientHomePageView(),
    );
  }
}

class ClientHomePageView extends StatefulWidget {
  const ClientHomePageView({Key? key}) : super(key: key);

  @override
  State<ClientHomePageView> createState() => _ClientHomePageViewState();
}

class _ClientHomePageViewState extends State<ClientHomePageView> {
  final mapController = MapController();
  final startTextEditingController = TextEditingController();
  final endTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientHomeCubit, ClientHomeState>(
      builder: (contextHome, state) {
        contextHome.read<ClientHomeCubit>().mapController = mapController;
        contextHome.read<ClientHomeCubit>().startTextEditingController = startTextEditingController;
        contextHome.read<ClientHomeCubit>().endTextEditingController = endTextEditingController;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: DimenConstants.getProportionalScreenHeight(context, 20),
              ),

              //input address field
              AddressInputField(
                enableInputField: (
                  state.clientBookingStatusEnums == ClientBookingStatusEnums.none
                  || state.clientBookingStatusEnums == ClientBookingStatusEnums.showBookingInfo
                ),
                startTextEditingController: startTextEditingController,
                startPointSuggestionApiFetching: (text) =>
                  contextHome.read<ClientHomeCubit>().getSuggestedList(LocationEnums.startPoint, text),
                startPointOnOptionSelected: (locationToAdd) async =>
                  await contextHome.read<ClientHomeCubit>().addMarker(locationToAdd),
                startPointOnClearText: () =>
                  contextHome.read<ClientHomeCubit>().removeMarker(LocationEnums.startPoint),
                endTextEditingController: endTextEditingController,
                endPointSuggestionApiFetching: (text) =>
                  contextHome.read<ClientHomeCubit>().getSuggestedList(LocationEnums.endPoint, text),
                endPointOnOptionSelected: (locationToAdd) async =>
                  await contextHome.read<ClientHomeCubit>().addMarker(locationToAdd),
                endPointOnClearText: () =>
                  contextHome.read<ClientHomeCubit>().removeMarker(LocationEnums.endPoint),
              ),
              SizedBox(
                height: DimenConstants.getProportionalScreenHeight(context, 20),
              ),

              //map field
              MapField(
                mapController: mapController,
                listMarker: state.listMarker ?? [],
                listPolyline: state.listPolyline ?? [],
              ),
              SizedBox(
                height: DimenConstants.getProportionalScreenHeight(context, 20),
              ),

              //booking information field
              const BookingInformationField(),
            ],
          ),
        );
      },
    );
  }
}
