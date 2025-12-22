import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/pages/system_info/merchant_info/merchant_info_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_SettingMenu> menuItems = [
      _SettingMenu(
        title: "Merchant Info",
        icon: Icons.store,
        color: Colors.blue,
        onTap: () {
          Get.to(() => const MerchantPageDemo());
        },
      ),
      _SettingMenu(
        title: "Trans Settings",
        icon: Icons.settings,
        color: Colors.orange,
        onTap: () {
          Get.toNamed('/trans_settings');
        },
      ),
      _SettingMenu(
        title: "System",
        icon: Icons.system_update_alt,
        color: Colors.green,
        onTap: () {
          Get.toNamed('/system');
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: menuItems
            .map((item) => _menuItem(
          icon: item.icon,
          title: item.title,
          color: item.color,
          onTap: item.onTap,
        ))
            .toList(),
      ),
    );
  }

  // 单行菜单样式
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

class _SettingMenu {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _SettingMenu({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
