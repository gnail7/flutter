import 'package:flutter/material.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:op_flutter/utils/common.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:op_flutter/widgets/password_verify.dart';
import 'package:op_flutter/widgets/permission_wrapper.dart';
import 'package:op_flutter/widgets/toast.dart';

class SettlementPageEntry extends StatelessWidget {
  const SettlementPageEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final settNeedPass = UserController.to.user.value?.settNeedPass;
    final settPass = UserController.to.user.value?.settPass;
    return PermissionWrapper(
      // 有密码才需要校验
      shouldShowPasswordPage: () => settNeedPass == 1,

      // 校验通过后展示的真正页面
      child: const SettlementPage(),

      // 密码页
      passwordPageBuilder: (onSuccess) => PasswordVerifyPage(
        appBarTitle: 'Settlement Verification',
        descriptionText: 'Please enter the settlement password to continue',
        correctPassword: settPass ?? '',
        onSuccess: onSuccess,
      ),
    );
  }
}


class SettlementPage extends StatefulWidget {
  const SettlementPage({super.key});

  @override
  State<SettlementPage> createState() => _SettlementPageState();
}

class _SettlementPageState extends State<SettlementPage> {
  bool loading = false;
  void handleConfirm() {}
  @override
  Widget build(BuildContext context) {
    final user = UserController.to.user.value;

    return LoadingWrapper(
      isLoading: loading,
      child: Scaffold(
        backgroundColor: AppColor.bgGrey,
        appBar: AppBar(
          title: const Text("Settlement"),
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.offAllNamed(AppRoutes.home),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// ===== 表头 =====
                  _buildTableHeader(),
                  const Divider(),

                  /// ===== 统计数据（示例）=====
                  _buildRow('Sale', '10', '1000.00'),
                  _buildRow('Void', '2', '100.00'),
                  _buildRow('Fail', '1', '50.00'),

                  const SizedBox(height: 12),
                  const Divider(thickness: 1),
                  const SizedBox(height: 12),

                  /// ===== 基础信息 =====
                  _buildKV('MID',  '-'),
                  _buildKV('TID', user?.terminal.toString() ?? '-'),
                  _buildKV('Batch No.', '000013'),
                  _buildKV('Currency', user?.currency ?? '-'),
                  _buildKV('Date Time', getRightNow()),

                  const Spacer(),

                  /// ===== Confirm 按钮 =====
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: loading ? null : handleConfirm,
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTableHeader() {
  return const Row(
    children: [
      Expanded(flex: 2, child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
      Expanded(child: Text('Count', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
      Expanded(child: Text('Amount', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
    ],
  );
}

Widget _buildRow(String type, String count, String amount) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(flex: 2, child: Text(type)),
        Expanded(child: Text(count, textAlign: TextAlign.center)),
        Expanded(child: Text(amount, textAlign: TextAlign.end)),
      ],
    ),
  );
}

Widget _buildKV(String key, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(child: Text(key, style: const TextStyle(color: Colors.black54))),
        Text(value),
      ],
    ),
  );
}
