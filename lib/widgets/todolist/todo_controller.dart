// lib/controllers/todo_controller.dart
import 'package:get/get.dart';

class TodoController extends GetxController {
  var todos = <String>[].obs;

  void addTodo(String item) {
    todos.add(item);
  }

  void removeTodo(int index) {
    todos.removeAt(index);
  }

  void toggleComplete(int index) {
    final current = todos[index];
    if (current.startsWith('✔️')) {
      todos[index] = current.substring(2);
    } else {
      todos[index] = '✔️ $current';
    }
  }
}
