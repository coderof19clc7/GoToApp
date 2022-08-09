import 'package:flutter/material.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/models/infos/user_info.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/client_home_page/client_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (injector<UserInfo>().type?.toLowerCase().compareTo("Customer".toLowerCase()) == 0) {
      return const ClientHomePage();
    }
    return Container();
  }
}
