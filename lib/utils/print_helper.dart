String generateSummaryText(summary, user) {
  final buffer = StringBuffer();
  buffer.writeln('--- Summary ---');
  buffer.writeln('TID: ${user?.terminal ?? "-"}');
  buffer.writeln('Batch No.: ${summary.batchNo}');
  buffer.writeln('Currency: ${user?.currency ?? "-"}');
  buffer.writeln('Date: ${DateTime.now()}');
  buffer.writeln('');
  buffer.writeln('Sale: ${summary.saleStats.count} / ${summary.saleStats.amount.toStringAsFixed(2)}');
  buffer.writeln('Void: ${summary.voidStats.count} / ${summary.voidStats.amount.toStringAsFixed(2)}');
  buffer.writeln('Fail: ${summary.failedStats.count} / ${summary.failedStats.amount.toStringAsFixed(2)}');
  buffer.writeln('----------------');
  return buffer.toString();
}
