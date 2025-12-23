import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:op_flutter/network/user_management/api.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/app_utils.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:op_flutter/widgets/toast.dart';

class AddUserPage extends StatefulWidget { // 传了就是编辑

  const AddUserPage({super.key, this.userName});
  final String? userName;

  bool get isEdit => userName != null;
  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _uidController = TextEditingController();
  final _pwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  final String tid = UserController.to.user.value!.terminal.toString();
  final String token = UserController.to.user.value!.token;
  final String publicKey = UserController.to.user.value!.publicKey;
  bool loading = false;
  // 是否允许提交
  bool get canSubmit =>
      _uidController.text.isNotEmpty &&
          _pwdController.text.isNotEmpty &&
          _confirmPwdController.text.isNotEmpty;
  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      _uidController.text = widget.userName!;
    }
    // 监听输入变化，刷新按钮状态
    _uidController.addListener(_onInputChanged);
    _pwdController.addListener(_onInputChanged);
    _confirmPwdController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    setState(() {}); // 刷新 canSubmit 状态
  }

  @override
  void dispose() {
    _uidController.dispose();
    _pwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_pwdController.text != _confirmPwdController.text) {
      showCenterToast('Passwords do not match', type: ToastType.error);
      return;
    }

    setState(() => loading = true);

    try {
      final secureReq = {
        "userName": _uidController.text,
        "password": _pwdController.text,
        "role": 0,
        "userId": widget.isEdit ? _uidController.text : null,
      };

      final encryptedBase64 = rsaEncryptNoPadding(
        jsonEncode(secureReq),
        parsePemPublicKey(derToPem(publicKey)),
      );

      final res = widget.isEdit
          ? await UserApi.updateUser(
        terminal: int.parse(tid),
        token: token,
        secure: encryptedBase64,
      )
          : await UserApi.addUser(
        terminal: tid,
        token: token,
        secure: encryptedBase64,
      );

      showCenterToast(
        widget.isEdit ? 'Success Revise' : 'Success Add',
        type: ToastType.success,
      );
      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('error $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      isLoading: loading,
      text: 'Adding user...',
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2E7D32),
          title:  widget.isEdit ? const Text('Revise User') : const Text('Add User'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildForm(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(
          'images/img_user_add.png',
          height: 120,
        ),
        const SizedBox(height: 16),
        const Text(
          'Please input UID and Password to\nset new users',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildInput(
          label: 'TID',
          initialValue: tid,
          enabled: false,
        ),
        const SizedBox(height: 16),
        _buildInput(
          label: 'UID',
          controller: _uidController,
          hintText: 'Please Enter UID',
        ),
        const SizedBox(height: 16),
        _buildInput(
          label: 'Password',
          controller: _pwdController,
          hintText: 'Please Enter Password',
          obscureText: true,
        ),
        const SizedBox(height: 16),
        _buildInput(
          label: 'Confirm Password',
          controller: _confirmPwdController,
          hintText: 'Please Confirm Password',
          obscureText: true,
        ),
      ],
    );
  }

  Widget _buildInput({
    required String label,
    TextEditingController? controller,
    String? initialValue,
    String? hintText,
    bool enabled = true,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          enabled: enabled,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: canSubmit ? const Color(0xFF2E7D32) : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: canSubmit ? _submit : null,
        child: const Text(
          'Confirm',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
