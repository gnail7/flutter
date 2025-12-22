import 'package:op_flutter/store/user_controller.dart';
import 'package:get/get.dart';
import 'package:op_flutter/models/query/enum.dart';
import 'package:op_flutter/models/query/payment_record.dart';
import 'package:op_flutter/network/query/api.dart';
import 'package:op_flutter/network/query/query_request.dart';
import 'package:op_flutter/routes/app_routes.dart';

class BatchPrintController extends GetxController {
  final userController = UserController.to;

  final isLoading = false.obs;

  /// 接口返回的交易（已过滤 Failed）
  final transactions = <PaymentRecord>[].obs;

  /// 已选 paymentId
  final selected = <String>{}.obs;

  final batchSummary = Rxn<BatchSummary>();

  // 一次性请求
  final int pageSize = 100;

  @override
  void onInit() {
    super.onInit();
    loadPage();
  }

  /// 一次性加载
  Future<void> loadPage() async {
    if (isLoading.value) return;

    isLoading.value = true;
    transactions.clear();
    selected.clear();

    final user = userController.user.value;
    if (user == null) {
      isLoading.value = false;
      return;
    }

    try {
      final params = QueryParams(
        terminal: user.terminal!,
        batchNo: user.batchNo!,
        token: user.token!,
        needTransDetails: 1,
        pageSize: pageSize,
        startIndex: 0,
        transType: 0, // 查全部，后面本地过滤
      );

      final res = await QueryApi.fetchSummaryTransactions(params);

      batchSummary.value = res.data;

      final details = res.data?.transDetails ?? [];

      /// 关键点：过滤 Failed（transType == 3）
      final validList = details.where((e) => e.transType != 3).toList();

      transactions.assignAll(validList);

      /// 默认全选（和 Android 行为一致）
      selected.addAll(validList.map((e) => e.paymentId));
    } catch (e, s) {
      print('❌ BatchPrint load error');
      print(e);
      print(s);
    } finally {
      isLoading.value = false;
    }
  }

  /// 单个切换
  void toggle(String paymentId) {
    if (selected.contains(paymentId)) {
      selected.remove(paymentId);
    } else {
      selected.add(paymentId);
    }
  }

  /// 全选 / 全不选
  void toggleAll() {
    if (selected.length == transactions.length) {
      selected.clear();
    } else {
      selected
        ..clear()
        ..addAll(transactions.map((e) => e.paymentId));
    }
  }

  /// 已选交易（真正用于打印）
  List<PaymentRecord> get selectedRecords =>
      transactions.where((e) => selected.contains(e.paymentId)).toList();
}
