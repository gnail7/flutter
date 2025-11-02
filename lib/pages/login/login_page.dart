// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/constant/app_colors.dart';
import 'package:op_flutter/models/login/login_request.dart';
import 'package:op_flutter/network/login/api.dart';
import 'package:op_flutter/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. 创建一个全局 key，用来访问表单状态
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  // 🔹 抽取登录逻辑
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // 这里可以调用接口或做其他操作
      print('账号：$_username，密码：$_password');
      try{
        final request = LoginRequest(username: _username, password: _password);
        final res = await loginApi({'username': _username, 'password': _password});

        Get.offAllNamed(AppRoutes.home); // 使用 GetX 路由跳转并清空历史栈

      } catch (e) {
        print('登录失败: $e');
        Get.snackbar('登录失败', e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white);
      }
      }
    }


  @override
  Widget build(BuildContext context) {
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
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: '账号',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '账号不能为空';
                            }
                            return null;
                          },
                          onSaved: (value) => _username = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '密码',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return '密码至少 6 位';
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value ?? '',
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _handleLogin, // 直接调用抽取的方法
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              '登录',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
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
