import 'package:op_flutter/models/api/api.dart';
import 'package:op_flutter/network/dio_manager.dart';
import 'package:op_flutter/network/payment/payment_request.dart';
import 'package:op_flutter/network/payment/payment_response.dart';

/// 支付模块接口
class PaymentApi {
  /// 生成二维码
  static Future<ApiResponse<GenerateQrcodeResponse>> generateQrCode(GenerateQrcodeParams request) async{
    return await  DioManager.request(
      '/service/qrcode/create',
      params: request,
      method: 'POST',
      decoder: (json) =>
          ApiResponse<GenerateQrcodeResponse>.fromJson(json, (data) => GenerateQrcodeResponse.fromJson(data)),
    );
  }

  static Future updateQrCode(GenerateQrcodeParams request) async {
    return await  DioManager.request(
      '/service/qrcode/update',
      params: request,
      method: 'POST',
      decoder: (json) =>
          GenerateQrcodeResponse.fromJson(json['data']),
    );
  }
}
