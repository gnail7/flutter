/// 登录接口请求参数
class LoginRequest {
  final String username;
  final String password;
  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}

