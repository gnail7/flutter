// ===== 数据模型 =====
class SaleReceipt {

  SaleReceipt({
    required this.merchantName,
    required this.paymentMethod,
    required this.mid,
    required this.tid,
    required this.batchNo,
    required this.billNo,
    required this.amount,
    required this.currency,
    required this.paymentId,
    required this.dateTime,
    required this.barcode,
  });
  final String merchantName;
  final String paymentMethod;
  final String mid;
  final String tid;
  final String batchNo;
  final String billNo;
  final String amount;
  final String currency;
  final String paymentId;
  final String dateTime;
  final String barcode;
}

class SummaryReceipt {

  SummaryReceipt({
    required this.merchantName,
    required this.paymentMethod,
    required this.mid,
    required this.tid,
    required this.batchNo,
    required this.saleCount,
    required this.saleAmount,
    required this.voidCount,
    required this.voidAmount,
    required this.failCount,
    required this.failAmount,
    required this.currency,
    required this.dateTime,
  });
  final String merchantName;
  final String paymentMethod;
  final String mid;
  final String tid;
  final String batchNo;
  final int saleCount;
  final double saleAmount;
  final int voidCount;
  final double voidAmount;
  final int failCount;
  final double failAmount;
  final String currency;
  final String dateTime;
}

// ===== 抽象小票格式器 =====
abstract class ReceiptFormatter<T> {
  String format(T receipt);
}

// ===== Sale 小票 =====
class PrinterFriendlySaleFormatter extends ReceiptFormatter<SaleReceipt> {

  PrinterFriendlySaleFormatter({this.lineWidth = 32, this.bottomPadding = 3});
  final int lineWidth;
  final int bottomPadding;

  @override
  String format(SaleReceipt receipt) {
    final sb = StringBuffer();

    void appendLine(String label, String value) {
      final availableSpace = lineWidth - label.length;
      String displayValue = value.length > availableSpace
          ? value.substring(0, availableSpace)
          : value.padLeft(availableSpace);
      sb.writeln('$label$displayValue');
    }

    void appendSeparator() => sb.writeln('-' * lineWidth);

    sb.writeln('SALE'.padLeft((lineWidth + 4) ~/ 2));
    sb.writeln(receipt.merchantName.padLeft((lineWidth + receipt.merchantName.length) ~/ 2));
    appendSeparator();

    appendLine('Payment Method', receipt.paymentMethod);
    appendLine('MID', receipt.mid);
    appendLine('TID', receipt.tid);
    appendLine('Batch No.', receipt.batchNo);
    appendLine('Bill No.', receipt.billNo);
    appendLine('Amount', receipt.amount);
    appendLine('Currency', receipt.currency);
    appendLine('Payment ID', receipt.paymentId);
    appendLine('Date Time', receipt.dateTime);

    appendSeparator();
    sb.writeln(receipt.barcode.padLeft((lineWidth + receipt.barcode.length) ~/ 2));

    for (int i = 0; i < bottomPadding; i++) sb.writeln();

    return sb.toString();
  }
}

// ===== Summary 小票 =====
class PrinterFriendlySummaryFormatter extends ReceiptFormatter<SummaryReceipt> {

  PrinterFriendlySummaryFormatter({this.lineWidth = 32, this.bottomPadding = 3});
  final int lineWidth;
  final int bottomPadding;

  @override
  String format(SummaryReceipt receipt) {
    final sb = StringBuffer();

    void appendLine(String label, String value) {
      final availableSpace = lineWidth - label.length;
      String displayValue = value.length > availableSpace
          ? value.substring(0, availableSpace)
          : value.padLeft(availableSpace);
      sb.writeln('$label$displayValue');
    }

    void appendSeparator() => sb.writeln('-' * lineWidth);

    sb.writeln('Summary'.padLeft((lineWidth + 7) ~/ 2));
    sb.writeln(receipt.merchantName.padLeft((lineWidth + receipt.merchantName.length) ~/ 2));
    appendSeparator();

    appendLine('Sale', '${receipt.saleCount}  ${receipt.saleAmount.toStringAsFixed(2)}');
    appendLine('Void', '${receipt.voidCount}  ${receipt.voidAmount.toStringAsFixed(2)}');
    appendLine('Fail', '${receipt.failCount}  ${receipt.failAmount.toStringAsFixed(2)}');
    appendSeparator();

    appendLine('Payment Method', receipt.paymentMethod);
    appendLine('MID', receipt.mid);
    appendLine('TID', receipt.tid);
    appendLine('Batch No.', receipt.batchNo);
    appendLine('Currency', receipt.currency);
    appendLine('Date Time', receipt.dateTime);

    for (int i = 0; i < bottomPadding; i++) sb.writeln();

    return sb.toString();
  }
}

// ===== 统一管理器 =====
class ReceiptManager {
  final Map<String, dynamic> _formatters = {};

  void registerFormatter<T>(String key, ReceiptFormatter<T> formatter) {
    _formatters[key] = formatter;
  }

  String format<T>(String key, T receipt) {
    final formatter = _formatters[key];
    if (formatter == null) throw Exception('Formatter not found for key: $key');
    return (formatter as ReceiptFormatter<T>).format(receipt);
  }
}
