import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Color _priorityColor() {
    switch (task.priority) {
      case TaskPriority.low:
        return const Color(0xFF51C878);

      case TaskPriority.medium:
        return const Color(0xFFFFA62B);

      case TaskPriority.high:
        return const Color(0xFFFF5C6C);
    }
  }

  String _priorityLabel() {
    switch (task.priority) {
      case TaskPriority.low:
        return 'Низкий';

      case TaskPriority.medium:
        return 'Средний';

      case TaskPriority.high:
        return 'Высокий';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ВАЖНО:
        // больше никаких RudiTheme.darkSurface.
        // Карточка берёт цвет из текущей активной темы.
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant.withValues(
            alpha: 0.65,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: 0.05,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(100),
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted
                    ? colors.primary
                    : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted
                      ? colors.primary
                      : colors.outline,
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: colors.onPrimary,
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.isCompleted
                        ? colors.onSurface.withValues(
                            alpha: 0.55,
                          )
                        : colors.onSurface,
                  ),
                ),

                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 6),

                  Text(
                    task.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface.withValues(
                        alpha: task.isCompleted
                            ? 0.4
                            : 0.6,
                      ),
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _priorityColor().withValues(
                      alpha: 0.14,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    _priorityLabel(),
                    style: TextStyle(
                      color: _priorityColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            tooltip: 'Действия',
            iconColor: colors.onSurface.withValues(
              alpha: 0.75,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              }

              if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_rounded),
                    SizedBox(width: 10),
                    Text('Изменить'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded),
                    SizedBox(width: 10),
                    Text('Удалить'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}