import 'package:op_flutter/models/users/user_model.dart';

class SecureKeyResponse {

  SecureKeyResponse({required this.data});

  factory SecureKeyResponse.fromJson(Map<String, dynamic> json) {
    return SecureKeyResponse(
      data: json["data"] ?? "",
    );
  }
  final String data;
}

class LoginResponse {

  LoginResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.sign
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json["code"] ?? "",
      message: json["message"] ?? "",
      data: User.fromJson(json["data"] ?? {}),
      sign: json['sign'] ?? ""
    );
  }
  final String code;
  final String message;
  final User data;
  final String sign;
}


