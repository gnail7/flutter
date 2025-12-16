import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/utils/app_utils.dart';
import 'package:op_flutter/utils/common.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:op_flutter/widgets/toast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:op_flutter/network/login/api.dart';
import 'package:op_flutter/network/login/login_request.dart';
import 'package:op_flutter/store/user_controller.dart';


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
  final shouldAutoLogin = false.obs;

  /// 初始化：获取版本号 & 设备号，并处理自动登录逻辑
  @override
  void onInit() async {
    super.onInit();

    terminalController.addListener(() {
      terminal.value = terminalController.text;
    });
    usernameController.addListener(() {
      username.value = usernameController.text;
    });
    passwordController.addListener(() {
      password.value = passwordController.text;
    });

    await initEnvInfo();
    await autoLoginOrFill(); // 根据 multiUser 决定是否跳过登录
  }


  Future<void> initEnvInfo() async {
    final pkg = await PackageInfo.fromPlatform();
    final info = DeviceInfoPlugin();
    final android = await info.androidInfo;
    version.value = pkg.version;
    // deviceId.value = android.id;
    deviceId.value = '0820631392';
  }

  Future<bool> _fetchSecureKey() async {
    Get.toNamed(AppRoutes.home);
    try {
      final response = await LoginApi.fetchSecureKey(
        SecureKeyRequest(
          terminal: int.parse(terminal.value),
        ),
      );
      secureKey = response.data;
      return true;
    } catch (e) {
      showCenterToast('$e', type: ToastType.error);
      return false;
    }
  }



  /// 登录
  Future<void> handleLogin({bool useToken = false}) async {
    if ((username.value.isEmpty || password.value.isEmpty) && !useToken) {
      showCenterToast("请输入用户名和密码", type: ToastType.warning);
      return;
    }

    try {
      isLoading.value = true; // 开始 loading

      // 1️⃣ 获取 secureKey
      final ok = await _fetchSecureKey();
      if (!ok) return;

      final prefs = await SharedPreferences.getInstance();
      dynamic localUser = prefs.getString('user_data');
      if (localUser != null) {
        localUser = User.fromJson(jsonDecode(localUser));
      }

      final loginReq = {
        "deviceId": deviceId.value,
        "userName": username.value,
        if (useToken)
          "token": localUser?.token
        else
          "password": sha256Hex(password.value),
      };

      final encryptedBase64 = rsaEncryptNoPadding(
        jsonEncode(loginReq),
        parsePemPublicKey(derToPem(secureKey)),
      );

      final req = LoginRequest(
        terminal: terminal.value,
        version: version.value,
        key: secureKey,
        secure: encryptedBase64,
      );

      final response = await LoginApi.login(req);
      final data = response.data!;

      data.userName = username.value;
      data.secureKey = secureKey;

      UserController.to.setUser(data);
      await prefs.setString('user_data', jsonEncode(data));
      await saveRecentLoginDate();

      isLoggedIn.value = true;
      showCenterToast('登录成功');

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      showCenterToast('$e', type: ToastType.error);
    } finally {
      isLoading.value = false; // 结束 loading
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

    if (userDataStr == null) return;

    final localMap = jsonDecode(userDataStr) as Map<String, dynamic>;

    // 1️⃣ 恢复账号信息
    terminal.value = localMap['terminal']?.toString() ?? '';
    username.value = localMap['userName'] ?? '';

    terminalController.text = terminal.value;
    usernameController.text = username.value;

    // 2️⃣ 是否允许自动登录
    final multiUser = localMap['multiUser'] ?? 1;
    if (multiUser == 0) {
      await handleLogin(useToken: true);
      shouldAutoLogin.value = true;
    } else {
      shouldAutoLogin.value = false;
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


