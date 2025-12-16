import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/utils/common.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:op_flutter/pages/query/query_page_controller.dart';

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
                      summary.saleStats.count.toString(),
                      summary.saleStats.amount.toStringAsFixed(2),
                    ),
                    _buildRow(
                      'Void',
                      summary.voidStats.count.toString(),
                      summary.voidStats.amount.toStringAsFixed(2),
                    ),
                    _buildRow(
                      'Fail',
                      summary.failedStats.count.toString(),
                      summary.failedStats.amount.toStringAsFixed(2),
                    ),

                    const SizedBox(height: 12),
                    const Divider(thickness: 1),
                    const SizedBox(height: 12),

                    /// 基础信息
                    _buildKV('MID',  '-'),
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
                        onPressed: () {
                          /// TODO: 调用打印
                          print('Summary Print');
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
