import 'package:dio/dio.dart';
import 'package:go_to/configs/constants/network_constants/dio_constants.dart';
import 'package:go_to/configs/constants/network_constants/open_route_service_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/models/ors_outputs/autocomplete_output.dart';
import 'package:go_to/models/ors_outputs/direction_output.dart';
import 'package:latlong2/latlong.dart';

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

class ApiExecutor {
  static final _networkManager = injector<NetworkManager>();

  static Future<AutocompleteOutput> callORSAutocompleteApi(String inputText) async {
    return AutocompleteOutput.fromJson(await _networkManager.request(
      _networkManager.getOpenRouteServiceDio(), RequestMethod.getMethod,
      "${DioConstants.openRouteServiceApiPaths["autocompletePath"]}",
      queryParameters: {
        "api_key": OpenRouteServiceConstants.apiKey, "text": inputText,
      },
    ),);
  }

  static Future<DirectionOutput> callORSDirectionApi(List<List<double>> coordinateList) async {
    return DirectionOutput.fromJson(await _networkManager.request(
      _networkManager.getOpenRouteServiceDio(), RequestMethod.postMethod,
      "${DioConstants.openRouteServiceApiPaths["directionPath"]}",
      headers: {
        "Authorization": OpenRouteServiceConstants.apiKey,
        "Content-type": "application/json; charset=utf-8",
      },
      data: {"coordinates": coordinateList},
    ),);
  }
}
