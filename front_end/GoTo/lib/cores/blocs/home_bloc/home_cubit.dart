import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/app_configs.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/blocs/notification_bloc/notification_cubit.dart';
import 'package:go_to/cores/managers/location_manager.dart';
import 'package:go_to/models/infos/location_info.dart';
import 'package:latlong2/latlong.dart';

part 'home_state.dart';

abstract class HomeCubit<State> extends Cubit<State> {
  HomeCubit({required State state}) : super(state) {
    BuildContext? context = injector<AppConfig>().navigatorKey.currentContext;
    if (context != null) {
      notificationCubit = BlocProvider.of<NotificationCubit>(context);
      notificationCubit?.stream.listen((event) {
        onReceiveBookingResponse(event.message);
      });
    }
  }

  NotificationCubit? notificationCubit;

  void onReceiveBookingResponse(RemoteMessage? remoteMessage);

  Future<LatLng> getCurrentLocation() async {
    final currentPosition = await LocationManager.requestPermissionLocation();
    return LatLng(currentPosition.latitude, currentPosition.longitude);
  }
}
