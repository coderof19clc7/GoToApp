import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/app_configs.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/blocs/home_cubit.dart';
import 'package:latlong2/latlong.dart';

class MapField extends StatefulWidget {
  const MapField({
    Key? key,
  }) : super(key: key);

  @override
  State<MapField> createState() => _MapFieldState();
}

class _MapFieldState extends State<MapField> {
  @override
  Widget build(BuildContext context) {
    final appConfigs = injector<AppConfig>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (contextHome, state) {
        return SizedBox(
          height: DimenConstants.getScreenHeight(context) * 0.6,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(appConfigs.centerLat, appConfigs.centerLng),
              zoom: 8.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: appConfigs.openStreetMapUrl,
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: state.listMarker ?? [],
              ),
              PolylineLayerOptions(
                polylines: state.listPolyline ?? [],
              ),
            ],
          ),
        );
      },
    );
  }
}
