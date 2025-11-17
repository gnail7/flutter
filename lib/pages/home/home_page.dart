import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/pages/home/home_button.dart';
import 'package:op_flutter/pages/home/home_controller.dart';
import 'package:op_flutter/routes/app_routes.dart';


class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ocean Payment"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Get.toNamed(AppRoutes.system);
          },
        ),
      ),

      body: Obx(() {
        final btns = controller.buttons;

        return Column(
          children: [
            const SizedBox(height: 40),

            /// --- 顶部特殊按钮（Scan / QR Code）---
            if (btns.contains(HomeButtonType.scan))
              HomeButton(
                title: "Scan",
                onTap: () => print("Scan"),
              ),
            if (btns.contains(HomeButtonType.qrCode))
              HomeButton(
                title: "QR Code",
                onTap: () => print("QR Code"),
              ),

            const SizedBox(height: 40),

            /// --- Grid 区域 ---
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  if (btns.contains(HomeButtonType.transaction))
                    HomeButton(title: "Transactions", onTap: () {}),

                  if (btns.contains(HomeButtonType.failedTrans))
                    HomeButton(title: "Failed Trans", onTap: () {}),

                  if (btns.contains(HomeButtonType.voidPay))
                    HomeButton(title: "Void", onTap: () {}),

                  if (btns.contains(HomeButtonType.settlement))
                    HomeButton(title: "Settlement", onTap: () {}),

                  if (btns.contains(HomeButtonType.settings))
                    HomeButton(title: "Set", onTap: () {}),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
