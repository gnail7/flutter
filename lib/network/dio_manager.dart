import 'dart:convert';

import 'package:dio/dio.dart';

class DioManager {
  static final BaseOptions baseOptions = BaseOptions(
    baseUrl: 'http://192.168.1.7:3000',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'User-Agent': 'Dio',
    },
  );

  static final Dio dio = Dio(baseOptions);

  // 初始化拦截器（只配置一次）
  static void init() {
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
