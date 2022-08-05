import 'package:dio/dio.dart';

class DioConstants {
  //common constants
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 3000;

  //openRouteService constants
  static const openRouteServiceApiKey = "5b3ce3597851110001cf6248468b7465bf3342c680cb429d891e5f0a";
  static const openRouteServiceBaseUrl = "https://api.openrouteservice.org";
  static const openRouteServiceApiVer2 = "/v2";
  static const openRouteServiceActions = {
    "autocomplete": "/geocode/autocomplete",
    "directions": "/directions",
  };
  static const openRouteServiceVehicle = {
    "driving-car": "/driving-car",
  };
  static const openRouteServiceOutputType = {
    "json": "/json",
    "geojson": "/geojson",
  };
  static final openRouteServiceOptions = BaseOptions(
    baseUrl: openRouteServiceBaseUrl,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
  );
}

class RequestMethod {
  static const getMethod = "GET";
  static const postMethod = "POST";
}
