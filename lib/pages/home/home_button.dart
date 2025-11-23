import 'package:flutter/material.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:get/get.dart';

typedef HomeButtonTapCallback = void Function(String name);

class HomeButton extends StatelessWidget {
  final String name;               // 按钮标识
  final String title;
  final IconData? icon;
  final Color? textColor;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool showBorder;

  const HomeButton({
    super.key,
    required this.name,
    required this.title,
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
      onTap: () {
        Get.offAllNamed(name);
      },
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
                size: 40,
                color: iconColor ?? textColor ?? defaultColor,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor ?? defaultColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
