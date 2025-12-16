import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanTemplatePage extends StatefulWidget {
  const QRScanTemplatePage({super.key});

  @override
  State<QRScanTemplatePage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanTemplatePage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController cameraController = MobileScannerController();

  bool isScanCompleted = false;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleScan(BarcodeCapture capture) {
    if (isScanCompleted) return;

    final value = capture.barcodes.first.rawValue;
    if (value != null && value.isNotEmpty) {
      isScanCompleted = true;
      cameraController.stop();

      /// 返回扫码结果
      Navigator.of(context).pop(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double scanSize = 250;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Scan', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          /// 摄像头
          MobileScanner(
            controller: cameraController,
            onDetect: _handleScan,
          ),

          /// 遮罩层
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              final left = (width - scanSize) / 2;
              final top = (height - scanSize) / 2;

              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: top,
                    child: Container(color: Colors.black54),
                  ),
                  Positioned(
                    top: top + scanSize,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(color: Colors.black54),
                  ),
                  Positioned(
                    top: top,
                    left: 0,
                    width: left,
                    height: scanSize,
                    child: Container(color: Colors.black54),
                  ),
                  Positioned(
                    top: top,
                    right: 0,
                    width: left,
                    height: scanSize,
                    child: Container(color: Colors.black54),
                  ),
                ],
              );
            },
          ),

          /// 扫码框
          Center(
            child: SizedBox(
              width: scanSize,
              height: scanSize,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  /// 四角
                  _corner(left: 0, top: 0),
                  _corner(right: 0, top: 0),
                  _corner(left: 0, bottom: 0),
                  _corner(right: 0, bottom: 0),

                  /// 扫描线
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (_, __) {
                      return Positioned(
                        top: scanSize * _animation.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          color: Colors.greenAccent,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _corner({double? left, double? right, double? top, double? bottom}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.greenAccent, width: 4),
            left: BorderSide(color: Colors.greenAccent, width: 4),
            right: BorderSide(color: Colors.greenAccent, width: 4),
            bottom: BorderSide(color: Colors.greenAccent, width: 4),
          ),
        ),
      ),
    );
  }
}
