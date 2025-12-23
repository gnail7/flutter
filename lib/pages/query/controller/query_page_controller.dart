import 'dart:convert';
import 'package:get/get.dart';
import 'package:op_flutter/models/query/enum.dart';
import 'package:op_flutter/models/query/payment_record.dart';
import 'package:op_flutter/network/query/api.dart';
import 'package:op_flutter/network/query/query_request.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/store/user_controller.dart';

class QueryPageController extends GetxController {
  final userController = UserController.to;

  // ===== 状态 =====
  final isLoading = false.obs;
  final items = <Map<String, dynamic>>[].obs;
  final hasMore = true.obs;
  var batchSummary = Rxn<BatchSummary>();

  // ===== 分页参数 =====
  final int pageSize = 30;
  int _page = 1;

  // ===== 筛选条件 =====
  final paymentFilter = ''.obs;
  final typeFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refreshList();
  }

  /// 下拉刷新（重置分页）
  Future<void> refreshList() async {
    hasMore.value = true;
    _page = 1;
    items.clear();
    await loadPage();
    hasMore.value = false;
  }

  /// 加载下一页
  Future<void> loadPage() async {
    if (isLoading.value || !hasMore.value) return;
    print('sssss ${UserController.to.user.value?.passwordHash}');
    isLoading.value = true;

    try {
      final user = userController.user.value!;
      final startIndex = (_page - 1) * pageSize;

      final res = await QueryApi.fetchSummaryTransactions(
        QueryParams(
          terminal: user.terminal!,
          batchNo: user.batchNo!,
          token: user.token!,
          needTransDetails: 1,
          pageSize: pageSize,
          startIndex: startIndex,
          transType: typeFilter.value.isEmpty
              ? 0
              : _transTypeTextToInt(typeFilter.value),
          paymentMethod:
          paymentFilter.value.isEmpty ? null : paymentFilter.value,
        ),
      );

      final detailList = res.data?.transDetails ?? [];
      batchSummary.value = res.data;
      if (detailList.isNotEmpty) {
        items.addAll(detailList.map((e) => e.toJson()));
      }

    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  int _transTypeTextToInt(String type) {
    switch (type) {
      case 'Sale':
        return TransactionType.sale.getType();
      case 'Void':
        return TransactionType.voidTrans.getType();
      case 'Failed':
        return TransactionType.failed.getType();
      default:
        return 0;
    }
  }

  void handleSumPrint() {
    Get.toNamed(AppRoutes.querySummaryPage);
  }
}


int parseCount(dynamic data) {
  if (data == null) return 0;

  if (data is int) return data;

  if (data is String) {
    try {
      final map = data.startsWith('{') ? Map<String, dynamic>.from(jsonDecode(data)) : null;
      if (map != null && map['count'] != null) {
        return map['count'] as int;
      }
    } catch (e) {
      return 0;
    }
  }

  return 0;
}

double parseAmount(dynamic data) {
  if (data == null) return 0.0;

  if (data is double) return data;

  if (data is String) {
    try {
      final map = data.startsWith('{') ? Map<String, dynamic>.from(jsonDecode(data)) : null;
      if (map != null && map['amount'] != null) {
        return (map['amount'] as num).toDouble();
      }
    } catch (e) {
      return 0.0;
    }
  }

  return 0.0;
}

