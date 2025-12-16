import 'package:flutter/material.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/widgets/password_verify.dart';
import 'package:op_flutter/widgets/permission_wrapper.dart';

// 正确使用 PermissionWrapper 的方式
class VoidPageEntry extends StatelessWidget {
  const VoidPageEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionWrapper(
      shouldShowPasswordPage: () => UserController.to.user.value?.voidNeedPass  == 1,
      child: VoidPage(),
      passwordPageBuilder: (onSuccess) => PasswordVerifyPage(onSuccess: onSuccess, correctPassword: UserController.to.user.value!.voidPass!, appBarTitle: 'Void',),
    );
  }
}

class VoidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Void'),
      ),
    );
  }
}