import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';

class PasswordVerifyPage extends StatefulWidget {
  const PasswordVerifyPage({super.key});

  @override
  State<PasswordVerifyPage> createState() => _PasswordVerifyPageState();
}

class _PasswordVerifyPageState extends State<PasswordVerifyPage> {
  late final String title;
  late final String? redirectRoute; // 新增跳转路径参数
  final TextEditingController _pwdController = TextEditingController();
  bool loading = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    title = args["title"] ?? "Verification";
    redirectRoute = args["redirectRoute"];
  }



  Future<void> handleOK() async {
    if (!isButtonEnabled) return;

    final pwd = _pwdController.text.trim();
    // // 显示 Loading
    // showDialog(
    //   context: Get.context!,
    //   barrierDismissible: false,
    //   builder: (_) => const CustomLoadingDialog(),
    // );
    setState(() => loading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() => loading = false);
    if (pwd == "123456") {
      if (redirectRoute != null && redirectRoute!.isNotEmpty) {
        Get.offNamed(redirectRoute!);
      } else {
        Get.offNamed("/clearMachine");
      }
    } else {
      Get.snackbar(
        "Error",
        "Password incorrect",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrey,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // SVG 图标
            SvgPicture.asset(
              'images/password.svg',
              width: 80,
              height: 80,
            ),

            const SizedBox(height: 20),
            Text(
              "Please Enter Password",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.greyColor),
            ),

            const SizedBox(height: 30),

            // 输入框 & OK 按钮卡片
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  // 密码输入框
                  TextField(
                    controller: _pwdController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    onChanged: (v) {
                      setState(() => isButtonEnabled = v.length == 6);
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // OK 按钮
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (isButtonEnabled && !loading)
                          ? handleOK
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonEnabled
                            ? Colors.green
                            : Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "OK",
                        style: TextStyle(
                            fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
