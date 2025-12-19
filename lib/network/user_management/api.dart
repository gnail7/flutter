import 'package:op_flutter/models/api/api.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/network/dio_manager.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/sign_helper_epay.dart';

class UserApi {
  /// 查询用户列表
  static Future<ApiResponse<List<User>>> listUsers({
    required int terminal,
    required String token,
  }) async {
    final helper = SignHelperEPay(UserController.to.user.value!.secureCode);

    // 必传 & 参与签名字段
    helper.addKeyValue('terminal', terminal.toString());
    helper.addKeyValue('token', token);

    // 生成签名
    helper.createSign();
    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<List<User>>>(
      '/service/user/list',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<List<User>>.fromJson(
        json,
            (data) => (data as List).map((e) => User.fromJson(e)).toList(),
      ),
    );
  }

  /// 添加用户
  static Future<ApiResponse<void>> addUser({
    required int terminal,
    required String token,
    required String secure, // RSA 加密后的用户信息
  }) async {
    final helper = SignHelperEPay(UserController.to.user.value!.secureCode);

    helper.addKeyValue('terminal', terminal.toString());
    helper.addKeyValue('token', token);
    helper.addKeyValue('secure', secure);

    helper.createSign();
    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<void>>(
      '/service/user/save',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<void>.fromJson(json, (data) => data),
    );
  }

  /// 修改用户
  static Future<ApiResponse<void>> updateUser({
    required int terminal,
    required String token,
    required String secure, // RSA 加密后的用户信息
  }) async {
    final helper = SignHelperEPay(UserController.to.user.value!.secureCode);

    helper.addKeyValue('terminal', terminal.toString());
    helper.addKeyValue('token', token);
    helper.addKeyValue('secure', secure);

    helper.createSign();
    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<void>>(
      '/service/user/update',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<void>.fromJson(json, (data) => data),
    );
  }

  /// 删除用户
  static Future<ApiResponse<void>> deleteUser({
    required int terminal,
    required String token,
    required String userId,
  }) async {
    final helper = SignHelperEPay(UserController.to.user.value!.secureCode);

    helper.addKeyValue('terminal', terminal.toString());
    helper.addKeyValue('token', token);
    helper.addKeyValue('userId', userId);

    helper.createSign();
    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<void>>(
      '/service/user/delete',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<void>.fromJson(json, (data) => data),
    );
  }
}
