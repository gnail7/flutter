import 'package:dio/dio.dart';

class DioManager {
  // 配置基本的请求选项
  static final BaseOptions options = BaseOptions(
    // 生产地址： https://epay.oceanpayment.com/
    baseUrl: 'https://192.168.10.39/epay/',
    method: 'POST',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'User-Agent': 'Dio',
    },
  );
  static Dio dio = Dio(options);
  static Future<T> request<T>(
      String url, {
        dynamic? params,
        String method = "POST",
      }) async {
    final options = Options(method: method);

    // 添加日志拦截器（可选）
    dio.interceptors.clear();
    dio.interceptors.add(LogInterceptor(responseBody: true));

    try {
      Response response;
      if (method.toUpperCase() == "GET") {
        response = await dio.request<T>(
          url,
          queryParameters: params,
          options: options,
        );
      } else {
        // POST、PUT 等使用 data
        response = await dio.request<T>(
          url,
          data: params,
          options: options,
        );
      }

      return response.data;
    } catch (e) {
      print('❌ Dio 请求错误: $e');
      return Future.error(e);
    }
  }

}