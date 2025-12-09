import 'dart:convert';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/utils/app_utils.dart';
import 'package:op_flutter/utils/common.dart';
import 'package:op_flutter/utils/rsa_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/pkcs1.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:op_flutter/network/login/api.dart';
import 'package:op_flutter/network/login/login_request.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'dart:typed_data';


class LoginController extends GetxController {
  var terminal = ''.obs;
  var username = ''.obs;
  var password = ''.obs;

  var deviceId = ''.obs;
  var version = ''.obs;

  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  String secureKey = "";
  /// 生成带密钥的密码哈希
  String generatePasswordHash(String rawPassword, String secureKey) {
    // 1. 拼接原始密码和商户密钥 (secureKey)
    // 假设拼接规则是： 明文密码 + secureKey
    final combinedString = rawPassword + secureKey;

    // 2. SHA256
    final passwordSha = sha256.convert(utf8.encode(combinedString)).toString();

    return passwordSha;
  }

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
    // final info = DeviceInfoPlugin();
    // final android = await info.androidInfo;
    //
    version.value = pkg.version;
    // deviceId.value = android.id;
    deviceId.value = '0820631392';
  }

  Future<bool> getSecureKey() async {
    Get.offAllNamed(AppRoutes.home);

    if (terminal.value.isEmpty) {
      Get.snackbar("提示", "请输入终端号");
      return false;
    }
    try {
      isLoading.value = true;
      final response = await LoginApi.fetchSecureKey(
        SecureKeyRequest(terminal: int.parse(terminal.value)),
      );

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
    // 获取 RSA 公钥
    final ok = await getSecureKey();
    if (!ok || secureKey.isEmpty) return;
    saveRecentLoginDate();



    // 密码 SHA256
    final passwordSha = sha256.convert(utf8.encode(password.value)).toString();

    // 构造登录 JSON
    final loginReq = {
      "deviceId": deviceId.value,
      "password": passwordSha,
      "userName": username.value,
    };
    final loginJsonStr = jsonEncode(loginReq);

    // Base64 解码公钥
    final keyBytes = base64.decode(secureKey);

    // RSA 分段加密（CryptoUtil）
    final encryptedBase64 = rsaNewEncrypt(keyBytes, loginJsonStr);
    // 构造请求参数
    final req = LoginRequest(
      terminal: terminal.value,
      version: version.value,
      key: secureKey,
      secure: encryptedBase64,
    );


    try {
      isLoading.value = true;

      final response = await LoginApi.login(req);

      UserController.to.setUser(response.data);

      final prefs = await SharedPreferences.getInstance();
      final data = response.data.toJson();
      data['userName'] = username.value;
      data['secureKey'] = secureKey;

      prefs.setString('user_data', jsonEncode(data));
      saveRecentLoginDate();
      isLoggedIn.value = true;
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
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
