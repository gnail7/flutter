/// 获取公钥接口请求参数
class SecureKeyRequest {
  final int terminal;

  SecureKeyRequest({required this.terminal});

  /// 转换成可直接用于 GET 查询参数的 Map
  Map<String, dynamic> toQuery() {
    return {
      'terminal': terminal,
    };
  }
}

/// 获取公钥接口响应数据
class SecureKeyResponse {
  final String secureKey;

  SecureKeyResponse({required this.secureKey});

  /// 从 JSON 创建模型
  factory SecureKeyResponse.fromJson(Map<String, dynamic> json) {
    return SecureKeyResponse(
      secureKey: json['secureKey'] ?? '',
    );
  }

  /// 转换成 JSON（可选）
  Map<String, dynamic> toJson() {
    return {
      'secureKey': secureKey,
    };
  }
}
