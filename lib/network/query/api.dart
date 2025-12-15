import 'dart:convert';

import 'package:op_flutter/models/api/api.dart';
import 'package:op_flutter/models/query/payment_record.dart';
import 'package:op_flutter/network/dio_manager.dart';
import 'package:op_flutter/network/query/query_request.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/sign_helper_epay.dart';

/// 修改后的 QueryApi
class QueryApi {
  static Future<ApiResponse<BatchSummary>> fetchSummaryTransactions(QueryParams request) async {
    final helper = SignHelperEPay(UserController.to.user.value!.secureCode);

    // 必传字段
    helper.addKeyValue("terminal", request.terminal.toString());
    helper.addKeyValue("batchNo", request.batchNo);
    helper.addKeyValue("token", request.token);
    helper.addKeyValue("transType", request.transType.toString());

    // 可选参与签名字段
    helper.addKeyValue("paymentMethod", request.paymentMethod);
    helper.addKeyValue("orderNo", request.orderNo);
    helper.addKeyValue("amount", request.amount?.toString());
    helper.addKeyValue("needTransDetails", request.needTransDetails?.toString() ?? "0");
    helper.addKeyValue("pageSize", request.pageSize?.toString());
    helper.addKeyValue("startIndex", request.startIndex?.toString());

    // 生成签名
    helper.createSign();
    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<BatchSummary>>(
      '/service/transaction/summary',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<BatchSummary>.fromJson(
        json,
            (data) => BatchSummary.fromJson(data),
      ),
    );
  }
}