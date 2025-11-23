import 'package:op_flutter/models/users/user_model.dart';

class SecureKeyResponse {
  final String data;

  SecureKeyResponse({required this.data});

  factory SecureKeyResponse.fromJson(Map<String, dynamic> json) {
    return SecureKeyResponse(
      data: json["data"] ?? "",
    );
  }
}

class LoginResponse {
  final String code;
  final String message;
  final User data;

  LoginResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json["code"] ?? "",
      message: json["message"] ?? "",
      data: User.fromJson(json["data"] ?? {}),
    );
  }
}


