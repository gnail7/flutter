import 'package:flutter/material.dart';
import 'package:op_flutter/network/login/api.dart';

class RequestDemoPage extends StatefulWidget {
  const RequestDemoPage({super.key});

  @override
  State<RequestDemoPage> createState() => _RequestDemoPageState();
}

class _RequestDemoPageState extends State<RequestDemoPage> {
  List<dynamic>? users; // 存储多个用户
  bool isLoading = false;

  void _showLoading() => setState(() => isLoading = true);
  void _hideLoading() => setState(() => isLoading = false);

  /// 获取用户信息
  Future<void> _handleFetchUser() async {
    _showLoading();
    try {
      final res = await fetchUserInfo();
      setState(() {
        users = res['data'] as List<dynamic>?;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('获取用户信息成功')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('获取用户信息失败: $e')));
    } finally {
      _hideLoading();
    }
  }

  /// 用户卡片
  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: Text(
                user['name'] != null && user['name'].isNotEmpty
                    ? user['name'][0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'] ?? '未知用户',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user['email'] ?? '未填写邮箱',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${user['id'] ?? '-'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('获取用户信息 Demo')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _handleFetchUser,
                  child: const Text('获取用户信息'),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: users != null && users!.isNotEmpty
                      ? ListView.builder(
                    itemCount: users!.length,
                    itemBuilder: (context, index) {
                      return _buildUserCard(users![index]);
                    },
                  )
                      : const Center(child: Text('暂无用户信息')),
                ),
              ],
            ),
          ),
          // 加载动画
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
