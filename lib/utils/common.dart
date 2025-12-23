
import 'package:op_flutter/utils/simple_prefs.dart';
import 'package:op_flutter/widgets/modal.dart';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

/// 保存最近登录时间
Future<void> saveRecentLoginDate() async {
  await SimplePrefs.instance.setString(
    'recent_login_date',
    DateTime.now().toIso8601String(),
  );
}

class AuthGuard {
  static Future<AuthCheckResult> check(String routeName) async {
    final dateStr =
    SimplePrefs.instance.getString('recent_login_date');

    final lastDate =
    dateStr != null ? DateTime.tryParse(dateStr) : null;


    // 特殊路由无需校验
    if (routeName == '/settlement') {
      return AuthCheckResult.allow;
    }

    // 从未登录过，直接放行
    if (lastDate == null) {
      return AuthCheckResult.allow;
    }

    final now = DateTime.now();
    final bool over7Days = now.difference(lastDate).inDays >= 7;

    if (over7Days) {
      final ok = await showConfirmDialog(
        title: "Settlement",
        message:
        "You have not settlement for 7 days,\nYou must settlement before using payment function.",
      );

      return ok == true
          ? AuthCheckResult.needVerify
          : AuthCheckResult.block;
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


/// 当前时间
String getRightNow() {
  final now = DateTime.now();
  return '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')} '
      '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}';
}

Future<Uint8List> widgetToImage(GlobalKey key) async {
  final boundary =
  key.currentContext!.findRenderObject() as RenderRepaintBoundary;

  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData =
  await image.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}



