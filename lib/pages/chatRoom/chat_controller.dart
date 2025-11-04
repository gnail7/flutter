// lib/pages/chat/chat_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';

class ChatController extends GetxController {
  /// 聊天消息（可以后续扩展成 MessageModel）
  final messages = <String>[].obs;

  /// 输入框控制器
  final textController = TextEditingController();

  /// 底部抽屉状态
  final isBottomSheetOpen = false.obs;

  final picker = ImagePicker();
  final record = AudioRecorder();
  final player = AudioPlayer();

  /// 发送文本消息
  void sendMessage() {
    final text = textController.text.trim();
    if (text.isNotEmpty) {
      messages.add("💬 $text");
      textController.clear();
    }
  }

  /// 打开底部功能栏
  Future<void> openMoreOptions(BuildContext context) async {
    if (isBottomSheetOpen.value) return;

    isBottomSheetOpen.value = true;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _buildMoreOptions(),
    );

    isBottomSheetOpen.value = false;
  }

  /// 构建底部功能选项
  Widget _buildMoreOptions() {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.image, 'label': '图片', 'action': pickImage},
      {'icon': Icons.videocam, 'label': '视频', 'action': pickVideo},
      {'icon': Icons.mic, 'label': '语音', 'action': recordVoice},
      {'icon': Icons.insert_drive_file, 'label': '文件', 'action': pickFile},
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: items.map((item) {
          // 👇 在调用时强制转为函数类型
          final Future<void> Function()? action = item['action'] as Future<void> Function()?;

          return GestureDetector(
            onTap: () async {
              if (action != null) {
                await action();
              }
              Get.back();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue.shade50,
                  child: Icon(item['icon'] as IconData, color: Colors.blue),
                ),
                const SizedBox(height: 6),
                Text(item['label'] as String),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- 功能实现部分 ---

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      messages.add('🖼️ 图片: ${image.path}');
    }
  }

  Future<void> pickVideo() async {
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      messages.add('🎬 视频: ${video.path}');
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      messages.add('📁 文件: ${result.files.single.path}');
    }
  }

  Future<void> recordVoice() async {
    if (await record.hasPermission()) {
      final path = 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await record.start(const RecordConfig(), path: path);
      messages.add('🎙️ 录音中...（演示）');
      await Future.delayed(const Duration(seconds: 2));
      await record.stop();
      messages.add('🎧 语音文件: $path');
    }
  }
}
