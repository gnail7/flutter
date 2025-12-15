import 'package:get/get.dart';
import 'package:op_flutter/pages/login/login_controller.dart';


class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
    // 或懒加载：
    // Get.lazyPut<LoginController>(() => LoginController());
  }
}
