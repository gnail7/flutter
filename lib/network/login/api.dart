import 'package:op_flutter/models/login/login_request.dart';
import 'package:op_flutter/network/dio_manager.dart';

/// 获取公共密钥
Future<dynamic> fetchSecureKeyApi(Map<String, dynamic> request) async{
  return await DioManager.request('/service/secureKey', params: request);
}

/// 用户登录接口
Future<dynamic> loginApi(Map<String, dynamic> request) async {
  return await DioManager.request(
    '/service/login',
    params: request,
    method: 'POST',
  );
}
