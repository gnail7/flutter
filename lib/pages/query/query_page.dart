import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/widgets/paginated_page_list.dart';

class SearchPrintPage extends StatelessWidget {
  const SearchPrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          'Search & Print',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offAllNamed(AppRoutes.home);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _refreshList();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: PaginatedListView<Map<String, dynamic>>(
        pageSize: 10,

        fetchData: (page) async {
          print("加载第 $page 页");

          // 模拟后端分页接口
          await Future.delayed(const Duration(seconds: 1));

          // 假设总数据 50 条
          if (page > 5) return [];

          return List.generate(10, (i) {
            int id = (page - 1) * 10 + i;
            return {
              "id": id,
              "title": "Print Item #$id",
              "desc": "Description for item #$id"
            };
          });
        },

        itemBuilder: (context, item, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
            child: ListTile(
              leading: const Icon(Icons.print),
              title: Text(item["title"]),
              subtitle: Text(item["desc"]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                print("点击 ${item["id"]}");
              },
            ),
          );
        },
      ),
    );
  }

  /// 刷新列表
  void _refreshList() {
    print("刷新列表");
    // 如果你希望点击刷新的时候也刷新分页组件
    // 你可以把 PaginatedListView 提升成 Stateful 并提供外部 refreshKey
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('这里放过滤条件'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
