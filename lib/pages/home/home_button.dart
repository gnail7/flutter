import 'package:flutter/material.dart';
import 'package:op_flutter/theme/app_colors.dart';

class HomeButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? textColor;         // 可自定义文字颜色
  final Color? iconColor;         // 可自定义图标颜色
  final Color? backgroundColor;   // 可自定义背景色
  final bool showBorder;

  const HomeButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.textColor,
    this.iconColor,
    this.backgroundColor,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = AppColor.greyColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          border: showBorder
              ? Border.all(color: AppColor.greyColor.withOpacity(0.1))
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 40, // 图标大一点
                color: iconColor ?? textColor ?? defaultColor,
              ),
              const SizedBox(height: 8), // 图标和文字间距稍大
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 18, // 文字大一点
                fontWeight: FontWeight.w600, // 可选加粗，更醒目
                color: textColor ?? defaultColor,
              ),
            ),
          ],
        ),
      ),
    );

  }
}
