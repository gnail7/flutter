  // lib/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:op_flutter/pages/home/home_page.dart';
import 'package:op_flutter/pages/system_info/system_page.dart';
import '../pages/login/login_page.dart';

  /// 所有路由路径定义
  class AppRoutes {
    static const login = '/login';
    static const home = '/home';
    static const system = '/system';
  }

  /// 所有路由页面配置
  class AppPages {
    static final routes = [
      GetPage(
        name: AppRoutes.login, // 路由路径
        page: () => OceanpayLoginPage(), // 对应页面
      ),
      GetPage(
        name: AppRoutes.home, // 路由路径
        page: () => HomePage(), // 对应页面
      ),
      GetPage(name: AppRoutes.system, page: ()=> SystemInfoPage(),)
    ];
  }
