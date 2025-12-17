import 'package:get/get.dart';
import 'package:op_flutter/models/query/payment_record.dart';
import 'package:op_flutter/network/query/api.dart';
import 'package:op_flutter/network/query/query_request.dart';
import 'package:op_flutter/store/user_controller.dart';

class SearchResultController extends GetxController {
  final userController = UserController.to;

  var isLoading = false.obs;
  var items = <PaymentRecord>[].obs;
  var batchSummary = Rxn<BatchSummary>();

  var page = 1;
  final int pageSize = 20;
  var hasMore = true.obs;

  late String searchKeyword; // 搜索关键字
  late int transType;        // 可选：交易类型

  @override
  void onInit() {
    super.onInit();
    // 从 Get.arguments 获取传入参数
    final args = Get.arguments as Map<String, dynamic>?;
    searchKeyword = args?['keyword'] ?? '';
    transType = args?['transType'] ?? 0;

    fetchData(refresh: true);
  }

  /// 初始化搜索关键字并刷新
  void initSearch(String keyword, {int type = 0}) {
    searchKeyword = keyword;
    transType = type;
    fetchData(refresh: true);
  }

  Future<void> fetchData({bool refresh = false}) async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;
    if (refresh) {
      page = 1;
      hasMore.value = true;
      items.clear();
    }

    if (!hasMore.value) {
      isLoading.value = false;
      return;
    }

    final token = userController.user.value?.token;
    final terminal = userController.user.value?.terminal;
    final batchNo = userController.user.value?.batchNo;

    if (token == null || terminal == null || batchNo == null) {
      isLoading.value = false;
      return;
    }

    try {
      final startIndex = (page - 1) * pageSize;

      final res = await QueryApi.fetchSummaryTransactions(
        QueryParams(
          terminal: terminal,
          batchNo: batchNo,
          transType: transType,
          token: token,
          needTransDetails: 1,
          pageSize: pageSize,
          startIndex: startIndex,
          orderNo: searchKeyword.isEmpty ? null : searchKeyword,
        ),
      );

      batchSummary.value = res.data;

      final details = res.data?.transDetails ?? [];
      if (details.isNotEmpty) {
        items.addAll(details);
      }

      final totalCount = res.data?.totalCount ?? 0;
      hasMore.value = items.length < totalCount;

      if (hasMore.value) page++;
    } catch (e) {
      print('❌ 查询异常: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    fetchData(refresh: true);
  }

  void loadMore() {
    if (hasMore.value) fetchData();
  }
}
