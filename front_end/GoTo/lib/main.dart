
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/app_configs.dart';
import 'package:go_to/configs/app_page_route.dart';
import 'package:go_to/configs/constants/route_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/blocs/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  BlocOverrides.runZoned(
    () => runApp(const MyApp(),),
    blocObserver: AppBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appConfig = injector<AppConfig>();
    return MaterialApp(
      onGenerateRoute: AppPageRoute.onGenerateRoutes,
      initialRoute: appConfig.initialRoute,
      debugShowCheckedModeBanner: appConfig.debugTag,
    );
  }
}
