import 'package:flutter/foundation.dart';
import 'package:op_flutter/network/payment/api.dart';
import 'package:op_flutter/store/user_controller.dart';

import '../../network/payment/payment_request.dart';

class QrCodePageController extends ChangeNotifier {
  /// 当前是否显示金额输入页面
  bool _showAmountInput = true;

  /// 用户输入的金额
  double _amount = 0;

  bool get showAmountInput => _showAmountInput;
  double get amount => _amount;

  bool isLoading = false;

  /// 设置金额
  void setAmount(double amount) {
    _amount = amount;
    notifyListeners();
  }

  /// 切换到自定义页面
  void showCustomPage() {
    _showAmountInput = false;
    notifyListeners();
  }

  /// 重置为金额输入页面（可选）
  void reset() {
    _showAmountInput = true;
    _amount = 0;
    notifyListeners();
  }

  /// 生成二维码
  /// 生成二维码
  Future<void> handleGenerateQrCode() async {
    if (_amount <= 0) return; // 防止 0 或负数金额

    try {
      isLoading = true;
      notifyListeners();

      final user = UserController.to.user.value!;

      final params = GenerateQrcodeParams(
        terminal: user.terminal,       // 从 userController 拿
        channelId: '2',     // 从 userController 拿
        orderNo: user.orderNo,         // 从 userController 拿
        amount: _amount,
        currency: user.currency,       // 从 userController 拿
        token: user.token,             // 从 userController 拿
      );

      final res = await PaymentApi.generateQrCode(params);

      // 这里可以处理返回的数据，比如保存二维码 url 或 data
      // 例如: _qrData = res.qrCode; notifyListeners();

    } catch (e, st) {
      debugPrint('生成二维码失败: $e\n$st');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
