import 'dart:convert';
import 'package:op_flutter/models/api/api.dart';
import 'package:op_flutter/network/dio_manager.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/app_utils.dart';
import 'package:op_flutter/utils/common.dart';
import 'package:op_flutter/utils/sign_helper_epay.dart';

class PasswordApi {
  /// 验证登录密码
  static Future<ApiResponse<void>> verifyPassword({
    required int terminal,
    required String token,
    required String password,
  }) async {
    final helper = SignHelperEPay(UserController.to.user.value!.secureCode);

    // SHA256 加密密码
    final passwordSha256 = sha256Hex(password);

    // RSA 加密参数
    final secureMap = jsonEncode({
      "password": passwordSha256,
    });
    final secure = rsaEncryptNoPadding(secureMap, parsePemPublicKey(derToPem(UserController.to.user.value!.secureCode))); // 假设你有 RSAHelper.encrypt

    // 必传字段
    helper.addKeyValue("terminal", terminal.toString());
    helper.addKeyValue("token", token);
    helper.addKeyValue("secure", secure);

    // 生成签名
    helper.createSign();
    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<void>>(
      '/service/password/verify',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<void>.fromJson(json, (_) => null),
    );
  }

  /// 修改登录密码
  static Future<ApiResponse<void>> updatePassword({
    required int terminal,
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    final helper = SignHelperEPay(UserController.to.user.value!.secureCode);

    // SHA256 加密密码
    final oldPasswordSha256 = sha256Hex(oldPassword);
    final newPasswordSha256 = sha256Hex(newPassword);

    // RSA 加密参数
    final secureMap = jsonEncode({
      "oldPassword": oldPasswordSha256,
      "newPassword": newPasswordSha256,
    });
    final secure = rsaEncryptNoPadding(secureMap, parsePemPublicKey(derToPem(UserController.to.user.value!.secureCode)));

    // 必传字段
    helper.addKeyValue("terminal", terminal.toString());
    helper.addKeyValue("token", token);
    helper.addKeyValue("secure", secure);

    // 生成签名
    helper.createSign();
    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<void>>(
      '/service/password/update',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<void>.fromJson(json, (_) => null),
    );
  }
}
