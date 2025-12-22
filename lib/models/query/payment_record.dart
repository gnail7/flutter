import 'dart:convert';

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
      transDetails: _parseTransDetails(json['transDetails']),

      totalSale: (json['totalSale']),
      totalVoid: (json['totalVoid']),
      totalFailed: (json['totalFailed']),
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
    List<PaymentRecord>? transDetails,
    this.totalSale,
    this.totalVoid,
    this.totalFailed,
  })  : saleStats = saleStats ?? Stats(),
        voidStats = voidStats ?? Stats(),
        failedStats = failedStats ?? Stats(),
        transDetails = transDetails ?? [];

  final int terminal;
  final String batchNo;
  final double totalAmount;
  final int totalCount;

  final Stats saleStats;
  final Stats voidStats;
  final Stats failedStats;
  final List<PaymentRecord> transDetails;

  // 新增字段
  final String? totalSale;
  final String? totalVoid;
  final String? totalFailed;

  Map<String, dynamic> toJson() => {
    'terminal': terminal,
    'batchNo': batchNo,
    'totalAmount': totalAmount,
    'totalCount': totalCount,
    'saleStats': saleStats.toJson(),
    'voidStats': voidStats.toJson(),
    'failedStats': failedStats.toJson(),
    'transDetails': transDetails.map((e) => e.toJson()).toList(),
    'totalSale': totalSale,
    'totalVoid': totalVoid,
    'totalFailed': totalFailed,
  };

  static List<PaymentRecord> _parseTransDetails(dynamic value) {
    if (value == null) return [];
    if (value is String) {
      if (value.isEmpty) return [];
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((e) => PaymentRecord.fromJson(e)).toList();
        }
      } catch (_) {
        return [];
      }
    }
    if (value is List) {
      return value.map((e) => PaymentRecord.fromJson(e)).toList();
    }
    return [];
  }

  // 工具方法，兼容字符串/数字
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class Stats {
  Stats({this.count = 0, this.amount = 0});

  factory Stats.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Stats();
    return Stats(
      count: json['count'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  factory Stats.fromString(String? str) {
    if (str == null || str.isEmpty) return Stats();
    try {
      final dynamic decoded = jsonDecode(str);
      if (decoded is Map<String, dynamic>) {
        return Stats.fromJson(decoded);
      }
    } catch (_) {}
    return Stats();
  }

  final int count;
  final double amount;

  Map<String, dynamic> toJson() => {
    'count': count,
    'amount': amount,
  };
}

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

  final String paymentId;
  final String orderNo;
  final double amount;
  final String currency;
  final String transTime;
  final int transType;
  final String paymentMethod;

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
