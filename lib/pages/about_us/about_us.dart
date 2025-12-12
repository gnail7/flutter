import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 模拟数据，可以替换成实际数据
    const appName = "OceanpayTest";
    const version = "2.6.0";
    const updateTime = "2025-04-18 16:50:28";
    const deviceId = "0820631392";
    const contact = "123";
    const about = "1234";

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
        backgroundColor: const Color(0xFF2AA75A),
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
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
                'images/oceanpay_logo.png', // 替换为你的 logo
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),

            // App 名称
            const Text(
              appName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // 版本号
            Text(
              "Version $version",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            // 信息列表
            _buildInfoRow("Update Time", updateTime),
            _buildInfoRow("Device ID", deviceId),
            _buildInfoRow("Contact", contact),
            _buildInfoRow("About Oceanpayment", about),

            const SizedBox(height: 40), // 底部留空

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
