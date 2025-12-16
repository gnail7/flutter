import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/store/user_controller.dart';

class SystemInfoPage extends StatelessWidget {
  const SystemInfoPage({super.key});

  @override
  Widget build(BuildContext context) {

    final String userRole = "operator"; // admin / operator / employee

    // 菜单配置（权限写在 allowedRoles）
    final List<_SystemMenu> menuItems = [
      _SystemMenu(
        title: "Settings",
        icon: Icons.settings,
        color: Colors.blue,
        allowedRoles: ["admin"],
        onTap: () {},
      ),
      _SystemMenu(
        title: "Reset Password",
        icon: Icons.lock,
        color: Colors.red,
        allowedRoles: ["operator", "employee"],
        onTap: () {
          Get.toNamed(AppRoutes.resetPassword);
        },
      ),
      _SystemMenu(
        title: "User Management",
        icon: Icons.supervised_user_circle,
        color: Colors.green,
        allowedRoles: ["operator"],
        onTap: () {},
      ),
      _SystemMenu(
        title: "Operation Log",
        icon: Icons.receipt_long,
        color: Colors.orange,
        allowedRoles: [ "operator","employee"],
        onTap: () {},
      ),
      _SystemMenu(
        title: "About Us",
        icon: Icons.info,
        color: Colors.deepOrange,
        allowedRoles: [ "operator", "employee"],
        onTap: () {
          Get.toNamed(AppRoutes.aboutUs);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),

          const SizedBox(height: 20),

          // ===== 菜单区域 =====
          Expanded(
            child: ListView(
              children: menuItems
                  .where((item) => item.allowedRoles.contains(userRole))
                  .map((item) => _menuItem(
                icon: item.icon,
                title: item.title,
                color: item.color,
                onTap: item.onTap,
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ===== 顶部 UI  =====
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff4CAF50), Color(0xff66BB6A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "System Information",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 45, color: Colors.grey),
                ),
              ],
            ),
          ),

          // 返回按钮
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white70,
                child: Icon(Icons.arrow_back, color: Colors.black, size: 20),
              ),
            ),
          ),
          // 退出按钮
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () async {
                await UserController.to.logout(); // 调用退出登录
                // Get.offAllNamed(AppRoutes.login); // 跳转到登录页并清空路由栈
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white70,
                child: Icon(Icons.logout, color: Colors.red, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 统一的菜单 item UI
  Widget _menuItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}

// 权限配置集中管理
class _SystemMenu {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> allowedRoles;
  final VoidCallback onTap;

  _SystemMenu({
    required this.title,
    required this.icon,
    required this.color,
    required this.allowedRoles,
    required this.onTap,
  });
}
