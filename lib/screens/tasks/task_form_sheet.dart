import 'package:flutter/material.dart';

import '../../models/task.dart';

class TaskFormSheet extends StatefulWidget {
  const TaskFormSheet({super.key});

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskPriority _priority = TaskPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите название задачи'),
        ),
      );
      return;
    }

    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: _priority,
      createdAt: DateTime.now(),
    );

    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        bottomInset + 20,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            const SizedBox(height: 22),

            Text(
              'Новая задача',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _titleController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Название',
                hintText: 'Например: закончить Rudi Tasks',
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Описание',
                hintText: 'Необязательно',
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Приоритет',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Низкий'),
                  selected: _priority == TaskPriority.low,
                  onSelected: (_) {
                    setState(() {
                      _priority = TaskPriority.low;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Средний'),
                  selected: _priority == TaskPriority.medium,
                  onSelected: (_) {
                    setState(() {
                      _priority = TaskPriority.medium;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Высокий'),
                  selected: _priority == TaskPriority.high,
                  onSelected: (_) {
                    setState(() {
                      _priority = TaskPriority.high;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saveTask,
                icon: const Icon(Icons.add_task_rounded),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Добавить задачу'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}