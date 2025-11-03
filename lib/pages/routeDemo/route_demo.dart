import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/widgets/todolist/todolist.dart';

/// 路由守卫：当 Todo 列表为空时禁止进入目标页
class TodoGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final todoCtrl = Get.find<TodoController>();
    if (todoCtrl.todos.isEmpty) {
      // 显示提示
      Future.microtask(() {
        Get.snackbar(
          '访问受限',
          '请先添加至少一个 Todo 项！',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      });
      return const RouteSettings(name: AppRoutes.routerWhat); // 返回当前页
    }
    return null; // 允许访问
  }
}

class RouteShowcasePage extends StatelessWidget {
  const RouteShowcasePage({super.key});

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Text(title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333))),
  );

  Widget _buildExampleButton(String text, VoidCallback onPressed) => Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: const Color(0xFF2563EB),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(text,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
    ),
  );

  Widget _buildCodeSnippet(String code) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFEBF1F5),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(code,
        style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            color: Color(0xFF333333))),
  );

  @override
  Widget build(BuildContext context) {
    final todoCtrl = Get.put(TodoController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX 路由管理演示'),
        backgroundColor: const Color(0xFFffffff),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildSectionTitle('🧭 基础导航'),
            _buildCodeSnippet("Get.to(NextPage());"),
            _buildExampleButton('跳转到下一个页面',
                    () => Get.to(const DemoPage(title: 'Next Page'))),
            _buildCodeSnippet("Get.back();"),
            _buildExampleButton('返回上一页', () => Get.back()),

            _buildSectionTitle('🪄 命名路由'),
            _buildCodeSnippet("Get.toNamed(AppRoutes.home);"),
            _buildExampleButton('跳转到首页 (命名路由)',
                    () => Get.toNamed(AppRoutes.home)),

            _buildSectionTitle('📦 路由守卫示例'),
            _buildExampleButton('尝试跳转 (受守卫保护)', () {
              Get.toNamed(AppRoutes.routerGuard);
            }),
            _buildCodeSnippet("""
class TodoGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final todoCtrl = Get.find<TodoController>();
    if (todoCtrl.todos.isEmpty) {
      Get.snackbar('访问受限', '请先添加至少一个 Todo 项！');
      return const RouteSettings(name: AppRoutes.routeShowcase);
    }
    return null;
  }
}
"""),

          ]),
        ),
      ),
    );
  }
}

class DemoPage extends StatelessWidget {
  final String title;
  const DemoPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('这是 $title', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text('参数: ${args ?? '无'}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('返回上一页'),
            ),
          ],
        ),
      ),
    );
  }
}
