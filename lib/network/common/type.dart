class ApiResponse<T> {
  final String code;
  final String message;
  final T? data;
  final String? sign;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
    this.sign,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic) fromJsonT,
      ) {
    return ApiResponse(
      code: json["code"] ?? "",
      message: json["message"] ?? "",
      data: json["data"] == null ? null : fromJsonT(json["data"]),
      sign: json["sign"],
    );
  }

  bool get isSuccess => code == "0";
}
