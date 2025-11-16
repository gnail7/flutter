import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/network/common/api.dart';

class LoginController extends GetxController {
  var terminal = ''.obs; // 终端号
  var username = ''.obs; // 账号
  var password = ''.obs; // 密码
  var isLoading = false.obs; // 是否正在加载
  var isLoggedIn = false.obs;



  Future<void> getSecureKey() async {

  }

  // 登录方法
  Future<void> handleLogin() async {


  }

  // 登出方法
  void logout() {
    isLoggedIn.value = false;
    username.value = '';
  }
}
