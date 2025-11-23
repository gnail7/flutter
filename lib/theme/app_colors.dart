import 'dart:ui';
import 'package:flutter/material.dart';

class AppColor {
  // 主色系
  static final Color primaryColor = Color(0xFF3366FF);
  static final Color primaryBgColor = Colors.green;

  // 中性色
  static final Color greyColor = Color(0xFF8A919F);
  static final Color lightGrey = Color(0xFFF5F5F5);
  static final Color darkGrey = Color(0xFF4A4A4A);

  // 警告/提示颜色
  static final Color successColor = Color(0xFF52C41A); // 成功/通过
  static final Color warningColor = Color(0xFFFFB400); // 警告
  static final Color errorColor = Color(0xFFFF4D4F);   // 危险/错误
  static final Color infoColor = Color(0xFF1890FF);    // 信息/提示

  // 透明/半透明
  static final Color overlay = Color(0x80000000); // 半透明黑
}
