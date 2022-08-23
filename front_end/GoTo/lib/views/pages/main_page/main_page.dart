import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/app_configs.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/keys/storage_keys.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/managers/local_storage_manager.dart';
import 'package:go_to/models/infos/user_info.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';
import 'package:go_to/views/pages/main_page/blocs/main_cubit.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/test_pages/test_map_controller_page.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/test_pages/test_map_live_location.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/test_pages/test_map_polyline.dart';
import 'package:go_to/views/pages/main_page/widgets/drawer_widget.dart';
import 'package:go_to/views/pages/main_page/widgets/title_widget.dart';

import 'widgets/child_pages/home_page/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  static const List<Widget> _widgetOptions = [
    HomePage(),
    // Text('Đây là profile'),
    // MapControllerPage(),
    // LiveLocationPage(),
    PolylinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    PageStorageBucket bucket = PageStorageBucket();
    _loadUserDataFromLocalStorage();

    return BlocProvider(
      create: (context) => MainCubit(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (contextCubit, state) {
          final cubit = contextCubit.read<MainCubit>();
          return SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Scaffold(
                appBar: AppBar(
                  title: const TitleWidget(),
                  centerTitle: true,
                  backgroundColor: ColorConstants.orange,
                ),
                drawer:  DrawerWidget(parentContext: context, parentCubit: cubit, parentState: state,),
                body: GestureDetector(
                  onTap: () => UIHelper.hideKeyboard(context),
                  child: PageStorage(
                    bucket: bucket,
                    child: _widgetOptions[state.currentIndex],
                  ),
                ),
                resizeToAvoidBottomInset: false,
              ),
            ),
          );
        },
      ),
    );
  }

  void _loadUserDataFromLocalStorage() {
    final localStorageManager = injector<LocalStorageManager>();
    injector<UserInfo>().setData(
      localStorageManager.getString(LocalStorageKeys.userID) ?? "ABCzyx",
      localStorageManager.getString(LocalStorageKeys.phoneNumber) ?? "123123123123",
      localStorageManager.getString(LocalStorageKeys.name) ?? "ABC",
      localStorageManager.getString(LocalStorageKeys.accountType) ?? "Customer",
    );
    print(injector<AppConfig>().deviceToken);
  }
}