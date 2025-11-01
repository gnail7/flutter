

import 'package:get/get.dart';
import 'package:op_flutter/pages/home/home_page.dart';
import 'package:op_flutter/pages/login/login_page.dart';
import 'package:op_flutter/routes/app_routes.dart';

class AppPage {
  static final routes = {
    GetPage (
      name: AppRoutes.login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage()
    )
  };
}