import 'package:get/get.dart';
import 'package:op_flutter/store/user_controller.dart';

enum ScanMode {
  active,     // 主扫
  passive,    // 被扫
  both        // 主扫 & 被扫
}

class HomeController extends GetxController {
  final userController = Get.find<UserController>();
  final mode = ScanMode.both.obs;

  /// 获取当前应该显示的按钮
  List<HomeButtonType> get buttons {
    switch (mode.value) {
      case ScanMode.active:
        return [
          HomeButtonType.scan,
          HomeButtonType.transaction,
          HomeButtonType.failedTrans,
          HomeButtonType.voidPay,
          HomeButtonType.settlement,
        ];
      case ScanMode.passive:
        return [
          HomeButtonType.qrCode,
          HomeButtonType.transaction,
          HomeButtonType.failedTrans,
          HomeButtonType.settlement,
        ];
      case ScanMode.both:
        return [
          HomeButtonType.scan,
          HomeButtonType.qrCode,
          HomeButtonType.transaction,
          HomeButtonType.failedTrans,
          HomeButtonType.voidPay,
          HomeButtonType.settlement,
        ];
    }
  }
}

/// 按钮枚举
enum HomeButtonType {
  scan,
  qrCode,
  transaction,
  failedTrans,
  voidPay,
  settlement
}
