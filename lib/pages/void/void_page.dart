import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/widgets/permission_wrapper.dart';

// 正确使用 PermissionWrapper 的方式
class VoidPageEntry extends StatelessWidget {
  const VoidPageEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionWrapper(
      shouldShowPasswordPage: () => UserController.to.user.value?.voidPass != null,
      child: const Scaffold(
        body: Center(
          child: Text('正常页面内容'),
        ),
      ),
      passwordPageBuilder: (onSuccess) => VoidPageWithPassword(onSuccess: onSuccess),
    );
  }
}

class VoidPageWithPassword extends StatelessWidget {
  const VoidPageWithPassword({required this.onSuccess, super.key});

  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Enter Password'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.successColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  if (controller.text == UserController.to.user.value?.voidPass) {
                    onSuccess();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wrong password')),
                    );
                  }
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
