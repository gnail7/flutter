import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
    // deviceId.value = android.id;
    deviceId.value = '0820631392';
  }

  Future<bool> getSecureKey() async {
    if (terminal.value.isEmpty) {
      Get.snackbar("提示", "请输入终端号");
      return false;
    }

    return withLoadingDialog(() async {
      try {
        final response = await LoginApi.fetchSecureKey(
          SecureKeyRequest(terminal: int.parse(terminal.value)),
        );
        secureKey = response.data;
        return true;
      } catch (e) {
        Get.snackbar("异常", "获取密钥错误: $e");
        return false;
      }
    });
  }


  /// 登录
  Future<void> handleLogin({bool useToken = false}) async {
    if (username.value.isEmpty || password.value.isEmpty && !useToken) {
      Get.snackbar("提示", "请输入用户名和密码");
      return;
    }

    // 获取 RSA 公钥
    final ok = await getSecureKey();
    if (!ok || secureKey.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    dynamic localUser = prefs.getString('user');
    if (localUser != null) {
      localUser = User.fromJson(jsonDecode(localUser));
    }
    // 构造登录字符串
    final loginReq = {
      "deviceId": deviceId.value,
      "userName": username.value,
      if (useToken)
        "token": localUser.token
      else
        "password": sha256Hex(password.value),
    };


    final loginJsonStr = jsonEncode(loginReq);
    final pubkey = derToPem(secureKey);
    final publicKey = parsePemPublicKey(pubkey);
    final encryptedBase64 = rsaEncryptNoPadding(loginJsonStr, publicKey);

    final req = LoginRequest(
      terminal: terminal.value,
      version: version.value,
      key: secureKey,
      secure: encryptedBase64,
    );

    await withLoadingDialog(() async {
      final response = await LoginApi.login(req);
      final data = response.data;
      if (data != null) {
        data.userName = username.value;
        data.secureKey = secureKey;
      }
      UserController.to.setUser(response.data!);

      prefs.setString('user_data', jsonEncode(data));
      await saveRecentLoginDate();
      isLoggedIn.value = true;
      showCenterToast('登录成功');

      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(AppRoutes.home);
      });
    });
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


        // 延迟调用 handleLogin 进行一次登录（可自动获取 secureKey 并加密）
        withLoadingDialog(() async {
          await handleLogin(useToken: true);
          isLoggedIn.value = true;
        });

      } else {
        // 多用户，需要手动登录，但自动填充 TID & UID
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


