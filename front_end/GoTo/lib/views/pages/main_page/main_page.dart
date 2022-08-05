import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';
import 'package:go_to/views/pages/main_page/blocs/main_cubit.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/home_page.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/test_pages/test_map_controller_page.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/test_pages/test_map_live_location.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/test_pages/test_map_polyline.dart';
import 'package:go_to/views/pages/main_page/widgets/drawer_widget.dart';
import 'package:go_to/views/pages/main_page/widgets/title_widget.dart';

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

}