import 'dart:convert';

import 'package:op_flutter/models/api/api.dart';
import 'package:op_flutter/models/setting/user_item.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/network/dio_manager.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/sign_helper_epay.dart';

class UserApi {
  /// 查询用户列表
  static Future<ApiResponse<List<UserItem>>> listUsers({
    required int terminal,
    required String token,
  }) async {
    final helper = SignHelperEPay(UserController.to.user.value!.secureCode);

    helper.addKeyValue('terminal', terminal.toString());
    helper.addKeyValue('token', token);
    helper.createSign();

    return DioManager.request<ApiResponse<List<UserItem>>>(
      '/service/user/list',
      method: 'POST',
      params: helper.getMap(),
      decoder: (json) {
        return ApiResponse<List<UserItem>>.fromJson(
          json,
              (data) {
            if (data == null) return <UserItem>[];

            final map = data as Map<String, dynamic>;

            final usersStr = map['users'];
            if (usersStr == null || usersStr is! String || usersStr.isEmpty) {
              return <UserItem>[];
            }

            final List<dynamic> list = jsonDecode(usersStr);
            return list.map((e) => UserItem.fromJson(e)).toList();
          },
        );
      },
    );
  }


  /// 添加用户
  static Future<ApiResponse<void>> addUser({
    required String terminal,
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

    // 添加参数
    helper.addKeyValue('terminal', terminal.toString());
    helper.addKeyValue('token', token);
    helper.addKeyValue('userId', userId);
    helper.addKeyValue('status', '-1');

    // 生成签名
    helper.createSign();
    // 获取请求参数
    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<void>>(
      '/service/user/status/update',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<void>.fromJson(json, (data) => data),
    );
  }

}
