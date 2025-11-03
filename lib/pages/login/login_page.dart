import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/constant/app_colors.dart';
import 'package:op_flutter/pages/login/login_controller.dart';
import 'package:op_flutter/routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取 LoginController 实例
    final LoginController controller = Get.put(LoginController(), permanent: true);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/login.png',
                  height: 300,
                  width: double.infinity,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    child: Column(
                      children: [
                        // 账号输入框
                        Obx(() => TextFormField(
                          initialValue: controller.username.value,
                          decoration: InputDecoration(
                            labelText: '账号',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            controller.username.value = value;
                          },
                        )),
                        const SizedBox(height: 16),

                        // 密码输入框
                        Obx(() => TextFormField(
                          initialValue: controller.password.value,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '密码',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            controller.password.value = value;
                          },
                        )),
                        const SizedBox(height: 30),

                        // 登录按钮
                        Obx(() => SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null // 如果正在加载，则禁用按钮
                                : () {
                              controller.handleLogin();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text(
                              '登录',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),

                // 🔹 使用 Spacer 将底部按钮推到底部
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        print('点击忘记密码');
                      },
                      child: const Text('忘记密码？'),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        print('点击注册账号');
                      },
                      child: const Text('注册账号'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
