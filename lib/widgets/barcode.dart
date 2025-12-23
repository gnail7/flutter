import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class BarcodeWidgetView extends StatelessWidget {
  final String data;

  const BarcodeWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BarcodeWidget(
      barcode: Barcode.code128(),
      data: data,
      width: 300,
      height: 80,
      drawText: false, // 打印更清晰，建议关闭
    );
  }
}
