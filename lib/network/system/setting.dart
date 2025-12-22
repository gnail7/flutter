import 'package:op_flutter/models/api/api.dart';
import 'package:op_flutter/network/dio_manager.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/sign_helper_epay.dart';

class SettingApi {
  /// 更新商户信息接口
  static Future<ApiResponse<String>> updateTerminal({
    required String terminal,
    required String token,
    required String secure,
  }) async {
    final helper = SignHelperEPay(UserController.to.user.value!.secureCode);

    // 必传字段
    helper.addKeyValue("terminal", terminal);
    helper.addKeyValue("token", token);
    helper.addKeyValue("secure", secure);

    // 生成签名
    final sign = helper.createSign();
    helper.addKeyValue("sign", sign);

    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<String>>(
      '/service/terminal/update',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<String>.fromJson(
        json,
            (data) => data.toString(),
      ),
    );
  }
}
