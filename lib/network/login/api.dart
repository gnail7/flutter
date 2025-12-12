import 'package:dio/dio.dart';
import 'package:op_flutter/models/api/api.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/network/common/type.dart' hide ApiResponse;
import 'package:op_flutter/network/login/login_request.dart';
import 'package:op_flutter/network/dio_manager.dart';

class LoginApi {
  /// 获取 SecureKey
  static Future<SecureKeyResponse> fetchSecureKey(SecureKeyRequest request) async {
    return DioManager.request<SecureKeyResponse>(
      '/service/secureKey',
      method: 'GET',
      params: request.toJson(),
      decoder: (json) => SecureKeyResponse.fromJson(json),
    );
  }

  /// 登录接口 (POST + FormData)
  static Future<ApiResponse<User>> login(LoginRequest request) async {
    final formData = FormData.fromMap(request.toJson());

    return DioManager.request<ApiResponse<User>>(
      '/service/login',
      params: formData,
      method: 'POST',
      decoder: (json) => ApiResponse<User>.fromJson(json, (data) => User.fromJson(data), // ← 确保返回 User（非空）
      ),
    );
  }

  static Future<ApiResponse<dynamic>> logout(LogoutRequest request) async {
    return DioManager.request<ApiResponse<dynamic>>(
      '/service/logout',
      method: 'POST',
      params: request.toJson(),
      decoder: (json) => ApiResponse<dynamic>.fromJson(json, (data) => data),
    );
  }
}


