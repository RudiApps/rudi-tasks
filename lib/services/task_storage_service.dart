import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class TaskStorageService {
  static const String _tasksKey = 'rudi_tasks';

  Future<bool> hasSavedTasks() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(_tasksKey);
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();

    final encodedTasks = tasks.map((task) {
      return jsonEncode({
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'isCompleted': task.isCompleted,
        'priority': task.priority.name,
        'createdAt': task.createdAt?.toIso8601String(),
      });
    }).toList();

    await prefs.setStringList(
      _tasksKey,
      encodedTasks,
    );
  }

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedTasks = prefs.getStringList(_tasksKey);

    if (encodedTasks == null) {
      return [];
    }

    return encodedTasks.map((encodedTask) {
      final data = jsonDecode(encodedTask) as Map<String, dynamic>;

      return Task(
        id: data['id'] as String,
        title: data['title'] as String,
        description: data['description'] as String? ?? '',
        isCompleted: data['isCompleted'] as bool? ?? false,
        priority: TaskPriority.values.firstWhere(
          (priority) => priority.name == data['priority'],
          orElse: () => TaskPriority.medium,
        ),
        createdAt: data['createdAt'] != null
            ? DateTime.tryParse(data['createdAt'] as String)
            : null,
      );
    }).toList();
  }
}