import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/models/query/payment_record.dart';
import 'package:op_flutter/pages/query/controller/search_page_controller.dart';
import 'package:op_flutter/pages/query/payment_detail_page.dart';

class SearchResultPage extends StatelessWidget {
  SearchResultPage({super.key});

  final SearchResultController controller = Get.put(SearchResultController());

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;

    final keyword = arguments?['keyword'] ?? '';
    final isBillNo = arguments?['isBillNo'] ?? false;

    // 初始化搜索
    controller.initSearch(keyword);

    return Obx(() {
      return Scaffold(
        appBar: AppBar(title: const Text('Search Result'),       centerTitle: true,),
        body: _buildBody(isBillNo),
      );
    });
  }

  Widget _buildBody(bool isBillNo) {
    if (controller.isLoading.value && controller.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.items.isEmpty) {
      return const Center(child: Text('没有搜索到结果'));
    }

    // 如果是 Bill No. 查询，或者只返回一条交易，直接显示详情
    if (isBillNo || controller.items.length == 1) {
      final PaymentRecord record = controller.items.first;
      return PaymentDetailPageWrapper(record: record);
    }

    // 多条结果 → 列表展示
    return RefreshIndicator(
      onRefresh: () async => controller.refresh(),
      child: ListView.builder(
        itemCount: controller.items.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.items.length) {
            // 底部加载更多
            if (controller.hasMore.value) {
              controller.loadMore();
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return const SizedBox.shrink();
            }
          }

          final PaymentRecord record = controller.items[index];
          return ListTile(
            title: Text('${record.orderNo} - ${record.amount} ${record.currency}'),
            subtitle: Text('${record.transTime} | ${record.paymentMethod}'),
            onTap: () {
              // 点击进入交易详情页面
              Get.to(() => PaymentDetailPageWrapper(record: record));
            },
          );
        },
      ),
    );
  }
}

/// 包装一个 PaymentDetailPage 用于直接显示详情
class PaymentDetailPageWrapper extends StatelessWidget {
  const PaymentDetailPageWrapper({required this.record, super.key});

  final PaymentRecord record;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildKV('Type', _transTypeText(record.transType)),
              _buildKV('Currency', record.currency),
              _buildKV('Amount', record.amount.toString()),
              const Divider(height: 32),
              _buildKV('Payment Method', record.paymentMethod),
              _buildKV('Transaction Time', record.transTime),
              _buildKV('Payment ID', record.paymentId),
              _buildKV('Status', _transTypeText(record.transType)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => PaymentDetailPage(orderNo: record.orderNo,));
                  },
                  child: const Text('Print'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _transTypeText(int type) {
    switch (type) {
      case 1:
        return 'Sale';
      case 2:
        return 'Void';
      case 3:
      default:
        return 'Failed';
    }
  }

  Widget _buildKV(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              key,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
