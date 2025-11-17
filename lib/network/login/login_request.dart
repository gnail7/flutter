/// 获取 SecureKey
class SecureKeyRequest {
  final int terminal;

  SecureKeyRequest({required this.terminal});

  Map<String, dynamic> toJson() => {
    "terminal": terminal,
  };
}

/// 登录请求
class LoginRequest {
  final int terminal;
  final String version;
  final String key;
  final String secure; // RSA 签名

  // 加密内容
  final String userName;
  final String? password; // SHA256
  final String? token;    // SHA256
  final String deviceId;

  LoginRequest({
    required this.terminal,
    required this.version,
    required this.key,
    required this.secure,
    required this.userName,
    this.password,
    this.token,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    "terminal": terminal,
    "version": version,
    "key": key,
    "secure": secure,
    "userName": userName,
    "password": password,
    "token": token,
    "deviceId": deviceId,
  };
}
