
import 'package:get/get.dart';

class HomePageController extends GetxController {
  void navigateToTargetPage(String title) {
    Get.toNamed(title);
  }
}