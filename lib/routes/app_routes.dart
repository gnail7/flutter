// lib/routes/app_pages.dart
import 'package:get/get.dart';
import '../pages/login/login_page.dart';

/// 所有路由路径定义
class AppRoutes {
  static const login = '/login';
  static const home = '/home';
}

/// 所有路由页面配置
class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login, // 路由路径
      page: () => const LoginPage(), // 对应页面
    ),
  ];
}
