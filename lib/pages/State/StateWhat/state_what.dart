import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/pages/login/login_controller.dart';
import 'package:op_flutter/pages/State/StateWhat/state_controller.dart';
import 'package:op_flutter/widgets/todolist/todolist.dart';

class StateWhat extends StatelessWidget {
  StateWhat({super.key});

  final LoginController loginController = Get.find();
  final StateController controller = Get.put(StateController());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // 弹出日期选择器
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (_birthdayController.text.isNotEmpty) {
      initialDate =
          DateTime.tryParse(_birthdayController.text) ?? DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      String formatted =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      _birthdayController.text = formatted;
      controller.message.value = "生日更新为: $formatted";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 主内容
        Positioned.fill(
          child: TodoListPage(),
        ),

        // 左上角返回按钮
        Positioned(
          top: 40, // 距离顶部一点，避免被状态栏遮住
          left: 16,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
