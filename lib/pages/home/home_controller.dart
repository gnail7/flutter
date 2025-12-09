import 'package:get/get.dart';

enum ScanMode {
  active,     // 主扫
  passive,    // 被扫
  both        // 主扫 & 被扫
}

class HomeController extends GetxController {
  // 后台配置结果
  final mode = ScanMode.active.obs;

  /// 获取当前应该显示的按钮
  List<HomeButtonType> get buttons {
    switch (mode.value) {
      /// 主扫
      case ScanMode.active:
        return [
          HomeButtonType.scan,
          HomeButtonType.settings,
          HomeButtonType.transaction,
          HomeButtonType.failedTrans,
          HomeButtonType.voidPay,
          HomeButtonType.settlement,
        ];
      /// 被扫
      case ScanMode.passive:
        return [
          HomeButtonType.qrCode,
          HomeButtonType.settings,
          HomeButtonType.transaction,
          HomeButtonType.failedTrans,
          HomeButtonType.settlement,
        ];
      /// 主扫&被扫
      case ScanMode.both:
        return [
          HomeButtonType.scan,
          HomeButtonType.qrCode,
          HomeButtonType.settings,
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
  settings,
  transaction,
  failedTrans,
  voidPay,
  settlement
}
