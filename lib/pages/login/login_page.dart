import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:op_flutter/pages/login/login_controller.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';

class OceanPayLoginPage extends StatefulWidget {
  const OceanPayLoginPage({super.key});

  @override
  State<OceanPayLoginPage> createState() => _OceanPayLoginPageState();
}

class _OceanPayLoginPageState extends State<OceanPayLoginPage> {
  late final LoginController controller;
  late final Worker _autoLoginWorker;

  @override
  void initState() {
    super.initState();

    controller = Get.find<LoginController>();

    /// 监听 shouldAutoLogin
    _autoLoginWorker = ever<bool>(
      controller.shouldAutoLogin,
          (should) {
        if (!should) return;

        // 确保只触发一次
        controller.shouldAutoLogin.value = false;
      },
    );
  }

  @override
  void dispose() {
    _autoLoginWorker.dispose(); // ⭐ 非常重要，防止内存泄漏
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const _OceanPayLoginView();
  }
}

class _OceanPayLoginView extends GetView<LoginController> {
  const _OceanPayLoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return LoadingWrapper(isLoading: controller.isLoading.value,child: Stack(
          children: [
            Positioned.fill(
            child: Image.asset(
              "images/login_bg.jpeg",
              fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "OceanpayTest",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _LoginCard(),
                  ],
                ),
              ),
            ),
          ],
        ),);
      })
    );
  }
}

class _LoginCard extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome,",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text("Log in to continue",
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 20),

          _buildInput(
            "TID",
            controller: controller.terminalController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),

          _buildInput(
            "UID",
            controller: controller.usernameController,
          ),
          const SizedBox(height: 16),

          _buildInput(
            "Password",
            isPassword: true,
            controller: controller.passwordController,
          ),
          const SizedBox(height: 20),

          Obx(() {
            final canLogin = controller.isValid;
            return SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  canLogin ? Colors.green : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: canLogin
                    ? () => controller.handleLogin()
                    : null,
                child: const Text(
                  "Log in",
                  style: TextStyle(fontSize: 16),
                ),
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
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
