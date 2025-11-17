class SecureKeyResponse {
  final String secureKey;

  SecureKeyResponse({required this.secureKey});

  factory SecureKeyResponse.fromJson(Map<String, dynamic> json) {
    return SecureKeyResponse(
      secureKey: json["secureKey"] ?? "",
    );
  }
}

class LoginResponse {
  final String token;
  final String userName;

  LoginResponse({
    required this.token,
    required this.userName,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json["token"] ?? "",
      userName: json["userName"] ?? "",
    );
  }
}
