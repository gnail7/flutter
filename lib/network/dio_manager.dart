import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:op_flutter/widgets/toast.dart';

class DioManager {
  static final BaseOptions baseOptions = BaseOptions(
    baseUrl: 'https://192.168.10.39:4443/epay',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {
      'User-Agent': 'Dio',
      'content-type': 'application/json;charset=UTF-8',
    },
  );

  static final Dio dio = Dio(baseOptions);

  static void init() {
    /// 忽略证书（开发用）
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.interceptors.clear();

    /// 打印日志
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
      ),
    );

    /// 统一响应处理
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final code = data['code']?.toString() ?? '-1';
            final message = data['message']?.toString() ?? '未知错误';
            if (code == '0') {
              return handler.next(response);   // 保留完整 JSON
            } else {
              showCenterToast(message, type: ToastType.error);
              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  response: response,
                  message: message,
                  type: DioExceptionType.badResponse,
                ),
              );
            }
          }

          return handler.next(response);
        },

        onError: (DioException e, handler) {
          print("❌ 接口错误: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  /// 统一请求，强类型解析
  static Future<T> request<T>(
      String url, {
        required T Function(Map<String, dynamic>) decoder,
        dynamic params,
        String method = "POST",
      }) async {
    try {
      dynamic data;

      if (method.toUpperCase() == "POST") {
        // 如果是 FormData，直接使用；否则转换成 FormData
        if (params is FormData) {
          data = params;
        } else if (params is Map<String, dynamic>) {
          data = FormData.fromMap(params);
        } else {
          data = params;
        }
      }

      Response response = await dio.request(
        url,
        data: data,
        queryParameters: method.toUpperCase() == "GET" ? params : null,
        options: Options(method: method.toUpperCase()),
      );

      final result = response.data;
      print('result $result');
      return decoder(result as Map<String, dynamic>);
    } catch (e) {
      return Future.error(e);
    }
  }

}
