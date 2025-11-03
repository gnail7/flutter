import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var username = ''.obs; // 账号
  var password = ''.obs; // 密码
  var isLoading = false.obs; // 是否正在加载
  var isLoggedIn = false.obs;

  // 登录方法
  Future<void> handleLogin() async {
    if (username.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('错误', '账号或密码不能为空',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    isLoggedIn.value = true;

    // 模拟登录请求
    await Future.delayed(const Duration(seconds: 2));

    // 假设登录成功
    if (username.value == 'admin' && password.value == 'password') {
      Get.offAllNamed('/home'); // 跳转到主页
    } else {
      Get.snackbar('登录失败', '账号或密码错误',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white);
    }
    print('result $username and $password and login: $isLoggedIn');
    isLoading.value = false;
  }

  // 登出方法
  void logout() {
    isLoggedIn.value = false;
    username.value = '';
  }
}
