import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:op_flutter/pages/login/login_controller.dart';
import 'package:op_flutter/store/user_controller.dart';

class OceanPayLoginPage extends StatelessWidget {
  OceanPayLoginPage({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景图
          Positioned.fill(
            child: Image.network(
              "https://images.unsplash.com/photo-1508780709619-79562169bc64?auto=format&fit=crop&w=800&q=60",
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "OceanpayTest",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 24),

                  _buildCard(),

                  const SizedBox(height: 24),
                  const Text(
                    "Forgot your password? Please contact administrator to retrieve the password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    final c = controller;

    // 保证 Controller 的 TextEditingController 与 Rx 双向同步
    c.terminalController.addListener(() {
      c.terminal.value = c.terminalController.text;
    });
    c.usernameController.addListener(() {
      c.username.value = c.usernameController.text;
    });
    c.passwordController.addListener(() {
      c.password.value = c.passwordController.text;
    });

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome,",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text("Log in to continue",
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 20),

          // TID（8-9位数字）
          _buildInput(
            "TID",
            controller: c.terminalController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),

          const SizedBox(height: 16),

          // UID（3-19位 字母或数字）
          _buildInput(
            "UID",
            controller: c.usernameController,
          ),

          const SizedBox(height: 16),

          // Password（6-15位）
          _buildInput(
            "Password",
            isPassword: true,
            controller: c.passwordController,
          ),

          const SizedBox(height: 20),

          // 登录按钮（根据 isValid + isLoading 更新）
          Obx(() {
            final canLogin = c.isValid && !c.isLoading.value;
            return SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canLogin ? Colors.green : Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: canLogin ? c.handleLogin : null,
                child: c.isLoading.value
                    ? const CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2)
                    : const Text("Log in", style: TextStyle(fontSize: 16)),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInput(
      String label, {
        bool isPassword = false,
        List<TextInputFormatter>? inputFormatters,
        TextEditingController? controller,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

}
