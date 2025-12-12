import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ToastType { info, success, warning, error }



void showCenterToast(String message,
    {ToastType type = ToastType.info, Duration duration = const Duration(seconds: 2)}) {
  final iconData = _getIcon(type);
  final bgColor = _getBackgroundColor(type);
  final textColor = _getTextColor(type);
  final padding = _getPadding(type);


  Get.dialog(
    Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(Get.context!).size.width * 0.8, // 最大宽度 80%
          ),
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, color: _getIconColor(type), size: 28),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: 16),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );

  Future.delayed(duration, () {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  });
}

// 图标
IconData _getIcon(ToastType type) {
  switch (type) {
    case ToastType.success:
      return Icons.check_circle;
    case ToastType.warning:
      return Icons.warning;
    case ToastType.error:
      return Icons.error;
    case ToastType.info:
    return Icons.info;
  }
}

// 图标颜色
Color _getIconColor(ToastType type) {
  switch (type) {
    case ToastType.success:
      return Colors.green;
    case ToastType.warning:
      return Colors.orange.shade700;
    case ToastType.error:
      return Colors.red.shade600;
    case ToastType.info:
    return Colors.blue.shade600;
  }
}

// 背景颜色
Color _getBackgroundColor(ToastType type) {
  switch (type) {
    case ToastType.success:
      return Colors.white; // success 白色背景
    case ToastType.warning:
      return Colors.orange.shade100;
    case ToastType.error:
      return Colors.red.shade100;
    case ToastType.info:
    return Colors.blue.shade100;
  }
}

// 文字颜色
Color _getTextColor(ToastType type) {
  switch (type) {
    case ToastType.success:
      return Colors.black87; // success 黑色文字
    default:
      return Colors.black87;
  }
}

// 修改 padding，让 Toast 更高一些
EdgeInsets _getPadding(ToastType type) {
  switch (type) {
    case ToastType.success:
      return const EdgeInsets.symmetric(vertical: 16, horizontal: 24);
    default:
      return const EdgeInsets.symmetric(vertical: 14, horizontal: 20);
  }
}