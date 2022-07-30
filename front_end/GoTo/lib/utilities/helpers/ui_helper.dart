import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/route_constants.dart';
import 'package:go_to/views/pages/sign_in_page/sign_in_page.dart';

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
        return buildCustomPageRoute(child: const SignInPage());
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

  static void _showToast(
      String? message, {
        Toast toastLength = Toast.LENGTH_LONG,
        ToastGravity toastGravity = ToastGravity.BOTTOM,
        int timeInSecForIosWeb = 1,
        double? fontSize = 14,
        Color? backgroundColor,
        Color? textColor,
        bool webShowClose = false,
      }) {
    if (message?.isNotEmpty == true) {
      Fluttertoast.showToast(
        msg: message!,
        toastLength: toastLength,
        gravity: toastGravity,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
        webShowClose: webShowClose,
      );
    }
  }
  static void showErrorToast(String? message) => _showToast(message, backgroundColor: ColorConstants.baseRed);
  static void showSuccessToast(String? message) => _showToast(message, backgroundColor: ColorConstants.baseGreen);
  static void showNormalToast(String? message) => _showToast(message, backgroundColor: ColorConstants.baseBlack);
}
