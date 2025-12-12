

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/network/login/api.dart';
import 'package:op_flutter/network/login/login_request.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/utils/common.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserController extends GetxController {
  static UserController get to => Get.find();

  Rxn<User> user = Rxn<User>();

  bool get isMultiUser => user.value?.multiUser == 1;

  bool get isLoggedIn => user.value?.token != null;

  void setUser(User newUser) {
    user.value = newUser;
    saveToLocal(newUser);
  }

  /// 保存用户
  Future<void> saveToLocal(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<User?> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('user');
    if (json == null) return null;
    return User.fromJson(jsonDecode(json));
  }

  /// 登出
  Future<void> logout() async {
    try {
      if (user.value != null) {
        withLoadingDialog(() async {
          // 清理本地缓存，保留 tid/uid
          final prefs = await SharedPreferences.getInstance();
          String? tid = prefs.getString('terminal');
          String? uid = prefs.getString('uid');

          await prefs.clear();

          if (tid != null) {
            prefs.setString('terminal', tid);
          }
          if (uid != null) {
            prefs.setString('uid', uid);
          }

          user.value = null;
          Get.offAllNamed(AppRoutes.home);
        });
      }
    } catch (e) {
      // 可以记录错误或提示用户
      final logger = Logger();
      logger.e(e);
    }
  }
}
