import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/route_constants.dart';
import 'package:go_to/views/pages/sign_in_page/sign_in_page.dart';
import 'package:go_to/views/pages/sign_up_page/sign_up_page.dart';

class AppPageRoute extends PageRouteBuilder {
  final Widget child;

  AppPageRoute({
    required this.child,
    super.settings
  }) : super(
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Route? onGenerateRoutes(RouteSettings settings) {
    AppPageRoute buildPageRoute(
        {required Widget child, String? directionTransition, String? animationType}) {
      return AppPageRoute(
        settings: settings, child: child,
      );
    }

    switch(settings.name) {
      case RouteConstants.signInRoute: {
        return buildPageRoute(child: const SignInPage());
      }
      case RouteConstants.signUpRoute: {
        return buildPageRoute(child: const SignUpPage());
      }
      default: {
        return null;
      }
    }
  }
}