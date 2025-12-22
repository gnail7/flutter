import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:op_flutter/network/direct_pay/direct_pay.dart';
import 'package:op_flutter/pages/query/payment_detail_page.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/widgets/amount_input.dart';
import 'package:op_flutter/widgets/toast.dart';

class QRScanEntryPage extends StatefulWidget {
  const QRScanEntryPage({super.key});

  @override
  State<QRScanEntryPage> createState() => _QRScanEntryPageState();
}

class _QRScanEntryPageState extends State<QRScanEntryPage> {
  double? amount;

  @override
  Widget build(BuildContext context) {
    // 如果还没有输入金额，显示金额输入页面
    if (amount == null) {
      return AmountInputPOS(
        currency: UserController.to.user.value!.currency,
        onSuccess: (double inputAmount) {
          setState(() {
            amount = inputAmount;
          });
        },
      );
    }

    // 已经输入金额，显示扫码页面（原来的 QRScanPage 不变）
    return QRScanPageWithAmount(amount: amount!);
  }
}

/// 包装原来的 QRScanPage，传入金额
class QRScanPageWithAmount extends StatelessWidget {
  const QRScanPageWithAmount({required this.amount, super.key});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return QRScanPage(amount: amount,);
  }
}

class QRScanPage extends StatefulWidget {
  const QRScanPage({required this.amount, super.key});
  final double amount;

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController cameraController = MobileScannerController();

  bool isScanCompleted = false;
  String? scannedCode;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  final TextEditingController manualController = TextEditingController();

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
    manualController.dispose();
    super.dispose();
  }

  Future<void> submitDirectPay(String payCode) async {
    final payMethods = DirectPayApi.getPayMethods(payCode);

    if (payMethods == null) {
      showCenterToast('Unsupported QR Code', type: ToastType.warning);
      return;
    }

    try {
      final orderNumber = UserController.to.user.value?.orderNo;

      final amount = widget.amount;

      final resp = await DirectPayApi.directPay(
        payCode: payCode,
        payMethods: payMethods,
        orderNumber: orderNumber!,
        orderAmount: amount.toStringAsFixed(2),
        orderCurrency: UserController.to.user.value!.currency,
        deviceId: '',
      );
      showCenterToast('E00: 成功', type: ToastType.success);
      await Future.delayed(const Duration(seconds: 2));
      Get.to(() => PaymentDetailPage(orderNo: UserController.to.user.value!.orderNo));
    } catch (e) {

    }
  }

  /// 扫描回调
  void _handleScan(BarcodeCapture capture) async {
    if (isScanCompleted) return;
    final barcode = capture.barcodes.first;
    final value = barcode.rawValue;
    if (value != null) {
      setState(() {
        isScanCompleted = true;
        scannedCode = value;
      });
      cameraController.stop();
      try {
        await submitDirectPay(value);
      } catch (err){
        print('errr $err');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double scanSize = 250;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Scan',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offNamed(AppRoutes.home),
        ),
      ),
      body: Stack(
        children: [
          /// 摄像头预览
          MobileScanner(
            controller: cameraController,
            onDetect: _handleScan,
          ),

          /// 遮罩层（外部变暗，中间透明）
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              final left = (width - scanSize) / 2;
              final top = (height - scanSize) / 2;

              return Stack(
                children: [
                  // 上方遮罩
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: top,
                    child: Container(color: Colors.black54),
                  ),
                  // 下方遮罩
                  Positioned(
                    top: top + scanSize,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(color: Colors.black54),
                  ),
                  // 左遮罩
                  Positioned(
                    top: top,
                    left: 0,
                    width: left,
                    height: scanSize,
                    child: Container(color: Colors.black54),
                  ),
                  // 右遮罩
                  Positioned(
                    top: top,
                    left: left + scanSize,
                    right: 0,
                    height: scanSize,
                    child: Container(color: Colors.black54),
                  ),
                ],
              );
            },
          ),

          /// 扫码框 + 绿色扫描线
          Center(
            child: SizedBox(
              width: scanSize,
              height: scanSize,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      // 白色边框
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      // 四个角标
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.greenAccent, width: 4),
                              left: BorderSide(color: Colors.greenAccent, width: 4),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.greenAccent, width: 4),
                              right: BorderSide(color: Colors.greenAccent, width: 4),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.greenAccent, width: 4),
                              left: BorderSide(color: Colors.greenAccent, width: 4),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.greenAccent, width: 4),
                              right: BorderSide(color: Colors.greenAccent, width: 4),
                            ),
                          ),
                        ),
                      ),

                      // 绿色扫描线
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
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
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
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

          /// 底部输入框 + 按钮（同一行）
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: manualController,
                    decoration: InputDecoration(
                      hintText: "Input Qr Code Manually",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  ),
                  onPressed: () {
                    final text = manualController.text.trim();
                    
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
