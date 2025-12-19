import 'package:op_flutter/models/api/api.dart';
import 'package:op_flutter/network/dio_manager.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/sign_helper_epay.dart';

/// DirectPay 交易接口封装
class DirectPayApi {
  /// 发起 DirectPay 支付
  static Future<ApiResponse<Map<String, dynamic>>> directPay({
    required String payCode,
    required String payMethods,
    required String orderNumber,
    required String orderAmount,
    required String orderCurrency,
    required String deviceId,
    String billingFirstName = 'ocean',
    String billingLastName = 'epay',
    String billingEmail = 'epay@ocean.com',
    String billingIp = '192.168.1.1',
    String productName = 'POS',
    String productNum = '1',
  }) async {
    final user = UserController.to.user.value!;
    final helper = SignHelperEPay(user.secureCode);

    // 必传字段
    helper.addKeyValue('account', user.account.toString());
    helper.addKeyValue('terminal', user.terminal.toString());
    helper.addKeyValue('methods', payMethods);
    helper.addKeyValue('pay_accountNumber', payCode);
    helper.addKeyValue('deviceId', deviceId);
    helper.addKeyValue('order_number', orderNumber);
    helper.addKeyValue('order_currency', orderCurrency);
    helper.addKeyValue('order_amount', orderAmount);
    helper.addKeyValue('billing_firstName', billingFirstName);
    helper.addKeyValue('billing_lastName', billingLastName);
    helper.addKeyValue('billing_email', billingEmail);
    helper.addKeyValue('billing_country', 'CN');
    helper.addKeyValue('billing_ip', billingIp);
    helper.addKeyValue('productName', productName);
    helper.addKeyValue('productNum', productNum);
    helper.addKeyValue('cart_info', 'op_flutter'); // 可替换 BuildConfig.APPLICATION_ID
    helper.addKeyValue('cart_api', '1.0.0'); // 可替换 BuildConfig.VERSION_NAME

    // 生成签名
    helper.createSign();
    final requestMap = helper.getMap();

    // 调用 DirectPay 接口（可传完整 URL）
    return DioManager.request<ApiResponse<Map<String, dynamic>>>(
      'http://192.168.10.39:8680/PaymentGateway/gateway/directservice/pay',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
        json,
            (data) => Map<String, dynamic>.from(data),
      ),
    );
  }

  /// 判断扫码支付方式
  static String? getPayMethods(String payCode) {
    final alipayPrefix = ['25', '26', '27', '28', '29', '30'];
    final wxPrefix = ['10', '11', '12', '13', '14', '15'];

    if (payCode.length >= 2) {
      final prefix = payCode.substring(0, 2);
      if (alipayPrefix.contains(prefix) && payCode.length >= 16 && payCode.length <= 24) {
        return 'Alipay';
      }
      if (wxPrefix.contains(prefix) && payCode.length == 18) {
        return 'WechatPay';
      }
    }
    return null;
  }
}
