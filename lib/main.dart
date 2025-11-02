// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // 全局白色背景
        primarySwatch: Colors.blue,            // 可选，全局主题色
      ),
      initialRoute: AppRoutes.login, // 默认启动页
      getPages: AppPages.routes, // 路由表
    );
  }
}
