import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/pages/chatRoom/map_page.dart';

class ChatController extends GetxController {
  final messages = <String>[].obs;
  final textController = TextEditingController();

  void sendMessage() {
    if (textController.text.trim().isEmpty) return;
    messages.add(textController.text.trim());
    textController.clear();
  }

  /// 打开更多选项（例如地图）
  void openMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.map, color: Colors.blue),
                title: const Text('查看地图'),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const MapPage());
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.grey),
                title: const Text('取消'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
