import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:op_flutter/models/users/user_model.dart';
import 'package:op_flutter/network/system/setting.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/utils/app_utils.dart';

class MerchantPageDemo extends StatefulWidget {
  const MerchantPageDemo({super.key});

  @override
  State<MerchantPageDemo> createState() => _MerchantPageDemoState();
}

class _MerchantPageDemoState extends State<MerchantPageDemo> {
  late TextEditingController _merchantController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final user = UserController.to.user.value;
    _merchantController = TextEditingController(text: user?.merName ?? '');
    _addressController = TextEditingController(text: user?.merAddr ?? '');
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = UserController.to.user.value;
    final mid = user?.account.toString();
    final tid = user?.terminal.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Merchant Info Setting"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: mid),
              decoration: const InputDecoration(
                labelText: "MID",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: TextEditingController(text: tid),
              decoration: const InputDecoration(
                labelText: "TID",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _merchantController,
              decoration: const InputDecoration(
                labelText: "商户名",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: "商户地址",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "保存",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave() async {
    final user = UserController.to.user.value;

    // 构造请求对象
    final loginReq = {
      "merName": _merchantController.text.trim(),
      "merAddr": _addressController.text.trim(),
    };

    // 加密
    final encryptedBase64 = rsaEncryptNoPadding(
      jsonEncode(loginReq),
      parsePemPublicKey(derToPem(user!.publicKey)),
    );

    // 调用接口
    final res = await SettingApi.updateTerminal(
      terminal: user.terminal.toString(),
      token: user.token,
      secure: encryptedBase64,
    );

    // if (res.success) {
    //   // 更新本地用户信息
    //   user.merName = _merchantController.text.trim();
    //   user.merAddr = _addressController.text.trim();
    //   UserController.to.user.value = user;
    //   // 可以提示保存成功
    //   AppUtils.showToast("保存成功");
    // } else {
    //   AppUtils.showToast("保存失败: ${res.message}");
    // }
  }
}
