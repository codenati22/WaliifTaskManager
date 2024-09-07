import 'package:flutter/material.dart';
import 'package:task_manager_app/model/task.dart';
import 'package:task_manager_app/service/DBHelper.dart';

class TaskProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await dbHelper.getTasks();

    _tasks.sort((a, b) {
      if (a.status == 'Incomplete' && b.status == 'Completed') {
        return -1;
      } else if (a.status == 'Completed' && b.status == 'Incomplete') {
        return 1;
      } else {
        return a.dueDate.compareTo(b.dueDate);
      }
    });

    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await dbHelper.insertTask(task);
    await fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await dbHelper.updateTask(task);
    await fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    await fetchTasks();
  }

  void clearTasks() {
    _tasks.clear();
    notifyListeners();
  }
}
