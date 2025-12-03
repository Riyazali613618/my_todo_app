import 'package:flutter/material.dart';
import 'package:my_todo_app/data/models/todo_task_model.dart';

import '../views/task_detail_screen.dart';

class TaskListView extends StatelessWidget {
  final List<TodoTaskModel> tasks;
  final void Function(TodoTaskModel task) onToggleComplete;
  final void Function(TodoTaskModel task) onShare;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.onToggleComplete,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggleComplete(task),
            ),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.share, color: Colors.blue),
              onPressed: () {
                onShare(task);
              },
            ),
            IconButton(
              icon: Icon(Icons.remove_red_eye, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskDetailScreen(task: task),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
