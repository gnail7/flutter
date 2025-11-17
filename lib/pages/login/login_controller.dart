import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:op_flutter/network/login/api.dart';
import 'package:op_flutter/network/login/login_request.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/rsa_utils.dart';

class LoginController extends GetxController {
  var terminal = ''.obs;       // 终端号
  var username = ''.obs;       // 用户名
  var password = ''.obs;       // 密码
  var deviceId = ''.obs;       // 设备号
  var version = "1.0.0".obs;   // App版本号

  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  /// 当前 secureKey 一次性使用
  String secureKey = "";

  /// 获取 SecureKey（有效期 30 秒）
  Future<bool> getSecureKey() async {
    if (terminal.value.isEmpty) {
      Get.snackbar("提示", "请输入终端号");
      return false;
    }

    try {
      isLoading.value = true;

      /// 调用经过封装的 LoginApi.fetchSecureKey
      final response = await LoginApi.fetchSecureKey(
        SecureKeyRequest(
          terminal: int.parse(terminal.value),
        ),
      );

      print("⭐ SecureKey result => ${response}");

      secureKey = response.secureKey;
      return true;

    } catch (e) {
      print('e $e ');
      Get.snackbar("异常", "获取密钥错误: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 登录
  Future<void> handleLogin() async {
    if (username.value.isEmpty || password.value.isEmpty) {
      Get.snackbar("提示", "请输入用户名和密码");
      return;
    }

    /// Step 1 — 获取 secureKey
    final ok = await getSecureKey();
    if (!ok) return;

    /// Step 2 — SHA256 对密码加密
    final passwordSha = sha256.convert(utf8.encode(password.value)).toString();

    /// Step 3 — 组装 secure（RSA 加密）
    final securePlain = "${username.value}$passwordSha${terminal.value}";

    final rsaSecure = RsaUtils.encrypt(securePlain, secureKey);

    /// Step 4 — 构造登录请求对象（使用强类型）
    final req = LoginRequest(
      terminal: int.parse(terminal.value),
      version: version.value,
      key: secureKey,     // secureKey 就是 RSA 公钥
      secure: rsaSecure,
      userName: username.value,
      password: passwordSha,
      deviceId: deviceId.value,
    );

    print("📩 Login request => ${req.toJson()}");
    try {
      isLoading.value = true;
      final response = await LoginApi.login(req);

      print("📩 Login response => ${response}");

      /// 解析后的 User
      final user = response.data;

      /// ⭐ 保存用户信息到 UserController + 本地持久化
      UserController.to.setUser(user);

      isLoggedIn.value = true;

      /// 跳转首页
      Get.offAllNamed(AppRoutes.home);

    } catch (e) {
      Get.snackbar("异常", "登录失败: $e");
    } finally {
      isLoading.value = false;
    }

  }

  /// 退出登录
  void logout() {
    isLoggedIn.value = false;
    username.value = '';
    password.value = '';
  }
}


extension LoginValidator on LoginController {
  bool get isValid {
    final tidOk = RegExp(r'^\d{8,9}$').hasMatch(terminal.value);
    final uidOk = RegExp(r'^[A-Za-z0-9]{3,19}$').hasMatch(username.value);
    final pwdOk = RegExp(r'^[A-Za-z0-9]{6,15}$').hasMatch(password.value);
    return tidOk && uidOk && pwdOk;
  }
}
