import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:op_flutter/models/setting/user_item.dart';
import 'package:op_flutter/network/user_management/api.dart';
import 'package:op_flutter/pages/system_info/user_management/add_user_page.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:op_flutter/widgets/modal.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List<UserItem> users = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }



  Future<void> _loadUsers() async {
    setState(() => loading = true);

    try {
      final current = UserController.to.user.value!;
      final res = await UserApi.listUsers(
        terminal: current.terminal,
        token: current.token,
      );
      if (res.code == '0') {
        users = res.data!;
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      isLoading: loading,
      text: 'Loading users...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Management'),
          backgroundColor: AppColor.primaryColor,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                Get.to(() => AddUserPage());
              },
            ),
          ],
        ),
        body: users.isEmpty
            ? _buildEmpty()
            : ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, index) {
            return _UserItem(
              user: users[index],
              onDeleted: _loadUsers,
              onUpdated: _loadUsers,
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_off,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'No User',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

}

class _UserItem extends StatelessWidget {

  const _UserItem({
    required this.user,
    required this.onDeleted,
    required this.onUpdated,
  });
  final UserItem user;
  final VoidCallback onDeleted;
  final VoidCallback onUpdated;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('TID:${UserController.to.user.value?.terminal}    UID:${user.userName}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 编辑
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.green),
            onPressed: () async {
              Get.to(() => AddUserPage(userName: user.userName));
            },
          ),
          // 启用 / 停用
          IconButton(
            icon: const Icon(
              Icons.pause,
              color: Colors.grey,
            ),
            onPressed: () {
              print("object ${UserController.to.user.value!.terminal}");
              // TODO: 启停逻辑（updateUser）
            },
          ),
          // 状态指示
          const Icon(
            Icons.stop,
            color: Colors.grey,
          ),
          // 删除
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.green),
            onPressed: () async {
              final ok = await showConfirmDialog(
                title: 'Delete User',
                message: 'Confirm delete this user?',
              );


              if (ok == true) {
                await UserApi.deleteUser(
                  terminal: UserController.to.user.value!.terminal,
                  token: UserController.to.user.value!.token,
                  userId: (user as dynamic).userId
                );
                onDeleted();
              }
            },
          ),
        ],
      ),
    );
  }
}

