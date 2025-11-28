

import 'dart:convert';
import 'package:op_flutter/utils/rsa_utils.dart';

/// 获取 SecureKey
class SecureKeyRequest {
  final int terminal;

  SecureKeyRequest({required this.terminal});

  Map<String, dynamic> toJson() => {
    "terminal": terminal,
  };
}

/// 登录请求类
class LoginRequest {
  // 必传参数
  final int terminal;
  final String version;
  final String key;
  final String secure;

  // 可选登录参数
  final String? userName;
  final String? password; // SHA256加密后放入secure
  final String? token; // SHA256加密后放入secure
  final String deviceId;

  LoginRequest({
    required this.terminal,
    required this.version,
    required this.key,
    required this.deviceId,
    this.userName,
    this.password,
    this.token,
    required String publicKey, // 用于RSA加密secure
    required String merchantKey, // 商户密钥，用于SHA256签名
  }) : secure = _generateSecure(
    userName: userName,
    password: password,
    token: token,
    deviceId: deviceId,
    terminal: terminal,
    version: version,
    key: key,
    publicKey: publicKey,
    merchantKey: merchantKey,
  );

  /// 构建请求JSON
  Map<String, dynamic> toJson() {
    return {
      "terminal": terminal,
      "version": version,
      "key": key,
      "secure": secure,
    };
  }

  /// 生成secure字段
  static String _generateSecure({
    String? userName,
    String? password,
    String? token,
    required String deviceId,
    required int terminal,
    required String version,
    required String key,
    required String publicKey,
    required String merchantKey,
  }) {
    final Map<String, String> secureData = {
      "terminal": terminal.toString(),
      "version": version,
      "key": key,
      "deviceId": deviceId,
    };

    if (userName != null) secureData["userName"] = userName;
    if (password != null) {
      // SHA256加密：A-Z顺序参数 + 商户密钥
      final passwordStr = "password=$password&merchantKey=$merchantKey";
      secureData["password"] = EncryptUtils.sha256Encrypt(passwordStr);
    }
    if (token != null) {
      final tokenStr = "token=$token&merchantKey=$merchantKey";
      secureData["token"] = EncryptUtils.sha256Encrypt(tokenStr);
    }

    // 按 key A-Z 顺序拼接成 JSON
    final sortedKeys = secureData.keys.toList()..sort();
    final sortedMap = {for (var k in sortedKeys) k: secureData[k]};
    final jsonStr = jsonEncode(sortedMap);

    // RSA加密
    return EncryptUtils.rsaEncrypt(jsonStr, publicKey);
  }
}
