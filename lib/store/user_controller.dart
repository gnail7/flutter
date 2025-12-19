import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/routes/app_routes.dart';

import 'package:op_flutter/utils/simple_prefs.dart';

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
    await SimplePrefs.instance.setString(
      'user',
      jsonEncode(user.toJson()),
    );
  }

  /// 读取用户
  Future<User?> loadFromLocal() async {
    final json = SimplePrefs.instance.getString('user');
    if (json == null) return null;
    return User.fromJson(jsonDecode(json));
  }

  /// 登出
  Future<bool> logout() async {
    try {
      if (user.value != null) {
        // 备份 terminal / uid
        final tid = SimplePrefs.instance.getString('terminal');
        final uid = SimplePrefs.instance.getString('uid');

        await SimplePrefs.instance.clear();

        if (tid != null) {
          await SimplePrefs.instance.setString('terminal', tid);
        }
        if (uid != null) {
          await SimplePrefs.instance.setString('uid', uid);
        }

        user.value = null;
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e, s) {
      Logger().e('logout failed');
    }
    return true;
  }
}
