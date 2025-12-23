import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showConfirmDialog({
  required String title,
  required String message,
}) {
  return Get.dialog<bool>(
    Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图标 + 标题
              Row(
                children: [
                  const Icon(Icons.info, color: Colors.orange, size: 26),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              // 内容文本
              Text(
                message,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 25),
              // 按钮行
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(result: false), // 返回 false
                    child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Get.back(result: true), // 返回 true
                    child: const Text(
                      "OK",
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
