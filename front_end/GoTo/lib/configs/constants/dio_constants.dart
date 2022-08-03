import 'package:dio/dio.dart';

class DioConstants {
  //common constants
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 3000;

  //openRouteService constants
  static const openRouteServiceApiKey = "5b3ce3597851110001cf6248468b7465bf3342c680cb429d891e5f0a";
  static const openRouteServiceBaseUrl = "https://api.openrouteservice.org";
  static const openRouteServiceActions = {
    "autocomplete": "/geocode/autocomplete",
  };
  static final openRouteServiceOptions = BaseOptions(
    baseUrl: openRouteServiceBaseUrl,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
  );
}
