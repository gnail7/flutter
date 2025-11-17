import 'package:op_flutter/network/dio_manager.dart';
import 'login_request.dart';
import 'login_response.dart';

class LoginApi {

  /// 获取 SecureKey
  static Future<SecureKeyResponse> fetchSecureKey(SecureKeyRequest request) async {
    final res = await DioManager.request(
      '/service/secureKey',
      params: request.toJson(),
    );
    return SecureKeyResponse.fromJson(res);
  }

  /// 登录接口
  static Future<LoginResponse> login(LoginRequest request) async {
    final res = await DioManager.request(
      '/service/login',
      params: request.toJson(),
      method: 'POST',
    );
    return LoginResponse.fromJson(res);
  }
}
