import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:op_flutter/utils/barcode_utils.dart';
import 'package:op_flutter/utils/common.dart';
import 'package:op_flutter/utils/receipt_printer.dart';
import 'package:op_flutter/widgets/toast.dart';

typedef HomeButtonTapCallback = void Function(String name);

class HomeButton extends StatelessWidget {

  const HomeButton({
    required this.name, required this.title, super.key,
    this.icon,
    this.textColor,
    this.iconColor,
    this.backgroundColor,
    this.showBorder = true,
  });
  final String name;
  final String title;
  final IconData? icon;
  final Color? textColor;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final defaultColor = AppColor.greyColor;

    return InkWell(
      onTap: () async {
        final receipt = SaleReceipt(
          merchantName: 'My Shop',
          paymentMethod: 'Credit Card',
          mid: '123456',
          tid: '654321',
          batchNo: '001',
          billNo: '1001',
          amount: '50.00',
          currency: 'USD',
          paymentId: 'ABC123',
          dateTime: '2025-12-21 16:30',
        );

        // 原有逻辑不动
        final manager = ReceiptManager();
        manager.registerFormatter('printer', PrinterFriendlySaleFormatter());

        const platform = MethodChannel('com.example.op_flutter/printer');

        // await platform.invokeMethod('printStr', {
        //   'text': manager.format('printer', receipt)
        // });
        // 2️⃣ 打印二维码（用 paymentId）
        final qrBytes = await generateQrImage(receipt.paymentId);
        print('qrbytes ${qrBytes}');
        await platform.invokeMethod('printBitmap', {
          'bytes': qrBytes,
        });

        return;
        final result = await AuthGuard.check(name);
        /// 无需settlement
        if (result == AuthCheckResult.allow) {
          Get.toNamed(name);
        }
        /// 是否超过七天没有settlement了
        else if (result == AuthCheckResult.needVerify) {
          Get.toNamed(AppRoutes.settlement);
        } else {
          Get.toNamed(name);
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          border: showBorder
              ? Border.all(color: AppColor.greyColor.withOpacity(0.1))
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 30,
                color: iconColor ?? textColor ?? defaultColor,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor ?? defaultColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
