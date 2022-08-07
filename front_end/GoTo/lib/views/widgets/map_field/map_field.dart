import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/app_configs.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/blocs/home_cubit.dart';
import 'package:latlong2/latlong.dart';

class MapField extends StatefulWidget {
  const MapField({
    Key? key, this.listMarker = const [], this.listPolyline = const [],
  }) : super(key: key);

  final List<Marker> listMarker;
  final List<Polyline> listPolyline;

  @override
  State<MapField> createState() => _MapFieldState();
}

class _MapFieldState extends State<MapField> {
  MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {
    final appConfigs = injector<AppConfig>();
    return SizedBox(
      height: DimenConstants.getScreenHeight(context) * 0.6,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(appConfigs.centerLat, appConfigs.centerLng),
          zoom: 17.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: appConfigs.openStreetMapUrl,
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: widget.listMarker,
          ),
          PolylineLayerOptions(
            polylines: widget.listPolyline,
          ),
        ],
      ),
    );
  }
}
