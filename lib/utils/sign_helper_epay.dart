import 'dart:collection';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SignHelperEPay {

  SignHelperEPay(this.secureKey);
  final Map<String, String> _map = SplayTreeMap(); // 自动按 key 排序
  final String secureKey;

  /// 动态添加 key-value
  void addKeyValue(String key, String? value) {
    if (value != null && value.isNotEmpty) {
      _map[key] = value;
    }
  }

  /// 创建签名，并把 sign 放入 map
  String createSign() {
    final buffer = StringBuffer();
    _map.forEach((key, value) {
      buffer.write(value); // 只拼 value
    });
    buffer.write(secureKey);

    final sign = sha256.convert(utf8.encode(buffer.toString())).toString().toUpperCase();
    _map['sign'] = sign;
    return sign;
  }

  /// 获取最终请求 map（带 sign）
  Map<String, String> getMap() => Map<String, String>.from(_map);
}
