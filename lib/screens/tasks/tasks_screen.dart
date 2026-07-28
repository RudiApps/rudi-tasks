import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../widgets/task_card.dart';
import 'task_form_sheet.dart';

enum TaskFilter {
  all,
  active,
  completed,
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TaskFilter _selectedFilter = TaskFilter.all;

  final List<Task> _tasks = [
    const Task(
      id: '1',
      title: 'Закончить главный экран Rudi Tasks',
      description: 'Добавить карточки задач и статистику',
      priority: TaskPriority.high,
    ),
    const Task(
      id: '2',
      title: 'Оформить GitHub',
      description: 'Подготовить README и скриншоты проекта',
      priority: TaskPriority.medium,
    ),
    const Task(
      id: '3',
      title: 'Изучить Flutter',
      description: 'Разобраться с моделями, состоянием и виджетами',
      priority: TaskPriority.low,
    ),
  ];

  List<Task> get _filteredTasks {
    switch (_selectedFilter) {
      case TaskFilter.all:
        return _tasks;

      case TaskFilter.active:
        return _tasks
            .where((task) => !task.isCompleted)
            .toList();

      case TaskFilter.completed:
        return _tasks
            .where((task) => task.isCompleted)
            .toList();
    }
  }

  void _toggleTask(String taskId) {
    final index = _tasks.indexWhere(
      (task) => task.id == taskId,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      final task = _tasks[index];

      _tasks[index] = task.copyWith(
        isCompleted: !task.isCompleted,
      );
    });
  }

  Future<void> _addTask() async {
    final task = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      builder: (context) {
        return const TaskFormSheet();
      },
    );

    if (task == null) {
      return;
    }

    setState(() {
      _tasks.insert(0, task);
    });
  }

  Future<void> _editTask(Task task) async {
    final updatedTask = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return TaskFormSheet(
          initialTask: task,
        );
      },
    );

    if (updatedTask == null) {
      return;
    }

    final index = _tasks.indexWhere(
      (item) => item.id == task.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      _tasks[index] = updatedTask;
    });
  }

  Future<void> _deleteTask(Task task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Удалить задачу?'),
          content: Text(
            '«${task.title}» будет удалена.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      _tasks.removeWhere(
        (item) => item.id == task.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount =
        _tasks.where((task) => task.isCompleted).length;

    final filteredTasks = _filteredTasks;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rudi Tasks',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Держи задачи под контролем',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.task_alt_rounded,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Выполнено $completedCount из ${_tasks.length}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Все'),
                    selected: _selectedFilter == TaskFilter.all,
                    onSelected: (_) {
                      setState(() {
                        _selectedFilter = TaskFilter.all;
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Активные'),
                    selected: _selectedFilter == TaskFilter.active,
                    onSelected: (_) {
                      setState(() {
                        _selectedFilter = TaskFilter.active;
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Выполненные'),
                    selected: _selectedFilter == TaskFilter.completed,
                    onSelected: (_) {
                      setState(() {
                        _selectedFilter = TaskFilter.completed;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Text(
                'Мои задачи',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: filteredTasks.isEmpty
                    ? Center(
                        child: Text(
                          _selectedFilter == TaskFilter.completed
                              ? 'Пока нет выполненных задач'
                              : 'Здесь пока нет задач',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.55),
                                  ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];

                          return TaskCard(
                            task: task,
                            onToggle: () => _toggleTask(task.id),
                            onEdit: () => _editTask(task),
                            onDelete: () => _deleteTask(task),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}