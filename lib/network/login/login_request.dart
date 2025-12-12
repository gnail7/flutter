
import 'dart:convert';
import 'package:crypto/crypto.dart';
/// 获取 SecureKey
class SecureKeyRequest {

  SecureKeyRequest({required this.terminal});
  final int terminal;

  Map<String, dynamic> toJson() => {
    "terminal": terminal,
  };
}



class LoginRequest { // SHA256 + RSA 签名后的值

  LoginRequest({
    required this.terminal,
    required this.version,
    required this.key,
    required this.secure,
  });
  final String terminal;
  final String version;
  final String key; // 商户公钥
  final String secure;

  Map<String, dynamic> toJson() {
    return {
      "terminal": terminal,
      "version": version,
      "key": key,
      "secure": secure,
    };
  }
}

/// 退出登录请求参数
class LogoutRequest {    // 参数签名（SHA256，可选）

  LogoutRequest({
    required this.terminal,
    required this.batchNo,
    required this.orderNo,
    required this.token,
    this.sign,
  });
  final int terminal; // 终端号
  final String batchNo;  // 批次号
  final String orderNo;  // 订单号
  final String token;    // 登录凭证
  final String? sign;

  /// 转成 Map（方便 Dio 请求）
  Map<String, dynamic> toJson() => {
    "terminal": terminal,
    "batchNo": batchNo,
    "orderNo": orderNo,
    "token": token,
    "sign": sign,
  };
}
