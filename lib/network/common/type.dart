class ApiResponse<T> {

  ApiResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic data) fromJsonT,
      ) {
    return ApiResponse<T>(
      code: json['code']?.toString() ?? '',
      message: json['message'] ?? '',
      data: fromJsonT(json['data']),
    );
  }
  final String code;
  final String message;
  final T data;
}


class SecureKeyResponse {

  SecureKeyResponse({required this.data});

  factory SecureKeyResponse.fromJson(Map<String, dynamic> json) {
    return SecureKeyResponse(
      data: json['data'] ?? '',
    );
  }
  final String data;
}
