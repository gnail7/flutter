import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanTemplatePage extends StatefulWidget {

  const QRScanTemplatePage({required this.onScanCompleted, super.key});
  /// 扫码完成后的回调
  final void Function(String result) onScanCompleted;

  @override
  State<QRScanTemplatePage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanTemplatePage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _cameraController = MobileScannerController();

  bool _isScanCompleted = false;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  static const double _scanSize = 250;

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
    _cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleScan(BarcodeCapture capture) {
    if (_isScanCompleted) return;

    final value = capture.barcodes.first.rawValue;
    if (value != null && value.isNotEmpty) {
      _isScanCompleted = true;
      _cameraController.stop();

      // 调用回调函数，把结果传给调用方
      widget.onScanCompleted(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Scan', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _cameraController,
            onDetect: _handleScan,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              final left = (width - _scanSize) / 2;
              final top = (height - _scanSize) / 2;

              return Stack(
                children: [
                  _buildMask(0, 0, width, top),
                  _buildMask(0, top + _scanSize, width, height - top - _scanSize),
                  _buildMask(0, top, left, _scanSize),
                  _buildMask(left + _scanSize, top, left, _scanSize),
                ],
              );
            },
          ),
          Center(
            child: SizedBox(
              width: _scanSize,
              height: _scanSize,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  _corner(Alignment.topLeft),
                  _corner(Alignment.topRight),
                  _corner(Alignment.bottomLeft),
                  _corner(Alignment.bottomRight),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (_, __) {
                      return Positioned(
                        top: _scanSize * _animation.value,
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

  Widget _buildMask(double left, double top, double width, double height) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Container(color: Colors.black54),
    );
  }

  Widget _corner(Alignment alignment) {
    return Align(
      alignment: alignment,
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
