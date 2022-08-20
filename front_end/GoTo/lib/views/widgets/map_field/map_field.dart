import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:go_to/configs/app_configs.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/models/infos/user_info.dart';
import 'package:latlong2/latlong.dart';

class MapField extends StatefulWidget {
  const MapField({
    Key? key, this.listMarker = const [], this.listPolyline = const [],
    this.mapController, this.initialCenterLat, this.initialCenterLng,
    this.initialZoom = 14.0, this.maxZoom = 17.0,
  }) : super(key: key);

  final List<Marker> listMarker;
  final List<Polyline> listPolyline;
  final MapController? mapController;
  final double? initialCenterLat;
  final double? initialCenterLng;
  final double initialZoom, maxZoom;

  @override
  State<MapField> createState() => _MapFieldState();
}

class _MapFieldState extends State<MapField> {
  @override
  Widget build(BuildContext context) {
    final appConfigs = injector<AppConfig>();
    final currentLocationSize = DimenConstants.getProportionalScreenWidth(context, 20);
    return SizedBox(
      height: DimenConstants.getScreenHeight(context) * 0.6,
      child: FlutterMap(
        mapController: widget.mapController,
        options: MapOptions(
          plugins: [
            const LocationMarkerPlugin(), // <-- add plugin here
          ],
          center: LatLng(
            widget.initialCenterLat ?? appConfigs.centerLat,
            widget.initialCenterLng ?? appConfigs.centerLng,
          ),
          controller: widget.mapController,
          zoom: widget.initialZoom, maxZoom: widget.maxZoom,
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
          if (injector<UserInfo>().type?.toLowerCase().compareTo(
              "Customer".toLowerCase()) != 0) ...[
            LocationMarkerLayerOptions(
              marker: DefaultLocationMarker(
                color: ColorConstants.orange,
              ),
              markerSize: Size(currentLocationSize, currentLocationSize),
              showAccuracyCircle: false,
              headingSectorRadius: 30,
              headingSectorColor: ColorConstants.baseOrangeAcent,
              moveAnimationDuration: const Duration(milliseconds: 100),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.mapController?.dispose();
    super.dispose();
  }
}
