import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_to/configs/constants/route_constants.dart';
import 'package:go_to/views/pages/login_page/login_page.dart';

// Future<bool> checkInternetConnection() async {
//   return await InternetConnectionChecker().hasConnection;
// }

// void clearCacheCookies(WebViewController controller) {
//   controller.clearCache();
//   CookieManager().clearCookies();
// }

class UIHelper {
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



  static void hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  static void hideKeyboardNoContext() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
