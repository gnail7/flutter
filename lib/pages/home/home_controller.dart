import 'package:get/get.dart';
import 'package:op_flutter/network/tcp_socket_service.dart';
import 'package:op_flutter/store/user_controller.dart';

enum ScanMode {
  active,     // 主扫
  passive,    // 被扫
  both        // 主扫 & 被扫
}

class HomeController extends GetxController {
  // 后台配置结果
  final userController = Get.find<UserController>();

  final mode = ScanMode.both.obs;

  void _updateModeFromUser() {
    final supportPayType = userController.user.value?.supportPayType ?? 0;
    switch (supportPayType) {
      case 1:
        mode.value = ScanMode.active;
        break;
      case 2:
        mode.value = ScanMode.passive;
        break;
      case 3:
        mode.value = ScanMode.both;
        break;
      default:
        mode.value = ScanMode.active;
    }
  }

  @override
  void onInit() async{
    super.onInit();
    _updateModeFromUser();
  }

  /// 获取当前应该显示的按钮
  List<HomeButtonType> get buttons {
    switch (mode.value) {
      /// 主扫
      case ScanMode.active:
        return [
          HomeButtonType.scan,
          HomeButtonType.transaction,
          HomeButtonType.failedTrans,
          HomeButtonType.voidPay,
          HomeButtonType.settlement,
        ];
      /// 被扫
      case ScanMode.passive:
        return [
          HomeButtonType.qrCode,
          HomeButtonType.transaction,
          HomeButtonType.failedTrans,
          HomeButtonType.settlement,
        ];
      /// 主扫&被扫
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
