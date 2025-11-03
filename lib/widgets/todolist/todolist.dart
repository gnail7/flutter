import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ----------------- Todo 数据模型 -----------------
class Todo {
  String title;
  bool done;

  Todo({required this.title, this.done = false});
}

// ----------------- 控制器 -----------------
class TodoController extends GetxController {
  var todos = <Todo>[].obs;

  void addTodo(String title) {
    if (title.trim().isNotEmpty) {
      todos.add(Todo(title: title.trim()));
    }
  }

  void toggleDone(int index) {
    todos[index].done = !todos[index].done;
    todos.refresh();
  }

  void deleteTodo(int index) {
    todos.removeAt(index);
  }

  int get completed => todos.where((t) => t.done).length;
  int get pending => todos.length - completed;
}

// ----------------- 页面 -----------------
class TodoListPage extends StatelessWidget {
  TodoListPage({super.key});

  final TodoController controller = Get.put(TodoController());
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 标题
              const Text(
                "My Todo List",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004C6D),
                ),
              ),
              const SizedBox(height: 16),

              // 添加任务输入框
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "添加新任务",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      controller.addTodo(_textController.text);
                      _textController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 55), // 高度 50
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("添加"),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // Todo列表
              Expanded(
                child: Obx(() {
                  if (controller.todos.isEmpty) {
                    return const Center(
                      child: Text("暂无任务，快去添加吧！",
                          style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return ListView.separated(
                    itemCount: controller.todos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final todo = controller.todos[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.done,
                            onChanged: (_) => controller.toggleDone(index),
                            activeColor: const Color(0xFF004C6D),
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: todo.done
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: todo.done ? Colors.grey : Colors.black87,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => controller.deleteTodo(index),
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              // 已完成/未完成统计
              Obx(() => Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "未完成: ${controller.pending}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 24),
                    Text(
                      "已完成: ${controller.completed}",
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
