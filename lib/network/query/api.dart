import 'package:op_flutter/network/dio_manager.dart';
import 'package:op_flutter/network/query/query_request.dart';
import 'package:op_flutter/network/query/query_response.dart';

class QueryApi {
  /// 查询交易汇总
  /// /service/transaction/summary
  static Future<SummaryResponse> fetchSummary(
      QueryParams request) async {

    final res = await DioManager.request(
      '/service/transaction/summary',
      params: request.toJson(),
      method: 'POST',
    );

    return SummaryResponse.fromJson(res);
  }
}
