import 'package:flutter/material.dart';

class SystemInfoPage extends StatelessWidget {
  const SystemInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // ===== 顶部绿色背景 =====
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff4CAF50),
                  Color(0xff66BB6A),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 30),
                Text(
                  "System Information",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 45, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===== 菜单列表 =====
          Expanded(
            child: ListView(
              children: [
                _menuItem(
                  icon: Icons.settings,
                  color: Colors.blue,
                  title: "Settings",
                  onTap: () {},
                ),

                _menuItem(
                  icon: Icons.lock,
                  color: Colors.red,
                  title: "Reset Password",
                  onTap: () {},
                ),

                _menuItem(
                  icon: Icons.receipt_long,
                  color: Colors.orange,
                  title: "Operation Log",
                  onTap: () {},
                ),

                _menuItem(
                  icon: Icons.list,
                  color: Colors.amber,
                  title: "Order Log",
                  onTap: () {},
                ),

                _menuItem(
                  icon: Icons.info,
                  color: Colors.deepOrange,
                  title: "About Us",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ------- 单个菜单 Item -------
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
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
