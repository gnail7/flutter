import 'dart:collection';

import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/widgets/modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

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
    // 特殊路由无需校验
    if (routeName == '/settlement') {
      return AuthCheckResult.allow;
    }

    // 如果上次登录时间超过 7 天
    final now = DateTime.now();
    final bool over7Days = now.difference(lastDate!).inDays >= 7;
    if (over7Days) {
      final ok = await showConfirmDialog(
        title: "Settlement",
        message:
        "You have not settlement for 7 days,\nYou must settlement before using payment function.",
      );

      if (ok == true) {
        return AuthCheckResult.needVerify;
      } else {
        return AuthCheckResult.block;
      }
    }

    return AuthCheckResult.allow;
  }
}

enum AuthCheckResult {
  allow,
  block,
  needVerify,
}

String encryptInChunks(RSAPublicKey publicKey, String plainText) {
  final cipher = PKCS1Encoding(RSAEngine())
    ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

  final data = Uint8List.fromList(utf8.encode(plainText));
  final int chunkSize = cipher.inputBlockSize;

  final builder = BytesBuilder();
  int offset = 0;

  while (offset < data.length) {
    final end = (offset + chunkSize < data.length) ? offset + chunkSize : data.length;
    final chunk = data.sublist(offset, end);
    final encryptedChunk = cipher.process(chunk);
    builder.add(encryptedChunk);
    offset = end;
  }

  final encryptedBytes = builder.toBytes();
  return base64Encode(encryptedBytes);
}


String sha256Hex(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString().toUpperCase(); // 变成你要的大写 HEX
}

String createSign(Map<String, String> params, String secureKey) {
  final sorted = SplayTreeMap<String, String>.from(params);
  final buffer = StringBuffer();
  sorted.forEach((k, v) => buffer.write(v));
  buffer.write(secureKey);
  return sha256.convert(utf8.encode(buffer.toString())).toString().toUpperCase();
}


