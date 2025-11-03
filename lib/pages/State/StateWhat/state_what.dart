import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/pages/login/login_controller.dart';
import 'package:op_flutter/pages/State/StateWhat/state_controller.dart';
import 'package:op_flutter/routes/app_routes.dart';
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
      initialDate = DateTime.tryParse(_birthdayController.text) ?? DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      String formatted = "${picked.year}-${picked.month.toString().padLeft(2,'0')}-${picked.day.toString().padLeft(2,'0')}";
      _birthdayController.text = formatted;
      controller.message.value = "生日更新为: $formatted";
    }
  }

  @override
  Widget build(BuildContext context) {
    return  TodoListPage();
  }
}
