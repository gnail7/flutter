import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/routes/app_routes.dart';

import 'package:op_flutter/utils/simple_prefs.dart';
import 'package:op_flutter/widgets/modal.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  Rxn<User> user = Rxn<User>();

  // 新增：加密后的密码
  RxnString sha256Password = RxnString();

  bool get isMultiUser => user.value?.multiUser == 1;

  bool get isLoggedIn => user.value?.token != null;

  /// 设置用户，同时可传入加密后的密码
  void setUser(User newUser, {String? passwordHash}) {
    user.value = newUser;
    if (passwordHash != null) {
      sha256Password.value = passwordHash;
    }
    saveToLocal(newUser);
  }

  /// 保存用户到本地
  Future<void> saveToLocal(User user) async {
    final map = user.toJson();
    if (sha256Password.value != null) {
      await SimplePrefs.instance.setString('sha256Password', sha256Password.value ?? '');
    }
    await SimplePrefs.instance.setString(
      'user',
      jsonEncode(map),
    );
  }

  /// 读取用户和密码
  Future<void> loadFromLocal() async {
    final json = SimplePrefs.instance.getString('user');
    if (json == null) {
      return;
    }
    final jsonPasswordSha = SimplePrefs.instance.getString('sha256Password');
    sha256Password.value = jsonPasswordSha;
    final map = jsonDecode(json);
    user.value = User.fromJson(map);
  }

  /// 登出
  Future<bool> logout() async {
    final confirm = await showConfirmDialog(
      title: "Confirm Logout",
      message: "Are you sure you want to log out?",
    );

    if (confirm != true) {
      return false;
    }

    try {
      if (user.value != null) {
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
        sha256Password.value = null;
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e, s) {
      Logger().e('logout failed $s');
      return false;
    }
    return true;
  }
}
