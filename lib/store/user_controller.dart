import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/utils/simple_prefs.dart';
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
    final prefs = SimplePrefs.instance;
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<User?> loadFromLocal() async {
    final prefs = SimplePrefs.instance;
    final json = prefs.getString('user');
    if (json == null) return null;
    return User.fromJson(jsonDecode(json));
  }

  /// 登出
  Future<bool> logout() async {
    try {
      print('logout ${user.value}');
      if (user.value != null) {
        // 清理本地缓存，保留 tid/uid
        final prefs = SimplePrefs.instance;
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
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      // 可以记录错误或提示用户
      final logger = Logger();
      logger.e(e);
    }
    return true;
  }
}
