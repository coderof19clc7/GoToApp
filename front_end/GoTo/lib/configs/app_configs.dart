import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_to/configs/constants/keys/storage_keys.dart';
import 'package:go_to/configs/constants/route_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/managers/local_storage_manager.dart';
import 'package:go_to/utilities/extensions/string_extensions.dart';
import 'package:go_to/utilities/extensions/string_extensions.dart';

const String envPath = ".env";

class AppConfig{
  String? baseUrl, initialRoute;
  String appName = "", openStreetMapUrl = "";
  double centerLat = 0, centerLng = 0;
  bool debugTag = false;
  int cacheDuration = 100;

  AppConfig._init();

  static Future<AppConfig> getInstance() async{
    final appConfig = AppConfig._init();
    return appConfig._loadConfig();
  }

  Future<AppConfig> _loadConfig() async {
    try{
      await dotenv.load(fileName: envPath);
      openStreetMapUrl = dotenv.env["openStreetMapUrl"] ?? "";
      centerLat = (dotenv.env["hcmLat"] ?? "0").toDouble();
      centerLng = (dotenv.env["hcmLng"] ?? "0").toDouble();
    } catch(e) {
      if (kDebugMode) {
        print(e);
      }
    }



    //initial route
    final accessToken = injector<LocalStorageManager>().getString(LocalStorageKeys.accessToken);
    if (accessToken?.isNotEmpty == true) {
      initialRoute = RouteConstants.mainRoute;
    } else {
      // initialRoute = RouteConstants.signInRoute;
      initialRoute = RouteConstants.mainRoute;
    }

    return this;
  }
}