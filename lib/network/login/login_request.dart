
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
  final String terminal;
  final String version;
  final String key; // 商户公钥
  final String secure; // SHA256 + RSA 签名后的值

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
}

