import 'package:op_flutter/models/api/api.dart';
import 'package:op_flutter/network/dio_manager.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/sign_helper_epay.dart';

class SettApi {
  /// 清除结算（Clean Settlement）
  static Future<ApiResponse<dynamic>> cleanSettlement({
    required int terminal,
    required String batchNo,
    required String orderNo,
    required String token,
  }) async {
    final helper = SignHelperEPay(
      UserController.to.user.value!.secureCode,
    );

    // ===== 必传 & 参与签名字段 =====
    helper.addKeyValue('terminal', terminal.toString());
    helper.addKeyValue('batchNo', batchNo);
    helper.addKeyValue('orderNo', orderNo);
    helper.addKeyValue('token', token);

    // ===== 生成签名 =====
    helper.createSign();
    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<dynamic>>(
      '/service/settlement/clean',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<dynamic>.fromJson(json, (data) => data),
    );
  }
}
