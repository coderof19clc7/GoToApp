import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/cores/managers/location_manager.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/driver_home_page/blocs/driver_home_cubit.dart';
import 'package:go_to/views/pages/main_page/widgets/home_widgets/customer_booking_information_field/customer_booking_information_field.dart';
import 'package:go_to/views/widgets/map_field/map_field.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverHomeCubit(),
      child: const DriverHomePageView(),
    );
  }
}

class DriverHomePageView extends StatefulWidget {
  const DriverHomePageView({Key? key}) : super(key: key);

  @override
  State<DriverHomePageView> createState() => _DriverHomePageViewState();
}

class _DriverHomePageViewState extends State<DriverHomePageView> {
  final mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverHomeCubit, DriverHomeState>(
      builder: (contextHome, state) {
        contextHome.read<DriverHomeCubit>().mapController = mapController;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: DimenConstants.getProportionalScreenHeight(context, 20),
              ),

              //map field
              MapField(
                mapController: mapController,
                initialCenterLat: LocationManager.currentPosition?.latitude,
                initialCenterLng: LocationManager.currentPosition?.longitude,
                listMarker: state.listMarker ?? [],
                listPolyline: state.listPolyline ?? [],
              ),
              SizedBox(
                height: DimenConstants.getProportionalScreenHeight(context, 20),
              ),

              //customer booking information field
              const CustomerBookingInformationField(),
            ],
          ),
        );
      },
    );
  }
}