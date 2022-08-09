import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/app_configs.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:latlong2/latlong.dart';

class MapField extends StatefulWidget {
  const MapField({
    Key? key, this.listMarker = const [], this.listPolyline = const [],
    this.mapController,
  }) : super(key: key);

  final List<Marker> listMarker;
  final List<Polyline> listPolyline;
  final MapController? mapController;

  @override
  State<MapField> createState() => _MapFieldState();
}

class _MapFieldState extends State<MapField> {
  double initialZoom = 14.0, maxZoom = 17.0;

  @override
  Widget build(BuildContext context) {
    final appConfigs = injector<AppConfig>();
    return SizedBox(
      height: DimenConstants.getScreenHeight(context) * 0.6,
      child: FlutterMap(
        mapController: widget.mapController,
        options: MapOptions(
          center: LatLng(appConfigs.centerLat, appConfigs.centerLng),
          controller: widget.mapController,
          zoom: initialZoom, maxZoom: maxZoom,
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
