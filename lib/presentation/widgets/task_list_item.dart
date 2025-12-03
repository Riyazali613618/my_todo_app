import 'package:flutter/material.dart';
import 'package:my_todo_app/data/models/todo_task_model.dart';

class TaskListItem extends StatelessWidget {
  final TodoTaskModel task;
  final VoidCallback onToggleComplete;
  final VoidCallback onTapShare;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onTapShare,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (_) => onToggleComplete(),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration:
          task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: task.description != null
          ? Text(
        task.description!,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      )
          : null,
      trailing: IconButton(
        icon: const Icon(Icons.share),
        onPressed: onTapShare,
      ),
    );
  }
}
