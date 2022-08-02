import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/route_constants.dart';
import 'package:go_to/views/pages/main_page/main_page.dart';
import 'package:go_to/views/pages/sign_in_page/sign_in_page.dart';
import 'package:go_to/views/pages/sign_up_page/sign_up_page.dart';

class AppPageRoute extends PageRouteBuilder {
  final Widget child;
  final bool reverseAnimation;

  AppPageRoute({
    required this.child, this.reverseAnimation = false,
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
        begin: !reverseAnimation ? const Offset(1, 0) : const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Route? onGenerateRoutes(RouteSettings settings) {
    AppPageRoute buildPageRoute(
        {required Widget child, bool reverseAnimation = false}) {
      return AppPageRoute(
        settings: settings, child: child, reverseAnimation: reverseAnimation,
      );
    }

    switch(settings.name) {
      case RouteConstants.signInRoute: {
        return buildPageRoute(child: const SignInPage(), reverseAnimation: true);
      }
      case RouteConstants.signUpRoute: {
        return buildPageRoute(child: const SignUpPage());
      }
      default: {
        return buildPageRoute(child: const MainPage());
      }
    }
  }
}