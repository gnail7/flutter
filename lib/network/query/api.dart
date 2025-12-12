import 'package:op_flutter/models/api/api.dart';
import 'package:op_flutter/models/query/payment_record.dart';
import 'package:op_flutter/network/dio_manager.dart';
import 'package:op_flutter/network/query/query_request.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/common.dart';


class QueryApi {
  static Future<ApiResponse<BatchSummary>> fetchSummaryTransactions (QueryParams request) async {
    final map = request.toJson();


    final signature = createSign({
      "terminal": request.terminal.toString(),
      "batchNo": request.batchNo.toString(),
      "transType": request.transType.toString(),
      "token": request.token.toString()
    }, UserController.to.user.value!.secureCode);

    final requestWithSignature = {...map, 'sign': signature, };

    return DioManager.request<ApiResponse<BatchSummary>>(
      '/service/transaction/summary',
      method: 'POST',
      params: requestWithSignature,
      decoder: (json) => ApiResponse<BatchSummary>.fromJson(
        json,
            (data) => BatchSummary.fromJson(data),
      ),
    );
  }
}