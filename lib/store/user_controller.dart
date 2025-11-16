

import 'package:get/get.dart';
import 'package:op_flutter/models/users/user_model.dart';
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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // ⚠️ TID & UID 保留，其余需要清空
    String? tid = prefs.getString('terminal');
    String? uid = prefs.getString('uid');

    await prefs.clear();

    if (tid != null) prefs.setString('terminal', tid);
    if (uid != null) prefs.setString('uid', uid);

    user.value = null;
  }
}
