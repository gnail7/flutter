import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String version = '';
  String deviceId = '';
  String appName = '';
  @override
  void initState() {
    super.initState();
    _initVersionAndDevice();
  }

  Future<void> _initVersionAndDevice() async {
    // 获取版本号
    final packageInfo = await PackageInfo.fromPlatform();
    // 获取设备ID（Android/iOS）
    final deviceInfo = DeviceInfoPlugin();
    String id = '';
    try {
      if (GetPlatform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        id = androidInfo.id;
      } else if (GetPlatform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        id = iosInfo.identifierForVendor ?? '';
      }
    } catch (e) {
      id = 'Unknown';
    }

    setState(() {
      version = packageInfo.version;
      deviceId = id;
      appName = packageInfo.appName;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 其他固定信息
    const updateTime = "2025-04-18 16:50:28";
    final contact = UserController.to.user.value?.companyContact;
    final about = UserController.to.user.value?.companyInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                'images/qr_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),

            // App 名称
            Text(
              appName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // 版本号（动态）
            Text(
              version.isEmpty ? "Loading..." : "Version $version",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            // 信息列表
            _buildInfoRow("Update Time", updateTime),
            _buildInfoRow("Device ID", deviceId.isEmpty ? "Loading..." : deviceId),
            _buildInfoRow("Contact", contact!),
            _buildInfoRow("About Oceanpayment", about!),

            const SizedBox(height: 40),

            // 版权信息
            const Center(
              child: Text(
                "Copyright © 2025 Oceanpayment All rights reserved.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
