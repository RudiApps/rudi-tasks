import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
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

  void _toggleTask(int index) {
    setState(() {
      final task = _tasks[index];

      _tasks[index] = task.copyWith(
        isCompleted: !task.isCompleted,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount =
        _tasks.where((task) => task.isCompleted).length;

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

              const SizedBox(height: 24),

              Text(
                'Мои задачи',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      task: _tasks[index],
                      onToggle: () => _toggleTask(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}