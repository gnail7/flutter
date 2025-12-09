import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class DioManager {
  static final BaseOptions baseOptions = BaseOptions(
    baseUrl: 'https://192.168.10.39:4443/epay',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'User-Agent': 'Dio',
    },
  );

  static final Dio dio = Dio(baseOptions);

  // 初始化拦截器（只配置一次）
  static void init() {

    /// 设置忽略证书（开发环境）
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true; // 始终信任证书
      };
      return client;
    };

    dio.interceptors.clear();

    /// 日志
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: false,
    ));

    /// 统一响应处理
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (Response response, handler) {
          final data = response.data;
          print('data $data');
          // ---- 统一处理接口格式 ----
          if (data is Map<String, dynamic>) {
            final code = data['code']?.toString() ?? '-1';
            final message = data['message']?.toString() ?? '未知错误';

            // code = 0 才算成功
            if (code == '0') {
              return handler.next(response);
            } else {
              // 将错误抛出（controller 端自动进入 catch）
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

          // 非 JSON 的情况
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print("❌ 接口错误: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  /// 统一请求方法
  static Future<T> request<T>(
      String url, {
        dynamic? params,
        String method = "POST",
      }) async {
    try {
      Response response = await dio.request(
        url,
        data: method == "POST" ? params : null,
        queryParameters: method == "GET" ? params : null,
        options: Options(method: method),
      );

      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }
}
