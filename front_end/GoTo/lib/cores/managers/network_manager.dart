import 'package:dio/dio.dart';
import 'package:go_to/configs/constants/dio_constants.dart';

class NetworkManager {
  static NetworkManager? _instance;
  Dio? _dioMapService;

  NetworkManager._privateConstructor();

  static NetworkManager getInstance() {
    _instance ??= NetworkManager._privateConstructor();
    return _instance!;
  }

  Dio getOpenRouteServiceDio() {
    _dioMapService ??= Dio(DioConstants.openRouteServiceOptions);
    return _dioMapService!;
  }
}