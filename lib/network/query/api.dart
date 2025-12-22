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
      '/service/transaction/summary-method',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<BatchSummary>.fromJson(
        json,
            (data) => BatchSummary.fromJson(data),
      ),
    );
  }

  /// 交易明细查询接口
  static Future<ApiResponse<PaymentRecord>> fetchTransactionDetail({
    required int terminal,
    required String batchNo,
    required String orderNo,
    required String token,
  }) async {
    final helper = SignHelperEPay(UserController.to.user.value!.secureCode);

    // 必传字段
    helper.addKeyValue("terminal", terminal.toString());
    helper.addKeyValue("batchNo", batchNo);
    helper.addKeyValue("orderNo", orderNo);
    helper.addKeyValue("token", token);


    // 生成签名
    helper.createSign();
    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<PaymentRecord>>(
      '/service/transaction/detail',
      method: 'POST',
      params: requestMap,
      decoder: (json) => ApiResponse<PaymentRecord>.fromJson(
        json,
            (data) => PaymentRecord.fromJson(data),
      ),
    );
  }

  /// 查询通道支持的支付类型
  static Future<ApiResponse<String>> fetchPayType({
    required int terminal,
    required String payParam, // Alipay / WeChatPay
    required String token,
  }) async {
    final helper = SignHelperEPay(UserController.to.user.value!.secureCode);

    // 必传字段
    helper.addKeyValue("terminal", terminal.toString());
    helper.addKeyValue("payParam", payParam);
    helper.addKeyValue("token", token);

    // 生成签名
    helper.createSign();
    final requestMap = helper.getMap();

    return DioManager.request<ApiResponse<String>>(
      '/service/pay/type',
      method: 'GET',
      params: requestMap,
      decoder: (json) => ApiResponse<String>.fromJson(
        json,
            (data) => data['payType'] as String, // payType 字段解析
      ),
    );
  }

}