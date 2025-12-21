// 小票数据模型
class SaleReceipt {
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
}

// 小票格式抽象类
abstract class ReceiptFormatter {
  String format(SaleReceipt receipt);
}

// 打印机友好格式
class PrinterFriendlyFormatter extends ReceiptFormatter {
  final int lineWidth;
  final int bottomPadding; // 底部空行数

  PrinterFriendlyFormatter({this.lineWidth = 32, this.bottomPadding = 3});

  @override
  String format(SaleReceipt receipt) {
    final sb = StringBuffer();

    // 左右两端对齐的行
    void appendLine(String label, String value) {
      final availableSpace = lineWidth - label.length;
      String displayValue;
      if (value.length > availableSpace) {
        displayValue = value.substring(0, availableSpace); // 超长截断
      } else {
        displayValue = value.padLeft(availableSpace); // 右侧对齐
      }
      sb.writeln('$label$displayValue');
    }

    void appendSeparator() {
      sb.writeln('-' * lineWidth);
    }

    // 标题居中
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
    // 条码居中
    sb.writeln(receipt.barcode.padLeft((lineWidth + receipt.barcode.length) ~/ 2));

    // 底部留白
    for (int i = 0; i < bottomPadding; i++) {
      sb.writeln();
    }

    return sb.toString();
  }
}

// 管理器，统一管理不同小票格式
class ReceiptManager {
  final Map<String, ReceiptFormatter> _formatters = {};

  void registerFormatter(String key, ReceiptFormatter formatter) {
    _formatters[key] = formatter;
  }

  String format(String key, SaleReceipt receipt) {
    final formatter = _formatters[key];
    if (formatter == null) {
      throw Exception('Formatter not found for key: $key');
    }
    return formatter.format(receipt);
  }
}
