import 'package:get/get.dart';

class StateController extends GetxController {
  // 响应式变量
  var count = 0.obs;
  var message = "Hello, GetX!".obs;

  // 方法：增加计数
  void increment() {
    count++;
    message.value = "Count updated: $count"; // 同步更新 message
  }

  // 方法：重置
  void reset() {
    count.value = 0;
    message.value = "Hello, GetX!";
  }
}
