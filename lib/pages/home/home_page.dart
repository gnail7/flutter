import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/pages/login/login_controller.dart';
import 'package:op_flutter/widgets/todolist/todolist.dart';
import '../../routes/app_routes.dart';

// 时间控制器
class TimeController extends GetxController {
  var currentTime = ''.obs;
  var currentDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    currentTime.value = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    currentDate.value =
    "${now.year}年${now.month.toString().padLeft(2, '0')}月${now.day.toString().padLeft(2, '0')}日  ${_getWeekday(now.weekday)}";
  }

  String _getWeekday(int weekday) {
    const week = ['一', '二', '三', '四', '五', '六', '日'];
    return '星期${week[weekday - 1]}';
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TimeController timeController = Get.put(TimeController());
  final TodoController todoController = Get.find();
  final LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F0F8),
              Color(0xFFF7F9FB),
            ],
          ),
        ),
        child: SafeArea(
          child: SizedBox.expand(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部问候 + 图标
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning,',
                            style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Obx(() {
                            return Text(
                              '${loginController.username.value} 👋',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            );
                          }),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined),
                        onPressed: () {},
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  // ✅ 添加 Todo 概览卡片
                  Obx(() => _buildTodoCard(
                    completed: todoController.completed,
                    pending: todoController.pending,
                  )),
                  const SizedBox(height: 24),

                  // 时间 & 日期 卡片
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => _buildTimeCard(
                          title: "当前时间",
                          value: timeController.currentTime.value,
                          color1: 0xFF93C5FD,
                          color2: 0xFF3B82F6,
                          icon: Icons.access_time,
                        )),
                      ),
                      Expanded(
                        child: Obx(() => _buildTimeCard(
                          title: "今天日期",
                          value: timeController.currentDate.value,
                          color1: 0xFFBBF7D0,
                          color2: 0xFF22C55E,
                          icon: Icons.calendar_today,
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),

                  // -------------------- 模块 Tabs --------------------
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.blue,
                          tabs: [
                            Tab(text: "状态管理"),
                            Tab(text: "路由管理"),
                            Tab(text: "网络请求"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: TabBarView(
                            children: [
                              // Tab 1: 状态管理
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildCard("用什么状态管理", 0xFFF3E5F5,
                                        Icons.settings, AppRoutes.stateWhat),
                                    _buildCard("如何状态管理", 0xFFE3F2FD,
                                        Icons.lightbulb, AppRoutes.stateHow),
                                  ],
                                ),
                              ),
                              // Tab 2: 路由管理
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildCard("用什么路由管理", 0xFFFFCDD2,
                                        Icons.navigation, AppRoutes.routerWhat),
                                    _buildCard("如何路由管理", 0xFFFFF9C4,
                                        Icons.map, AppRoutes.routerHow),
                                  ],
                                ),
                              ),
                              // Tab 3: 网络请求
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildCard("用什么网络请求", 0xFFE1BEE7,
                                        Icons.cloud, AppRoutes.networkWhat),
                                    _buildCard("如何网络请求", 0xFFB2DFDB,
                                        Icons.send, AppRoutes.networkWhat),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 时间卡片
  Widget _buildTimeCard({
    required String title,
    required String value,
    required int color1,
    required int color2,
    required IconData icon,
  }) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(color1), Color(color2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 模块卡片
  Widget _buildCard(String title, int color, IconData icon, String routeName) {
    return GestureDetector(
      onTap: () {
        print('routername $routeName');
        Get.toNamed(routeName);
      },
      child: Container(
        width: 160,
        height: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Color(color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.grey[700]),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoCard({required int completed, required int pending}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.stateWhat); // 点击跳转到 TodoList 页面
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white, size: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "今日待办事项",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "未完成：$pending | 已完成：$completed",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


