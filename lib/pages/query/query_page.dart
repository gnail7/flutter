import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/widgets/paginated_page_list.dart';
import 'package:op_flutter/pages/query/query_page_controller.dart';

/// 主页面
class SearchPrintPage extends StatelessWidget {
  SearchPrintPage({super.key});
  final controller = Get.put(QueryPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Search & Print',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              final result = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => FilterSheet(
                  selectedPayment: controller.paymentFilter.value,
                  selectedType: controller.typeFilter.value,
                ),
              );

              if (result != null) {
                controller.paymentFilter.value = result['payment'];
                controller.typeFilter.value = result['type'];
                controller.refreshList();
              }
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
              saleCount: batch.saleStats.count,
              voidCount: batch.voidStats.count,
              failCount: batch.failedStats.count,
              onSumPrint: () => print('Sum Print clicked'),
              onBatchPrint: () => print('Batch Print clicked'),
            );
          }),
          Expanded(
            child: PaginatedListView<Map<String, dynamic>>(
              pageSize: controller.pageSize,
              fetchData: (page) async {
                await controller.loadPage();
                return controller.items.toList();
              },
              itemBuilder: (context, item, index) {
                return PaymentItemWidget(payment: item);
              },
            ),
          )
        ],
      ),
    );
  }
}

/// 列表项
class PaymentItemWidget extends StatelessWidget {

  const PaymentItemWidget({required this.payment, super.key});
  final Map<String, dynamic> payment;

  @override
  Widget build(BuildContext context) {
    // 映射 transType -> 文本 & 背景色
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
        onTap: () => print('点击支付订单号: ${payment["paymentId"]}'),
      ),
    );
  }
}

/// 筛选框
class FilterSheet extends StatefulWidget {
  const FilterSheet({required this.selectedPayment, required this.selectedType, super.key});
  final String selectedPayment;
  final String selectedType;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String selectedPayment;
  late String selectedType;

  @override
  void initState() {
    super.initState();
    selectedPayment = widget.selectedPayment;
    selectedType = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.35,
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
              // 顶部拉手
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

              // 第一行：支付方式单选
              const Text('支付方式', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: ['Wechat', 'Alipay'].map((method) {
                  final isSelected = selectedPayment == method;
                  return ChoiceChip(
                    label: Text(
                      method,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.green,
                    onSelected: (selected) {
                      setState(() {
                        selectedPayment = selected ? method : '';
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // 第二行：交易类型单选
              const Text('交易类型', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: ['Sale', 'Void', 'Failed'].map((type) {
                  final isSelected = selectedType == type;
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
                      setState(() {
                        selectedType = selected ? type : '';
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // 第三行：搜索按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'payment': selectedPayment,
                      'type': selectedType,
                    });
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
    required this.saleCount,
    required this.voidCount,
    required this.failCount,
    required this.onSumPrint,
    required this.onBatchPrint,
    super.key,
  });
  final String batchNo;
  final double totalAmount;
  final String currency;
  final int saleCount;
  final int voidCount;
  final int failCount;
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
                _buildRow('Sale', '$saleCount'),
                _buildRow('Void', '$voidCount'),
                _buildRow('Fail', '$failCount'),
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