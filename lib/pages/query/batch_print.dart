import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/pages/query/controller/batch_print_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import '../../models/query/payment_record.dart';

class BatchPrintPage extends StatelessWidget {
  BatchPrintPage({super.key});

  final controller = Get.put(BatchPrintController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LoadingWrapper(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          backgroundColor: AppColor.bgGrey,
          appBar: AppBar(
            title: const Text('Batch Print'),
            backgroundColor: AppColor.primaryColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: controller.toggleAll,
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: controller.transactions.length,
            itemBuilder: (_, i) {
              final p = controller.transactions[i];
              final checked = controller.selected.contains(p.paymentId);

              return SelectablePaymentItemWidget(
                payment: p,
                checked: checked,
                onToggle: () => controller.toggle(p.paymentId),
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: controller.selected.isEmpty
                  ? null
                  : () => _print(controller.selectedRecords),
              child: const Text('Print'),
            ),
          ),
        ),
      );
    });
  }


  void _print(List<PaymentRecord> list) {
    // TODO: 调你已有的 batch print / esc-pos 打印
    debugPrint('Batch print count: ${list.length}');
  }
}


class SelectablePaymentItemWidget extends StatelessWidget {
  const SelectablePaymentItemWidget({
    required this.payment, required this.checked, required this.onToggle, super.key,
  });

  final PaymentRecord payment;
  final bool checked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    String typeText;
    Color bgColor;

    switch (payment.transType) {
      case 1:
        typeText = 'Sale';
        bgColor = Colors.green.shade100;
        break;
      case 2:
        typeText = 'Void';
        bgColor = Colors.blue.shade100;
        break;
      default:
        typeText = 'Failed';
        bgColor = Colors.red.shade100;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      color: Colors.white,
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              /// ✅ Checkbox
              Checkbox(
                value: checked,
                onChanged: (_) => onToggle(),
              ),

              /// ✅ 圆形 Sale / Void
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  typeText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: bgColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(width: 12),

              /// ✅ 中间内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.paymentMethod,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment.transTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              /// ✅ 右侧金额
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${payment.currency} ${payment.amount}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    typeText,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
