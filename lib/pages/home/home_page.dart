import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart'; // 引入路由常量

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning,',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Frede 👋',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined),
                        onPressed: () {},
                      )
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 两个卡片
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 120,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAD8FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(child: Text("Hang out")),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 120,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF004C6D),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              "Laugh",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Stress Indicator
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(child: Text("Stress indicator")),
                  ),
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
                                    _buildCard("用什么状态管理", 0xFFF3E5F5, Icons.settings, AppRoutes.stateWhat),
                                    _buildCard("如何状态管理", 0xFFE3F2FD, Icons.lightbulb, AppRoutes.stateHow),
                                  ],
                                ),
                              ),
                              // Tab 2: 路由管理
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildCard("用什么路由管理", 0xFFFFCDD2, Icons.navigation, AppRoutes.routerWhat),
                                    _buildCard("如何路由管理", 0xFFFFF9C4, Icons.map, AppRoutes.routerHow),
                                  ],
                                ),
                              ),
                              // Tab 3: 网络请求
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildCard("用什么网络请求", 0xFFE1BEE7, Icons.cloud, AppRoutes.networkWhat),
                                    _buildCard("如何网络请求", 0xFFB2DFDB, Icons.send, AppRoutes.networkHow),
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
                  // -------------------- End Tabs --------------------
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- 卡片构建方法 --------------------
  Widget _buildCard(String title, int color, IconData icon, String routeName) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(routeName); // 点击跳转
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
}
