class SummaryResponse {

  /// 终端号
  final int terminal;

  /// 当前批次号
  final String batchNo;

  /// 该批次总金额
  final num totalAmount;

  /// 总笔数
  final int totalCount;

  // ===== C 可选 & 参与签名 =====

  /// Sale 统计数据（成功）
  final Stats? saleStats;

  /// Void 统计数据（撤销）
  final Stats? voidStats;

  /// Failed 统计数据（失败）
  final Stats? failedStats;

  /// 交易明细列表（请求 needTransDetails = 1 时返回）
  final List<TransDetail>? transDetails;

  SummaryResponse({
    required this.terminal,
    required this.batchNo,
    required this.totalAmount,
    required this.totalCount,
    this.saleStats,
    this.voidStats,
    this.failedStats,
    this.transDetails,
  });

  factory SummaryResponse.fromJson(Map<String, dynamic> json) {
    return SummaryResponse(
      terminal: json['terminal'] ?? 0,
      batchNo: json['batchNo'] ?? '',
      totalAmount: json['totalAmount'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      saleStats:
      json['saleStats'] != null ? Stats.fromJson(json['saleStats']) : null,
      voidStats:
      json['voidStats'] != null ? Stats.fromJson(json['voidStats']) : null,
      failedStats: json['failedStats'] != null
          ? Stats.fromJson(json['failedStats'])
          : null,
      transDetails: json['transDetails'] != null
          ? (json['transDetails'] as List)
          .map((e) => TransDetail.fromJson(e))
          .toList()
          : null,
    );
  }
}



/// 交易统计数据：包含笔数和金额
class Stats {
  /// 总笔数
  final int count;

  /// 总金额
  final num amount;

  Stats({
    required this.count,
    required this.amount,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      count: json['count'] ?? 0,
      amount: json['amount'] ?? 0,
    );
  }
}


/// 单条交易明细
class TransDetail {
  /// 支付订单号（必传）
  final String paymentId;

  /// 交易订单号（必传）
  final String orderNo;

  /// 金额（必传）
  final num amount;

  /// 交易币种（必传）
  final String currency;

  /// 交易时间（必传）
  /// 如：2024-01-12 11:05:26
  final String transTime;

  /// 交易类型（必传）
  /// 1: Sale
  /// 2: Void
  /// 3: Failed
  final int transType;

  /// 支付方式（必传）
  final String paymentMethod;

  TransDetail({
    required this.paymentId,
    required this.orderNo,
    required this.amount,
    required this.currency,
    required this.transTime,
    required this.transType,
    required this.paymentMethod,
  });

  factory TransDetail.fromJson(Map<String, dynamic> json) {
    return TransDetail(
      paymentId: json['paymentId'] ?? '',
      orderNo: json['orderNo'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
      transTime: json['transTime'] ?? '',
      transType: json['transType'] ?? 0,
      paymentMethod: json['paymentMethod'] ?? '',
    );
  }
}
