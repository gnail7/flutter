class QueryParams {
  // ===== 必传 M & 参与签名 M =====

  /// 终端号（必传，参与签名）
  final int terminal;

  /// 当前批次号（必传，参与签名）
  final String batchNo;

  /// 交易类型（必传，参与签名）
  final int transType;

  /// 登录凭证（必传，参与签名）
  final String token;

  // ===== 可选 C（参与签名）=====
  final String? paymentMethod;
  final int? needTransDetails;
  final int? pageSize;
  final int? startIndex;

  // ===== 可选 O（参与签名）=====
  final String? orderNo;
  final num? amount;

  // ===== 签名，只传不参与签名 =====
  final String? sign;

  QueryParams({
    required this.terminal,
    required this.batchNo,
    required this.transType,
    required this.token,
    this.paymentMethod,
    this.orderNo,
    this.amount,
    this.needTransDetails,
    this.pageSize,
    this.startIndex,
    this.sign,
  });

  /// ★ 用于生成签名（不包含 sign）
  Map<String, dynamic> toSignMap() {
    final map = {
      "terminal": terminal,
      "batchNo": batchNo,
      "transType": transType,
      "paymentMethod": paymentMethod,
      "orderNo": orderNo,
      "amount": amount,
      "needTransDetails": needTransDetails,
      "pageSize": pageSize,
      "startIndex": startIndex,
      "token": token,
    };

    // 去除 null（签名不能包含 null 字段）
    map.removeWhere((key, value) => value == null);
    return map;
  }

  /// ★ 用于发给后端的最终 JSON
  Map<String, dynamic> toJson() {
    final map = {
      "terminal": terminal,
      "batchNo": batchNo,
      "transType": transType,
      "paymentMethod": paymentMethod,
      "orderNo": orderNo,
      "amount": amount,
      "needTransDetails": needTransDetails,
      "pageSize": pageSize,
      "startIndex": startIndex,
      "token": token,
      "sign": sign, // 最终发送时必须带上签名
    };

    return map;
  }
}
