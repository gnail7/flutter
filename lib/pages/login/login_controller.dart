import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:op_flutter/network/login/api.dart';
import 'package:op_flutter/network/login/login_request.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/rsa_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginController extends GetxController {
  var terminal = ''.obs;
  var username = ''.obs;
  var password = ''.obs;

  var deviceId = ''.obs;
  var version = ''.obs;

  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  String secureKey = "";


  /// 输入框控制器
  final terminalController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  /// 初始化：获取版本号 & 设备号，并处理自动登录逻辑
  @override
  void onInit() async {
    super.onInit();
    await initEnvInfo();
    await autoLoginOrFill(); // 根据 multiUser 决定是否跳过登录
  }


  Future<void> initEnvInfo() async {
    final pkg = await PackageInfo.fromPlatform();
    final info = DeviceInfoPlugin();
    final android = await info.androidInfo;

    version.value = pkg.version;
    deviceId.value = android.id;
  }

  Future<bool> getSecureKey() async {
    if (terminal.value.isEmpty) {
      Get.snackbar("提示", "请输入终端号");
      return false;
    }
    try {
      isLoading.value = true;
      final response = await LoginApi.fetchSecureKey(
        SecureKeyRequest(terminal: int.parse(terminal.value)),
      );

      print("⭐ SecureKey result => ${response.data}");
      secureKey = response.data;
      return true;
    } catch (e) {
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

    if (version.value.isEmpty || deviceId.value.isEmpty) {
      await initEnvInfo();
    }

    final ok = await getSecureKey();
    if (!ok) return;

    final passwordSha = sha256.convert(utf8.encode(password.value)).toString();
    final securePlain = "${username.value}$passwordSha${terminal.value}";
    final rsaSecure = RsaUtils.encrypt(securePlain, secureKey);

    final req = LoginRequest(
      terminal: int.parse(terminal.value),
      version: version.value,
      key: secureKey,
      secure: rsaSecure,
      userName: username.value,
      password: passwordSha,
      deviceId: deviceId.value,
    );


    try {
      isLoading.value = true;
      final response = await LoginApi.login(req);


      // 保存用户信息到 UserController
      UserController.to.setUser(response.data);

      // 保存用户信息到 SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userMap = response.data.toJson();

      // 额外保存 username
      userMap['userName'] = username.value;

      // 存储到 SharedPreferences
      await prefs.setString('user_data', jsonEncode(userMap));

      isLoggedIn.value = true;

      Get.offAllNamed(AppRoutes.home);

    } catch (e) {
      print("登录失败: $e");
      Get.snackbar("异常", "登录失败: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 读取本地用户信息
  Future<Map<String, dynamic>?> getLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    final dataStr = prefs.getString('user_data');
    if (dataStr != null) {
      return jsonDecode(dataStr);
    }
    return null;
  }

  /// 自动登录或填充账号信息
  Future<void> autoLoginOrFill() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataStr = prefs.getString('user_data');
    if (userDataStr != null) {
      final localMap = jsonDecode(userDataStr) as Map<String, dynamic>;

      // 填充终端号和用户名到响应式变量
      terminal.value = localMap['terminal']?.toString() ?? '';
      username.value = localMap['userName'] ?? '';

      // 同步到输入框
      terminalController.text = terminal.value;
      usernameController.text = username.value;

      // 判断 multiUser
      final multiUser = localMap['multiUser'] ?? 1;
      if (multiUser == 0) {
        // 可以自动登录，需要把 JSON 转成 User 对象
        final user = User.fromJson(localMap);
        UserController.to.setUser(user);
        isLoggedIn.value = true;

        // 跳转首页
        Get.offAllNamed(AppRoutes.home);
      } else {
        // 需要手动登录，但自动填充 TID & UID
        isLoggedIn.value = false;
      }
    }
  }



  /// 登出
  Future<void> logout() async {
    isLoggedIn.value = false;
    username.value = '';
    password.value = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
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
