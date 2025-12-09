import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/widgets/modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';

Future<void> saveRecentLoginDate() async {
  final prefs = await SharedPreferences.getInstance();
  // 存储当前时间的 ISO8601 字符串
  await prefs.setString('recent_login_date', DateTime.now().toIso8601String());
}


class AuthGuard {
  static Future<AuthCheckResult> check(String routeName) async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString('recent_login_date');
    final lastDate = dateStr != null ? DateTime.tryParse(dateStr) : null;

    final userController = Get.find<UserController>();
    final cleanOverDay = userController.user.value?.clearLoginDays;

    if (routeName == '/settlement') {
      return AuthCheckResult.allow;
    }

    if (cleanOverDay == null) {
      final ok = await showConfirmDialog(
        title: "Settlement",
        message:
        "You have not settlement for 7 days,\nYou must settlement before using payment function.",
      );

      if (ok == true) {
        return AuthCheckResult.needVerify;
      }

      return AuthCheckResult.block;
    }

    return AuthCheckResult.allow;
  }
}

enum AuthCheckResult {
  allow,
  block,
  needVerify,
}



String rsaNewEncrypt(Uint8List publicKeyBytes, String plainText) {
  try {
    // ① 使用 asn1lib 解析 DER 编码 X.509 公钥
    final asn1Parser = ASN1Parser(publicKeyBytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    // SubjectPublicKeyInfo = sequence[0]=AlgorithmId, sequence[1]=BitString(publicKey)
    final publicKeyBitString = topLevelSeq.elements[1] as ASN1BitString;

    // ② 继续解析公钥部分（RSAPublicKey）
    final publicKeyAsn = ASN1Parser(publicKeyBitString.contentBytes()!);
    final publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;

    final modulus = publicKeySeq.elements[0] as ASN1Integer;
    final exponent = publicKeySeq.elements[1] as ASN1Integer;

    final rsaPublicKey = RSAPublicKey(
      modulus.valueAsBigInteger,
      exponent.valueAsBigInteger,
    );

    // ③ 创建加密器（RSA + PKCS1）
    final cipher = PKCS1Encoding(RSAEngine());
    cipher.init(true, PublicKeyParameter<RSAPublicKey>(rsaPublicKey));

    // ④ 分段加密
    final plainBytes = utf8.encode(plainText);
    final keySize = (rsaPublicKey.modulus!.bitLength + 7) ~/ 8;
    final blockSize = keySize - 11;

    final output = <int>[];

    for (int offset = 0; offset < plainBytes.length; offset += blockSize) {
      final end = (offset + blockSize < plainBytes.length)
          ? offset + blockSize
          : plainBytes.length;

      final block = plainBytes.sublist(offset, end);

      final encrypted = cipher.process(Uint8List.fromList(block));
      output.addAll(encrypted);
    }

    return base64Encode(output);
  } catch (e) {
    throw Exception("RSA 加密失败: $e");
  }
}
