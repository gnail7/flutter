import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:crypto/crypto.dart';

class RsaUtils {
  /// RSA 公钥加密
  /// [plainText] 要加密的内容
  /// [publicKeyStr] 公钥字符串 (可以是纯 Base64 或 PEM 格式)
  static String encrypt(String plainText, String publicKeyStr) {
    final publicKey = _parsePublicKey(publicKeyStr);

    final encrypter = Encrypter(RSA(
      publicKey: publicKey,
      encoding: RSAEncoding.PKCS1,
    ));

    final encrypted = encrypter.encrypt(plainText);

    return encrypted.base64;
  }

  /// 解析公钥
  static RSAPublicKey _parsePublicKey(String keyStr) {
    // 如果是纯 Base64，没有 PEM 头尾，则自动添加
    if (!keyStr.contains("-----BEGIN")) {
      keyStr = "-----BEGIN PUBLIC KEY-----\n$keyStr\n-----END PUBLIC KEY-----";
    }

    final parser = RSAKeyParser();
    final key = parser.parse(keyStr);
    if (key is RSAPublicKey) return key;

    throw Exception("无效的 RSA 公钥");
  }
}



String generateSecure(Map<String, dynamic> params, String merchantKey, String publicKeyPem) {
  // 1. 按 A-Z 排序
  final sortedKeys = params.keys.toList()..sort();
  final buffer = StringBuffer();
  for (var key in sortedKeys) {
    buffer.write("$key=${params[key]}&");
  }
  buffer.write("merchantKey=$merchantKey");

  // 2. SHA256 签名
  final sha = sha256.convert(utf8.encode(buffer.toString())).toString();

  // 3. RSA 加密签名（长度固定，避免 Input data too large）
  return RsaUtils.encrypt(sha, publicKeyPem);
}

