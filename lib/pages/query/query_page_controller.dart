import 'dart:convert';

import 'package:get/get.dart';
import 'package:op_flutter/mock/index.dart';
import 'package:op_flutter/models/query/payment_record.dart';
import 'package:op_flutter/network/query/api.dart';
import 'package:op_flutter/network/query/query_request.dart';
import 'package:op_flutter/store/user_controller.dart';

class QueryPageController extends GetxController {
  final userController = UserController.to;
  var items = <Map<String, dynamic>>[].obs;
  var batchSummary = Rxn<BatchSummary>();

  var pageSize = 10;
  var page = 1;
  var hasMore = true.obs;

  // 筛选条件
  var paymentFilter = ''.obs;
  var typeFilter = ''.obs;

  /// 模拟分页加载数据
  Future<void> loadPage({bool refresh = false}) async {
    if (refresh) {
      page = 1;
      hasMore.value = true;
      items.clear();
    }
    if (!hasMore.value) {
      return;
    }
    final token = userController.user.value?.token;
    final terminal = userController.user.value?.terminal;
    final batchNo = userController.user.value?.batchNo;
    final transType = 0;
    try {
      final res = await QueryApi.fetchSummaryTransactions(QueryParams(terminal: terminal!, batchNo: batchNo!, transType: transType, token: token!));
      batchSummary.value = res.data;
      // print('resdata😀😀 ${(res.data)?.transDetails}');
      if (res.data?.transDetails != null) {
        items.addAll(res.data?.transDetails! as Iterable<Map<String, dynamic>>);
      }
   } catch(e) {
      print('❌ $e');
    }
    page++;
  }
  /// 加载批次统计
  Future<void> loadBatchSummary() async {
    final token = userController.user.value?.token;
    final terminal = userController.user.value?.terminal;
    final batchNo = userController.user.value?.batchNo;
    final transType = 0;

    try {
      final res = await QueryApi.fetchSummaryTransactions(
        QueryParams(
          terminal: terminal!,
          batchNo: batchNo!,
          transType: transType,
          token: token!,
          needTransDetails: 1,
        ),
      );
    } catch (e) {
      print('❌ 请求异常: $e');
    }
  }

  /// 刷新列表
  void refreshList() {
    loadPage(refresh: true);
  }
}
