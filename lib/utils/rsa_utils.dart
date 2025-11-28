import 'dart:convert';
import 'package:crypto/crypto.dart';

/// 公共加密工具
class EncryptUtils {
  /// SHA256加密
  static String sha256Encrypt(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }

  /// RSA加密（这里假设你有 RSA 工具类）
  static String rsaEncrypt(String data, String publicKey) {
    // 调用你的 RSA 加密方法
    // return RsaUtils.encrypt(data, publicKey);
    return data; // placeholder
  }
}
