import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/app_configs.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/views/pages/main_page/blocs/main_cubit.dart';
import 'package:go_to/views/pages/main_page/widgets/drawer_widget.dart';
import 'package:go_to/views/pages/main_page/widgets/title_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              ),
            ),
          );
        },
      ),
    );
  }

}