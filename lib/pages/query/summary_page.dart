import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/utils/common.dart';
import 'package:op_flutter/utils/print_helper.dart';
import 'package:op_flutter/utils/receipt_printer.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:op_flutter/pages/query/controller/query_page_controller.dart';
import 'package:op_flutter/widgets/toast.dart';

class SummaryPage extends StatelessWidget {
  SummaryPage({super.key});

  final QueryPageController controller = Get.find();
  final userController = UserController.to;

  @override
  Widget build(BuildContext context) {
    /// 进入页面如果没有 summary，主动拉一次
    if (controller.batchSummary.value == null) {
      controller.refreshList();
    }

    return Obx(() {
      final summary = controller.batchSummary.value;
      final user = userController.user.value;
      return LoadingWrapper(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          backgroundColor: AppColor.bgGrey,
          appBar: AppBar(
            title: const Text('Summary'),
            backgroundColor: AppColor.primaryColor,
            foregroundColor: Colors.white,
          ),
          body: summary == null
              ? const Center(child: Text('No Summary Data'))
              : Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTableHeader(),
                    const Divider(),
                    /// 交易统计
                    _buildRow(
                      'Sale',
                      "${parseCount(summary.totalSale)}",
                      "${parseAmount(summary.totalSale)}",
                    ),
                    _buildRow(
                      'Void',
                      "${parseCount(summary.totalVoid)}",
                      "${parseAmount(summary.totalVoid)}",
                    ),
                    _buildRow(
                      'Fail',
                      "${parseCount(summary.totalFailed)}",
                      "${parseAmount(summary.totalFailed)}",
                    ),

                    const SizedBox(height: 12),
                    const Divider(thickness: 1),
                    const SizedBox(height: 12),

                    /// 基础信息
                    /// 基础信息
                    _buildKV(
                      'MID',
                      user?.terminal != null && user!.terminal.toString().length >= 6
                          ? user.terminal.toString().substring(0, 6)
                          : '-',
                    ),
                    _buildKV('TID', user?.terminal.toString()  ?? '-'),
                    _buildKV('Batch No.', summary.batchNo),
                    _buildKV('Currency', user?.currency ?? '-'),
                    _buildKV('Date Time', getRightNow()),

                    const Spacer(),

                    /// 打印按钮
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            final summaryReceipt = SummaryReceipt(
                              merchantName: user?.merName ?? '-',
                              paymentMethod: 'Alipay,Wechat Pay',
                              mid: user?.terminal.toString().substring(0,6) ?? '-',
                              tid: user?.terminal.toString() ?? '-',
                              batchNo: summary.batchNo,
                              saleCount: parseCount(summary.totalSale),
                              saleAmount: parseAmount(summary.totalSale),
                              voidCount: parseCount(summary.totalVoid),
                              voidAmount: parseAmount(summary.totalVoid),
                              failCount: parseCount(summary.totalFailed),
                              failAmount: parseAmount(summary.totalFailed),
                              currency: user?.currency ?? '-',
                              dateTime: getRightNow(),
                            );
                            final receiptManager = ReceiptManager();
                            final printText = receiptManager.format<SummaryReceipt>('summary', summaryReceipt);

                            const platform = MethodChannel('com.example.op_flutter/printer');
                            final result = await platform.invokeMethod('printStr', {"text": printText});

                            Get.snackbar('打印结果', result.toString(), snackPosition: SnackPosition.BOTTOM);
                          } on PlatformException catch (e) {
                            showCenterToast('打印失败 ${e.message ?? '未知错误'}', type: ToastType.error);
                          }
                        },
                        child: const Text(
                          'Print',
                          style: TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  /// ===== UI Components =====

  Widget _buildTableHeader() {
    return const Row(
      children: [
        Expanded(
            flex: 2,
            child:
            Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
            child: Text('Count',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
            child: Text('Amount',
                textAlign: TextAlign.end,
                style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildRow(String type, String count, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(type)),
          Expanded(child: Text(count, textAlign: TextAlign.center)),
          Expanded(child: Text(amount, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget _buildKV(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
              child:
              Text(key, style: const TextStyle(color: Colors.black54))),
          Text(value),
        ],
      ),
    );
  }
}
