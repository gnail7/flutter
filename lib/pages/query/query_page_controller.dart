import 'dart:convert';

import 'package:get/get.dart';
import 'package:op_flutter/mock/index.dart';
import 'package:op_flutter/models/query/enum.dart';
import 'package:op_flutter/models/query/payment_record.dart';
import 'package:op_flutter/network/query/api.dart';
import 'package:op_flutter/network/query/query_request.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/sign_helper_epay.dart';

class QueryPageController extends GetxController {
  final userController = UserController.to;
  var isLoading = false.obs;
  var items = <Map<String, dynamic>>[].obs;
  var batchSummary = Rxn<BatchSummary>();

  var pageSize = 10;  // 每页条数
  var page = 1;       // 当前页码
  var hasMore = true.obs;

  // 筛选条件
  var paymentFilter = ''.obs;
  var typeFilter = ''.obs;

  /// 分页加载数据
  Future<void> loadPage({bool refresh = false}) async {
    if (refresh) {
      page = 1;
      hasMore.value = true;
      items.clear();
    }

    if (!hasMore.value) return;

    final token = userController.user.value?.token;
    final terminal = userController.user.value?.terminal;
    final batchNo = userController.user.value?.batchNo;

    try {
      final startIndex = (page - 1) * pageSize;

      final res = await QueryApi.fetchSummaryTransactions(
        QueryParams(
          terminal: terminal!,
          batchNo: batchNo!,
          transType: typeFilter.value.isEmpty
              ? 0
              : _transTypeTextToInt(typeFilter.value), // 可根据筛选转换
          token: token!,
          needTransDetails: 1,
          pageSize: pageSize,
          startIndex: startIndex,
          paymentMethod: paymentFilter.value.isEmpty ? null : paymentFilter.value,
        ),
      );

      batchSummary.value = res.data;

      final detailsRaw = res.data?.transDetails;
      List<Map<String, dynamic>> details = [];

      if (detailsRaw is String) {
        try {
          final parsed = jsonDecode(detailsRaw);
          if (parsed is List) {
            details = parsed.cast<Map<String, dynamic>>();
          }
        } catch (e) {
          print('❌ 解析 transDetails 失败: $e');
        }
      }

      // 添加数据
      if (details.isNotEmpty) {
        items.addAll(details);
      }

      // 根据 totalCount 判断是否还有更多
      final totalCount = res.data?.totalCount ?? 0;
      hasMore.value = items.length < totalCount;

      // 下一页
      if (hasMore.value) page++;

    } catch (e) {
      print('❌ 请求异常: $e');
    }
  }

  /// 将交易类型文本转换成接口需要的数字
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

  /// 下拉刷新列表
  void refreshList() {
    loadPage(refresh: true);
  }
}
