import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/constants/dio_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/managers/network_manager.dart';
import 'package:go_to/models/ors_outputs/autocomplete_output.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final dioOpenRouteService = injector<NetworkManager>().getOpenRouteServiceDio();

  Future<void> getSuggestedList(int locationIndex, String inputText) async {
    final result = AutocompleteOutput.fromJson(await dioOpenRouteService.get(
      "${DioConstants.openRouteServiceBaseUrl}${DioConstants.openRouteServiceActions["autocomplete"]}?"
          "api_key=${DioConstants.openRouteServiceApiKey}&text=$inputText",
    ));

    print(result);
  }
}
