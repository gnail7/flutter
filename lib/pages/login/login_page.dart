// lib/pages/login_page.dart
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录页')),
      body: const Center(
        child: Text('这里是登录页', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
