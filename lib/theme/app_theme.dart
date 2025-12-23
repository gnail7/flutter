import 'package:flutter/material.dart';
import 'package:op_flutter/theme/app_colors.dart';

class AppTheme {
  static ThemeData defaultTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2AA75A),
      foregroundColor: Colors.white, // 标题和按钮默认白色
      elevation: 0,
    ),
    // 全局按钮样式
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // 按钮文字颜色
        backgroundColor: AppColor.primaryBgColor, // 按钮背景颜色

      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.primaryBgColor, // 光标颜色
      selectionColor: AppColor.primaryBgColor.withOpacity(0.4), // 选中背景颜色，可选
      selectionHandleColor: AppColor.primaryBgColor, // 拖动手柄颜色，可选
    ),

    // 全局输入框样式
    inputDecorationTheme: InputDecorationTheme(
      // 普通状态的边框
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),

      // 聚焦时的边框（高亮绿色）
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2), //  绿色边框
      ),

      // 提示文字样式
      hintStyle: const TextStyle(color: Colors.grey),

      // 聚焦后上浮的 label 颜色
      floatingLabelStyle: TextStyle(color: AppColor.primaryBgColor),
    ),

  );
}
