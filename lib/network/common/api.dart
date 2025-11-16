import 'package:op_flutter/network/common/type.dart';
import 'package:op_flutter/network/dio_manager.dart';

Future<SecureKeyResponse> getSecureKey(SecureKeyRequest request) async{
  return await DioManager.request('/service/secureKey', params: request.toQuery());
}