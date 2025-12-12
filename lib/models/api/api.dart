class ApiResponse<T> {

  ApiResponse({
    required this.code,
    required this.message,
    required this.data,
    this.sign,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      sign: json['sign'],
    );
  }
  final String code;
  final String message;
  final T? data;
  final String? sign;

  bool get isSuccess => code == '0';
}
