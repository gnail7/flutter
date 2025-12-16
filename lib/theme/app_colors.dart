import 'dart:ui';
import 'package:flutter/material.dart';

class AppColor {
  // 主色系
  static final Color primaryColor = const Color(0xFF02993B);
  static final Color primaryBgColor = Colors.green;

  // 中性色
  static final Color greyColor = const Color(0xFF8A919F);
  static final Color lightGrey = const Color(0xFFF5F5F5);
  static final Color darkGrey = const Color(0xFF4A4A4A);
  static final Color bgGrey =  const Color(0xFFF4F4F4);

  // 警告/提示颜色
  static final Color successColor = const Color(0xFF52C41A); // 成功/通过
  static final Color warningColor = const Color(0xFFFFB400); // 警告
  static final Color errorColor = const Color(0xFFFF4D4F);   // 危险/错误
  static final Color infoColor = const Color(0xFF1890FF);    // 信息/提示

  // 透明/半透明
  static final Color overlay = const Color(0x80000000); // 半透明黑
}
