import 'package:dio/dio.dart';
import 'package:go_to/configs/constants/network_constants/open_route_service_constants.dart';

class DioConstants {
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 15000;

  static final openRouteServiceApiPaths = {
    "autocompletePath": "${OpenRouteServiceConstants.baseUrl}"
        "${OpenRouteServiceConstants.actions["autocomplete"]}?",
    "geocodeReversePath": "${OpenRouteServiceConstants.baseUrl}"
      "${OpenRouteServiceConstants.actions["geocodeReverse"]}?",
    "directionPath": "${OpenRouteServiceConstants.baseUrl}"
        "${OpenRouteServiceConstants.apiVer2}"
        "${OpenRouteServiceConstants.actions["directions"]}"
        "${OpenRouteServiceConstants.vehicles["driving-car"]}"
        "${OpenRouteServiceConstants.outputTypes["geojson"]}",
  };
  static final openRouteServiceOptions = BaseOptions(
    baseUrl: OpenRouteServiceConstants.baseUrl,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
  );
}

class RequestMethod {
  static const getMethod = "GET";
  static const postMethod = "POST";
}
