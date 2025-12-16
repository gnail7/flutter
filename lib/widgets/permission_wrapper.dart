import 'package:flutter/material.dart';

/// 根据条件展示密码页或目标页面
class PermissionWrapper extends StatelessWidget {
  const PermissionWrapper({
    required this.shouldShowPasswordPage, required this.child, required this.passwordPageBuilder, super.key,
  });

  /// 条件函数，返回 true 表示需要显示密码页
  final bool Function() shouldShowPasswordPage;

  /// 条件不满足时展示的目标页面
  final Widget child;

  /// 条件满足时显示的密码页
  final Widget Function(VoidCallback onSuccess) passwordPageBuilder;

  @override
  Widget build(BuildContext context) {
    if (shouldShowPasswordPage()) {
      return passwordPageBuilder(() {
        // 密码正确后的回调，可以直接替换为目标页面
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => child),
        );
      });
    }
    return child;
  }
}
