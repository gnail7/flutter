import 'dart:convert';

/// 批次统计接口返回类型
class BatchSummary {
  factory BatchSummary.fromJson(Map<String, dynamic> json) {
    return BatchSummary(
      terminal: json['terminal'] ?? 0,
      batchNo: json['batchNo'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      totalCount: json['totalCount'] ?? 0,
      saleStats: Stats.fromString(json['saleStats']),
      voidStats: Stats.fromString(json['voidStats']),
      failedStats: Stats.fromString(json['failedStats']),
      transDetails: (json['transDetails'] as List?)
          ?.map((e) => PaymentRecord.fromJson(e))
          .toList(),
    );
  }

  BatchSummary({
    required this.terminal,
    required this.batchNo,
    required this.totalAmount,
    required this.totalCount,
    Stats? saleStats,
    Stats? voidStats,
    Stats? failedStats,
    this.transDetails,
  })  : saleStats = saleStats ?? Stats(),
        voidStats = voidStats ?? Stats(),
        failedStats = failedStats ?? Stats();

  /// 必传字段
  final int terminal; // 终端号
  final String batchNo; // 当前批次号
  final double totalAmount; // 该批次总金额
  final int totalCount; // 总笔数

  /// 可选字段
  final Stats saleStats; // 成功总笔数和总金额
  final Stats voidStats; // 撤单总笔数和总金额
  final Stats failedStats; // 失败总笔数和总金额
  final List<PaymentRecord>? transDetails; // 交易详细信息列表

  Map<String, dynamic> toJson() => {
    'terminal': terminal,
    'batchNo': batchNo,
    'totalAmount': totalAmount,
    'totalCount': totalCount,
    'saleStats': saleStats,
    'voidStats': voidStats,
    'failedStats': failedStats,
    'transDetails': transDetails?.map((e) => e.toJson()).toList(),
  };
}

/// 成功/撤单/失败统计
class Stats {

  Stats({this.count = 0, this.amount = 0});

  // 这里接收 Map<String, dynamic>
  factory Stats.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Stats();
    return Stats(
      count: json['count'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  // 辅助方法：接收接口返回的字符串
  factory Stats.fromString(String? str) {
    if (str == null || str.isEmpty) return Stats();
    return Stats.fromJson(jsonDecode(str));
  }
  final int count;
  final double amount;
}

/// 单笔交易详细信息
class PaymentRecord {
  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      paymentId: json['paymentId'] ?? '',
      orderNo: json['orderNo'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      transTime: json['transTime'] ?? '',
      transType: json['transType'] ?? 0,
      paymentMethod: json['paymentMethod'] ?? '',
    );
  }

  PaymentRecord({
    required this.paymentId,
    required this.orderNo,
    required this.amount,
    required this.currency,
    required this.transTime,
    required this.transType,
    required this.paymentMethod,
  });

  final String paymentId; // 支付订单号
  final String orderNo; // 交易订单号
  final double amount; // 金额
  final String currency; // 交易币种
  final String transTime; // 交易时间
  final int transType; // 交易类型：1: Sale, 2: Void, 3: Failed
  final String paymentMethod; // 支付方式

  Map<String, dynamic> toJson() => {
    'paymentId': paymentId,
    'orderNo': orderNo,
    'amount': amount,
    'currency': currency,
    'transTime': transTime,
    'transType': transType,
    'paymentMethod': paymentMethod,
  };
}
