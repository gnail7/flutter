import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:get/get.dart';


class OceanpayLoginPage extends StatefulWidget {
  const OceanpayLoginPage({super.key});

  @override
  State<OceanpayLoginPage> createState() => _OceanpayLoginPageState();
}

class _OceanpayLoginPageState extends State<OceanpayLoginPage> {
  final TextEditingController tidController = TextEditingController();
  final TextEditingController uidController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  bool isValid = false; // 按钮是否可以点击

  // 校验方法
  void _validate() {
    final tid = tidController.text.trim();
    final uid = uidController.text.trim();
    final pwd = pwdController.text.trim();

    final tidOk = RegExp(r'^\d{8,9}$').hasMatch(tid);
    final uidOk = RegExp(r'^[A-Za-z0-9]{3,19}$').hasMatch(uid);
    final pwdOk = RegExp(r'^[A-Za-z0-9]{6,15}$').hasMatch(pwd);

    setState(() {
      isValid = tidOk && uidOk && pwdOk;
    });
  }

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

          // 蒙层
          Container(color: Colors.black.withOpacity(0.25)),

          Center(
            child: SingleChildScrollView(
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
            controller: tidController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),

          const SizedBox(height: 16),

          // UID（3-19位 字母或数字）
          _buildInput(
            "UID",
            controller: uidController,
          ),

          const SizedBox(height: 16),

          // Password（6-15位）
          _buildInput(
            "Password",
            controller: pwdController,
            isPassword: true,
          ),

          const SizedBox(height: 20),

          // 按钮
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid ? Colors.green : Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isValid ? () => _handleLogin() : null,
              child: const Text("Log in", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // 输入框组件
  Widget _buildInput(
      String label, {
        required TextEditingController controller,
        bool isPassword = false,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      inputFormatters: inputFormatters,
      onChanged: (v) => _validate(),
      decoration: InputDecoration(
        labelText: label,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleLogin() {
    print("TID: ${tidController.text}");
    print("UID: ${uidController.text}");
    print("PWD: ${pwdController.text}");
    Get.toNamed(AppRoutes.home);

    // TODO：这里调用登录接口
  }
}
