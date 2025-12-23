import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/network/login/api.dart';
import 'package:op_flutter/network/login/login_request.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/utils/app_utils.dart';
import 'package:op_flutter/utils/common.dart';
import 'package:op_flutter/widgets/password_verify.dart';
import 'package:op_flutter/widgets/permission_wrapper.dart';

class ChangePasswordEntry extends StatelessWidget {
  const ChangePasswordEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserController.to.user.value;
    return PermissionWrapper(
      /// 是否需要先校验旧密码
      shouldShowPasswordPage: () => true,

      /// 校验成功后进入的页面
      child: const ChangePasswordPage(),

      /// 输入旧密码页
      passwordPageBuilder: (onSuccess) => PasswordVerifyPage(
        appBarTitle: 'Verify Password',
        descriptionText: 'Please enter your current password',
        correctPassword: UserController.to.sha256Password.value ?? '',
        onSuccess: onSuccess,
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _newPwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final newPwd = _newPwdController.text.trim();
    final confirmPwd = _confirmPwdController.text.trim();

    if (newPwd.isEmpty || confirmPwd.isEmpty) {
      Get.snackbar('Error', 'Password cannot be empty');
      return;
    }

    if (newPwd != confirmPwd) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    setState(() => loading = true);


    final user = UserController.to.user.value;
    final secureInfo = {
      "newPassword": sha256Hex(newPwd),
      "oldPassword": UserController.to.sha256Password.value
    };
    final encryptBase64 = rsaEncryptNoPaddingChunked(
      jsonEncode(secureInfo),
      parsePemPublicKey(derToPem(user!.publicKey)),
    );

    final req =UpdateRequest(terminal: user.terminal.toString(), token: user.token, secure: user.secureCode, sign: encryptBase64 );
    final res =  await LoginApi.updatePassword(req);

    setState(() => loading = false);

    Get.back(); // 返回上一页
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPasswordField(
                  controller: _newPwdController,
                  label: 'New Password',
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _confirmPwdController,
                  label: 'Confirm New Password',
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: loading ? null : _handleSubmit,
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
