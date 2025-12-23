import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/network/dio_manager.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_theme.dart';
import 'package:op_flutter/utils/simple_prefs.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SimplePrefs.instance.init();
  DioManager.init();
  Get.put(UserController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'pos demo',
      theme: AppTheme.defaultTheme,
      initialRoute: AppRoutes.login, // 默认启动页
      getPages: AppPages.routes, // 路由表
    );
  }
}
