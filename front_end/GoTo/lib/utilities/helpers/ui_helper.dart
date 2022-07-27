import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/route_constants.dart';
import 'package:go_to/views/pages/login_page/login_page.dart';

// Future<bool> checkInternetConnection() async {
//   return await InternetConnectionChecker().hasConnection;
// }

// void clearCacheCookies(WebViewController controller) {
//   controller.clearCache();
//   CookieManager().clearCookies();
// }

Route? generateRoutes(RouteSettings settings) {
  MaterialPageRoute buildCustomPageRoute(
      {required Widget child, String? directionTransition, String? animationType}) {
    return MaterialPageRoute(
      settings: settings, builder: (context) => child,
    );
  }

  switch(settings.name) {
    case RouteConstants.signInRoute: {
      return buildCustomPageRoute(child: const LoginPage());
    }
    default: {
      return null;
    }
  }
}