import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../services/task_storage_service.dart';
import '../../services/theme_controller.dart';
import '../../services/theme_storage_service.dart';
import '../../widgets/task_card.dart';
import 'task_form_sheet.dart';

enum TaskFilter {
  all,
  active,
  completed,
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({
    super.key,
    required this.themeController,
  });

  final ThemeController themeController;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TaskStorageService _storageService = TaskStorageService();

  TaskFilter _selectedFilter = TaskFilter.all;

  bool _isLoading = true;

  List<Task> _tasks = [];

  static const List<Task> _starterTasks = [
    Task(
      id: '1',
      title: 'Закончить главный экран Rudi Tasks',
      description: 'Добавить карточки задач и статистику',
      priority: TaskPriority.high,
    ),
    Task(
      id: '2',
      title: 'Оформить GitHub',
      description: 'Подготовить README и скриншоты проекта',
      priority: TaskPriority.medium,
    ),
    Task(
      id: '3',
      title: 'Изучить Flutter',
      description: 'Разобраться с моделями, состоянием и виджетами',
      priority: TaskPriority.low,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Task> loadedTasks;

    try {
      final hasSavedTasks = await _storageService.hasSavedTasks();

      if (hasSavedTasks) {
        loadedTasks = await _storageService.loadTasks();
      } else {
        loadedTasks = List<Task>.from(_starterTasks);
        await _storageService.saveTasks(loadedTasks);
      }
    } catch (_) {
      loadedTasks = List<Task>.from(_starterTasks);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _tasks = loadedTasks;
      _isLoading = false;
    });
  }

  Future<void> _saveTasks() async {
    await _storageService.saveTasks(_tasks);
  }

  List<Task> get _filteredTasks {
    switch (_selectedFilter) {
      case TaskFilter.all:
        return _tasks;

      case TaskFilter.active:
        return _tasks.where((task) => !task.isCompleted).toList();

      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
    }
  }

  Future<void> _toggleTask(String taskId) async {
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

    await _saveTasks();
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

    if (task == null || !mounted) {
      return;
    }

    setState(() {
      _tasks.insert(0, task);
      _selectedFilter = TaskFilter.all;
    });

    await _saveTasks();
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

    if (updatedTask == null || !mounted) {
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

    await _saveTasks();
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

    if (shouldDelete != true || !mounted) {
      return;
    }

    setState(() {
      _tasks.removeWhere(
        (item) => item.id == task.id,
      );
    });

    await _saveTasks();
  }

  Widget _themeCheck(AppThemeChoice choice) {
    if (widget.themeController.selectedTheme == choice) {
      return const Icon(
        Icons.check_rounded,
        size: 20,
      );
    }

    return const SizedBox(
      width: 20,
      height: 20,
    );
  }

  Widget _buildProgressCard(
  BuildContext context,
  int completedCount,
) {
  final isRudi =
      widget.themeController.selectedTheme == AppThemeChoice.rudi;

  final colors = Theme.of(context).colorScheme;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: isRudi ? null : colors.primaryContainer,
      gradient: isRudi
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7C5CFF),
                Color(0xFF3F8CFF),
              ],
            )
          : null,
      borderRadius: BorderRadius.circular(20),
      boxShadow: isRudi
          ? [
              BoxShadow(
                color: const Color(0xFF6C4DFF)
                    .withValues(alpha: 0.28),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ]
          : null,
    ),
    child: Row(
      children: [
        Icon(
          Icons.task_alt_rounded,
          color: isRudi
              ? Colors.white
              : colors.onPrimaryContainer,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Выполнено $completedCount из ${_tasks.length}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isRudi
                      ? Colors.white
                      : colors.onPrimaryContainer,
                ),
          ),
        ),
      ],
    ),
  );
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rudi Tasks',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Держи задачи под контролем',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                        ),
                      ],
                    ),
                  ),

                  PopupMenuButton<AppThemeChoice>(
                    tooltip: 'Тема',
                    icon: const Icon(
                      Icons.palette_outlined,
                    ),
                    onSelected: (choice) {
                      widget.themeController.setTheme(choice);
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: AppThemeChoice.light,
                          child: Row(
                            children: [
                              const Icon(Icons.light_mode_outlined),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text('Светлая'),
                              ),
                              _themeCheck(AppThemeChoice.light),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: AppThemeChoice.dark,
                          child: Row(
                            children: [
                              const Icon(Icons.dark_mode_outlined),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text('Тёмная'),
                              ),
                              _themeCheck(AppThemeChoice.dark),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: AppThemeChoice.rudi,
                          child: Row(
                            children: [
                              const Icon(Icons.auto_awesome_rounded),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text('Rudi'),
                              ),
                              _themeCheck(AppThemeChoice.rudi),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _buildProgressCard(
  context,
  completedCount,
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : filteredTasks.isEmpty
                        ? Center(
                            child: Text(
                              _selectedFilter == TaskFilter.completed
                                  ? 'Пока нет выполненных задач'
                                  : 'Здесь пока нет задач',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
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
                                onToggle: () {
                                  _toggleTask(task.id);
                                },
                                onEdit: () {
                                  _editTask(task);
                                },
                                onDelete: () {
                                  _deleteTask(task);
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _addTask,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}