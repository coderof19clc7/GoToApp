import 'package:dio/dio.dart';
import 'package:go_to/configs/constants/network_constants/dio_constants.dart';

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

  Future<Map<String, dynamic>?> request(Dio dio, String method, String path,
      {Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? data,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? extra}) async {
    final result = await dio.request(path,
        queryParameters: queryParameters ?? <String, dynamic>{},
        options: Options(method: method, headers: headers, extra: extra),
        data: data);
    return result.data;
  }
}