import 'package:flutter/material.dart';
import 'package:op_flutter/pages/qr_code/qr_code_controller.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/widgets/amount_input.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 主页面
class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  final QrCodePageController controller = QrCodePageController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        if (controller.showAmountInput) {
          return AmountInputPOS(
            currency: UserController.to.user.value!.currency,
            onSuccess: (double amount) {
              // 用户输入正确金额后保存并展示二维码页面
              controller.setAmount(amount);
              controller.showCustomPage();
            },
          );
        } else {
          return QrInvoicePage(amount: controller.amount);
        }
      },
    );
  }
}

/// 二维码页面
class QrInvoicePage extends StatelessWidget {
  const QrInvoicePage({required this.amount, super.key});
  final double amount;

  @override
  Widget build(BuildContext context) {
    final currency = UserController.to.user.value?.currency;
    final qrData = '$currency ${amount.toStringAsFixed(2)}'; // 可以自定义二维码内容

    return Scaffold(
      backgroundColor: AppColor.bgGrey,
      appBar: AppBar(
        title: const Text('QR Invoice'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // 使用 qr_flutter 生成二维码
                LoadingWrapper(child:  QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  errorStateBuilder: (cxt, err) => const Center(
                    child: Text(
                      "Uh oh! Something went wrong...",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Amount: ',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '$currency ',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor, // 这里是主色
                            ),
                          ),
                          TextSpan(
                            text: amount.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor, // 这里是主色
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

