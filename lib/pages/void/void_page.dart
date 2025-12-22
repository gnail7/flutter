import 'package:flutter/material.dart';
import 'package:op_flutter/pages/void/void_detail.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/widgets/password_verify.dart';
import 'package:op_flutter/widgets/permission_wrapper.dart';
import 'package:get/get.dart';
import 'package:op_flutter/widgets/qr_scan_page.dart';


// 正确使用 PermissionWrapper 的方式
class VoidPageEntry extends StatelessWidget {
  const VoidPageEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionWrapper(
      shouldShowPasswordPage: () => UserController.to.user.value?.voidNeedPass  == 1,
      child: const TransactionSearchPage(),
      passwordPageBuilder: (onSuccess) => PasswordVerifyPage(onSuccess: onSuccess, correctPassword: UserController.to.user.value!.voidPass!, appBarTitle: 'Void',),
    );
  }
}

class TransactionSearchPage extends StatefulWidget {
  const TransactionSearchPage({super.key});

  @override
  State<TransactionSearchPage> createState() => _TransactionSearchPageState();
}

class _TransactionSearchPageState extends State<TransactionSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final Color _green = const Color(0xFF43A047); // 主色调绿色

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        backgroundColor: _green,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Search Transaction",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 提示信息卡片
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0, 4),
                        color: Color(0x14000000),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.search, size: 44, color: _green),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Please search for the transaction.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 输入框 + 扫码按钮
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0, 4),
                        color: Color(0x14000000),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: "Enter Bill No.",
                          filled: true,
                          fillColor: const Color(0xFFF6F7F8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            color: Colors.grey.shade600,
                            onPressed: () async {
                              final result = await Get.to<String>(
                                    () =>  QRScanTemplatePage(onScanCompleted: (String result) {
                                      Get.off(() => VoidDetailPage(orderNo: result));
                                    },),
                              );
                              if (result != null && result.isNotEmpty) {
                                setState(() {
                                  _controller.text = result;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _controller.text.trim().isEmpty
                              ? null
                              : () {
                            final orderNo = _controller.text.trim();
                            Get.to(() => VoidDetailPage(orderNo: orderNo));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _controller.text.trim().isNotEmpty
                                ? _green
                                : const Color(0xFF6D6D6D),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Search",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
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
