import 'package:flutter/material.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:op_flutter/utils/common.dart';

typedef HomeButtonTapCallback = void Function(String name);

class HomeButton extends StatelessWidget {

  const HomeButton({
    required this.name, required this.title, super.key,
    this.icon,
    this.textColor,
    this.iconColor,
    this.backgroundColor,
    this.showBorder = true,
  });
  final String name;
  final String title;
  final IconData? icon;
  final Color? textColor;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final defaultColor = AppColor.greyColor;

    return InkWell(
      onTap: () async {
        final result = await AuthGuard.check(name);
        /// 无需settlement
        if (result == AuthCheckResult.allow) {
          Get.toNamed(name);
        }
        /// 是否超过七天没有settlement了
        else if (result == AuthCheckResult.needVerify) {
          Get.toNamed(AppRoutes.settlement);
        } else {
          Get.toNamed(name);
        }
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
