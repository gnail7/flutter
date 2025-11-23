import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/pages/home/home_button.dart';
import 'package:op_flutter/pages/home/home_controller.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/theme/app_colors.dart';


class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ocean Payment",
          style: TextStyle(color: Colors.white), // 设置文字颜色为白色
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white, // 图标颜色改为白色
          ),
          onPressed: () {
            Get.toNamed(AppRoutes.system);
          },
        ),
        backgroundColor: AppColor.primaryBgColor,
      ),

      body: Obx(() {
        final btns = controller.buttons;

        return Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: AppColor.primaryBgColor, // 这里设置背景色
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 水平居中
                  children: [
                    if (btns.contains(HomeButtonType.scan))
                      HomeButton(
                        title: "Scan",
                        icon: getIconForButton(HomeButtonType.scan),
                        textColor: Colors.white,
                        backgroundColor: AppColor.primaryBgColor,
                        showBorder: false,
                        name: AppRoutes.transaction,
                      ),
                    if (btns.contains(HomeButtonType.qrCode))
                      HomeButton(
                        title: "QR Code",
                        icon: getIconForButton(HomeButtonType.qrCode),
                        textColor: Colors.white,
                        backgroundColor: AppColor.primaryBgColor,
                        showBorder: false,
                        name: AppRoutes.transaction,
                      ),
                  ],
                ),
              ),
            ),

            /// --- Grid 区域 ---
            Expanded(
              flex: 4,
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  if (btns.contains(HomeButtonType.transaction))
                    HomeButton(
                      title: "Search & Print",
                      icon: getIconForButton(HomeButtonType.transaction),
                      iconColor: AppColor.primaryBgColor,
                      name: AppRoutes.transaction,
                    ),

                  if (btns.contains(HomeButtonType.failedTrans))
                    HomeButton(
                      title: "Failed Trans",
                      icon: getIconForButton(HomeButtonType.failedTrans),
                      iconColor: AppColor.errorColor,
                      name: AppRoutes.transaction,
                    ),

                  if (btns.contains(HomeButtonType.voidPay))
                    HomeButton(
                      title: "Void",
                      icon: getIconForButton(HomeButtonType.voidPay),
                      name: AppRoutes.transaction,
                    ),

                  if (btns.contains(HomeButtonType.settlement))
                    HomeButton(
                      title: "Settlement",
                      icon: getIconForButton(HomeButtonType.settlement),
                      iconColor: AppColor.warningColor,
                      name: AppRoutes.transaction,
                    ),

                  if (btns.contains(HomeButtonType.settings))
                    HomeButton(
                      title: "Set",
                      icon: getIconForButton(HomeButtonType.settings),
                      name: AppRoutes.transaction,
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}


/// 获取对应按钮图标
IconData? getIconForButton(HomeButtonType type) {
  switch (type) {
    case HomeButtonType.scan:
      return Icons.qr_code_scanner;
    case HomeButtonType.qrCode:
      return Icons.qr_code;
    case HomeButtonType.settings:
      return Icons.settings;
    case HomeButtonType.transaction:
      return Icons.payment;
    case HomeButtonType.failedTrans:
      return Icons.warning;
    case HomeButtonType.voidPay:
      return Icons.cancel;
    case HomeButtonType.settlement:
      return Icons.account_balance_wallet;
  }
}
