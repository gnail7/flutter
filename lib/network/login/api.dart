import 'package:op_flutter/models/login/login_request.dart';
import 'package:op_flutter/network/dio_manager.dart';

Future<dynamic> loginApi(Map<String, dynamic> request) async {
  return await DioManager.request(
    '/api/auth/login',
    params: request,
    method: 'POST',
  );
}
