import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/widgets/password_verify.dart';
import 'package:op_flutter/widgets/permission_wrapper.dart';

// 正确使用 PermissionWrapper 的方式
class VoidPageEntry extends StatelessWidget {
  const VoidPageEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionWrapper(
      shouldShowPasswordPage: () => UserController.to.user.value?.voidNeedPass == 1,
      child: const Scaffold(
        body: Center(
          child: Text('正常页面内容'),
        ),
      ),
      passwordPageBuilder: (onSuccess) => PasswordVerifyPage(onSuccess: onSuccess, correctPassword: UserController.to.user.value!.voidPass!, appBarTitle: 'Void',),
    );
  }
}

// class VoidPageWithPassword extends StatelessWidget {
//   const VoidPageWithPassword({required this.onSuccess, super.key});
//
//   final VoidCallback onSuccess;
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = TextEditingController();
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F8FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColor.primaryColor,
//         title: const Text('Security Verification'),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // ===== 顶部插图 / 图标 =====
//               Container(
//                 width: 96,
//                 height: 96,
//                 decoration: BoxDecoration(
//                   color: AppColor.primaryColor.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.lock_outline,
//                   size: 48,
//                   color: AppColor.primaryColor,
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               const Text(
//                 'Password Required',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               const Text(
//                 'Please enter the password to continue',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black54,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//
//               const SizedBox(height: 24),
//
//               // ===== 输入区 Card =====
//               Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: controller,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           hintText: 'Enter password',
//                           prefixIcon: const Icon(Icons.lock),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       SizedBox(
//                         width: double.infinity,
//                         height: 48,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColor.primaryColor,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onPressed: () {
//                             if (controller.text ==
//                                 UserController.to.user.value?.voidPass) {
//                               onSuccess();
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text('Wrong password'),
//                                 ),
//                               );
//                             }
//                           },
//                           child: const Text(
//                             'Verify',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
