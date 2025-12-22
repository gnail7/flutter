import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/constant/common.dart';
import 'package:op_flutter/pages/query/payment_detail_page.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:op_flutter/widgets/paginated_page_list.dart';
import 'package:op_flutter/pages/query/controller/query_page_controller.dart';

/// 失败交易页面
class FailedTransactionPage extends StatelessWidget {
  FailedTransactionPage({super.key});
  final controller = Get.put(QueryPageController());

  @override
  Widget build(BuildContext context) {
    // 初始化只加载失败交易
    controller.typeFilter.value = 'Failed';
    controller.refreshList();

    return Obx(() {
      return LoadingWrapper(
        isLoading: controller.isLoading.value && controller.items.isEmpty,
        child: Scaffold(
          backgroundColor: AppColor.bgGrey,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            title: const Text(
              'Failed Trans',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: controller.refreshList,
                color: Colors.white,
              ),
            ],
          ),
          body: PaginatedListView<Map<String, dynamic>>(
            pageSize: controller.pageSize,
            fetchData: (page) async {
              await controller.loadPage();
              // 只保留失败交易
              return controller.items
                  .where((item) => item['transType'] == 3)
                  .toList();
            },
            itemBuilder: (context, item, index) {
              return PaymentItemWidget(payment: item);
            },
          ),
        ),
      );
    });
  }
}

/// 列表项，与查询模块一致
class PaymentItemWidget extends StatelessWidget {
  const PaymentItemWidget({required this.payment, super.key});
  final Map<String, dynamic> payment;

  @override
  Widget build(BuildContext context) {
    String typeText = 'Failed';
    Color bgColor = Colors.red.shade100;

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
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              typeText,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          Get.to(() => PaymentDetailPage(orderNo: payment['orderNo']));
        },
      ),
    );
  }
}
