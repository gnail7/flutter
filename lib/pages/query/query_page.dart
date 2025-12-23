import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/constant/common.dart';
import 'package:op_flutter/pages/query/batch_print.dart';
import 'package:op_flutter/pages/query/payment_detail_page.dart';
import 'package:op_flutter/pages/query/search_bill_page.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:op_flutter/pages/query/controller/query_page_controller.dart';

import '../../models/query/payment_record.dart';

/// 主页面
class SearchPrintPage extends StatelessWidget {
  SearchPrintPage({super.key});
  final controller = Get.put(QueryPageController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LoadingWrapper(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          backgroundColor: AppColor.bgGrey,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            title: const Text(
              'Search & Print',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_alt),
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => FilterSheet(controller: controller),
                  );
                },
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: controller.refreshList,
                color: Colors.white,
              ),
            ],
          ),
          body: Column(
            children: [
              Obx(() {
                final batch = controller.batchSummary.value;
                if (batch == null) {
                  return const SizedBox.shrink();
                }
                return BatchCardWidget(
                  batchNo: batch.batchNo,
                  totalAmount: batch.totalAmount,
                  currency: UserController.to.user.value!.currency,
                  saleCount: batch.totalSale,
                  voidCount: batch.totalVoid,
                  failCount: batch.totalFailed,
                  onSumPrint: controller.handleSumPrint,
                  onBatchPrint: () => Get.to(BatchPrintPage()),
                );
              }),
              Expanded(
                child: Obx(() {
                  if (controller.items.isEmpty && controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.items.isEmpty) {
                    return const Center(child: Text('暂无数据'));
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refreshList,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent - 50) {
                          controller.loadPage();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        itemCount: controller.items.length + 1,
                        itemBuilder: (context, index) {
                          if (index < controller.items.length) {
                            final item = controller.items[index];
                            return PaymentItemWidget(payment: item);
                          }

                          if (controller.hasMore.value) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: Text('没有更多数据')),
                            );
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// 列表项
class PaymentItemWidget extends StatelessWidget {

  const PaymentItemWidget({required this.payment, super.key});
  final Map<String, dynamic> payment;

  @override
  Widget build(BuildContext context) {
    String typeText;
    Color bgColor;

    switch (payment['transType']) {
      case 1:
        typeText = 'Sale';
        bgColor = Colors.green.shade100;
        break;
      case 2:
        typeText = 'Void';
        bgColor = Colors.blue.shade100;
        break;
      case 3:
      default:
        typeText = 'Failed';
        bgColor = Colors.red.shade100;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      color: Colors.white,
      child: ListTile(
        leading: Container(
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
        title: Text(payment['paymentMethod'] ?? ''),
        subtitle: Text(payment['transTime'] ?? ''),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${payment['currency'] ?? ''} ${payment['amount'] ?? ''}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              typeText,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          final record = PaymentRecord.fromJson(payment);

          Get.to(() => PaymentDetailPage(
            payment: record,
          ));
        },
      ),
    );
  }
}

/// 筛选框
class FilterSheet extends StatelessWidget {
  FilterSheet({required this.controller, super.key});

  final QueryPageController controller;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      widthFactor: 1,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('支付方式', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() {
                final paymentOptions = {
                  'Wechat': OceanConstants.methodWechatPay,
                  'Alipay': OceanConstants.methodAlipay,
                };
                return Wrap(
                  spacing: 12,
                  children: paymentOptions.entries.map((entry) {
                    final display = entry.key; // 显示文本
                    final value = entry.value; // 实际值
                    final isSelected = controller.paymentFilter.value == value;

                    return ChoiceChip(
                      label: Text(
                        display,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.green,
                      onSelected: (selected) {
                        controller.paymentFilter.value = selected ? value : '';
                        controller.refreshList();
                      },
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 16),

              const Text('交易类型', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() {
                return Wrap(
                  spacing: 12,
                  children: ['Sale', 'Void', 'Failed'].map((type) {
                    final isSelected = controller.typeFilter.value == type;
                    return ChoiceChip(
                      label: Text(
                        type,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.green,
                      onSelected: (selected) {
                        controller.typeFilter.value = selected ? type : '0';
                        controller.refreshList();
                      },
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const SearchBillPage());
                  },
                  child: const Text('Search by Bill No. or Amount'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BatchCardWidget extends StatelessWidget {

  const BatchCardWidget({
    required this.batchNo,
    required this.totalAmount,
    required this.currency,
    required this.onSumPrint,
    required this.onBatchPrint,
    this.saleCount,
    this.voidCount,
    this.failCount,
    super.key,
  });
  final String batchNo;
  final double totalAmount;
  final String currency;
  final String? saleCount;
  final String? voidCount;
  final String? failCount;
  final VoidCallback onSumPrint;
  final VoidCallback onBatchPrint;

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          Text(value,
              style: TextStyle(
                  color: valueColor ?? Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white,
      child: Column(
        children: [
          // 上半部分
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildRow('Batch No.', batchNo),
                _buildRow('Total Amount', '$currency $totalAmount', valueColor: Colors.green),
                _buildRow('Sale', '${parseCount(saleCount)}'),
                _buildRow('Void', '${parseCount(voidCount)}'),
                _buildRow('Fail', '${parseCount(failCount)}'),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.grey),

          // 底部按钮
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onSumPrint,
                  child: const Text('Sum Print', style: TextStyle(color: Colors.black)),
                ),
              ),
              const VerticalDivider(width: 1, color: Colors.grey),
              Expanded(
                child: TextButton(
                  onPressed: onBatchPrint,
                  child: const Text('Batch Print', style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}