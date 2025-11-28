
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:op_flutter/utils/rsa_utils.dart';
/// 获取 SecureKey
class SecureKeyRequest {
  final int terminal;

  SecureKeyRequest({required this.terminal});

  Map<String, dynamic> toJson() => {
    "terminal": terminal,
  };
}



class LoginRequest {
  final int terminal;
  final String version;
  final String key;      // 商户公钥
  final String secure;   // SHA256 + RSA 签名后的值

  LoginRequest({
    required this.terminal,
    required this.version,
    required this.key,
    required this.secure,
  });

  Map<String, dynamic> toJson() {
    return {
      "terminal": terminal,
      "version": version,
      "key": key,
      "secure": secure,
    };
  }

  /// 生成 secure
  /// params: 用户参数（username/password/token/deviceId）
  /// merchantKey: 商户密钥
  /// publicKeyPem: RSA 公钥
  static String generateSecure(
      Map<String, dynamic> params,
      String merchantKey,
      String publicKeyPem,
      ) {
    // 1. 按 key A-Z 排序
    final sortedKeys = params.keys.toList()..sort();
    final buffer = StringBuffer();
    for (var key in sortedKeys) {
      buffer.write("$key=${params[key]}&");
    }
    buffer.write("merchantKey=$merchantKey");

    // 2. SHA256
    final sha = sha256.convert(utf8.encode(buffer.toString())).toString();

    // 3. RSA 加密 SHA256 值
    return RsaUtils.encrypt(sha, publicKeyPem);
  }
}
