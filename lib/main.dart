// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/pages/login/login_controller.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_theme.dart';
import 'package:op_flutter/widgets/todolist/todolist.dart';
import 'routes/app_routes.dart';

void main() {
  Get.put(UserController(), permanent: true);
  Get.put(LoginController(), permanent: true); // permanent: true 保证不会被释放
  Get.put(TodoController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login Demo',
      theme: AppTheme.defaultTheme,
      initialRoute: AppRoutes.login, // 默认启动页
      getPages: AppPages.routes, // 路由表
    );
  }
}
