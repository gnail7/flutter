import 'package:flutter/material.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/utils/common.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:op_flutter/widgets/toast.dart';

class PasswordVerifyPage extends StatefulWidget {
  const PasswordVerifyPage({
    required this.onSuccess,
    required this.correctPassword,
    this.appBarTitle = 'Security Verification',
    this.descriptionText = 'Please enter the password to continue',
    super.key,
  });

  final VoidCallback onSuccess;
  final String correctPassword;
  final String appBarTitle;
  final String descriptionText;

  @override
  State<PasswordVerifyPage> createState() => _PasswordVerifyPageState();
}

class _PasswordVerifyPageState extends State<PasswordVerifyPage> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleVerify() async {
    if (_controller.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      if (sha256Hex(_controller.text) == widget.correctPassword) {
        widget.onSuccess();
      } else {
        showCenterToast('密码错误',type: ToastType.warning);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      isLoading: _isLoading,
      text: 'Verifying...',
      color: AppColor.primaryColor,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.primaryColor,
          title: Text(widget.appBarTitle),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ===== 顶部图标 =====
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 48,
                    color: AppColor.primaryColor,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Password Required',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.descriptionText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller,
                          obscureText: true,
                          enabled: !_isLoading,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleVerify,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Verify',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
