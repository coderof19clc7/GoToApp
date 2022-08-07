import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/enums/location_enums.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/blocs/home_cubit.dart';
import 'package:go_to/views/pages/main_page/widgets/home_widgets/booking_information_field/booking_information_field.dart';
import 'package:go_to/views/widgets/map_field/map_field.dart';
import 'package:go_to/views/widgets/input_fields/address_input_field/address_input_field.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (contextHome, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: DimenConstants.getProportionalScreenHeight(context, 20),
              ),

              //input address field
              AddressInputField(
                startPointSuggestionApiFetching: (text) =>
                  contextHome.read<HomeCubit>().getSuggestedList(LocationEnums.startPoint, text),
                startPointOnOptionSelected: (locationToAdd) async =>
                  await contextHome.read<HomeCubit>().addMarker(locationToAdd),
                startPointOnClearText: () =>
                  contextHome.read<HomeCubit>().removeMarker(LocationEnums.startPoint),
                endPointSuggestionApiFetching: (text) =>
                  contextHome.read<HomeCubit>().getSuggestedList(LocationEnums.endPoint, text),
                endPointOnOptionSelected: (locationToAdd) async =>
                  await contextHome.read<HomeCubit>().addMarker(locationToAdd),
                endPointOnClearText: () =>
                  contextHome.read<HomeCubit>().removeMarker(LocationEnums.endPoint),
              ),
              SizedBox(
                height: DimenConstants.getProportionalScreenHeight(context, 20),
              ),

              //map field
              MapField(
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
