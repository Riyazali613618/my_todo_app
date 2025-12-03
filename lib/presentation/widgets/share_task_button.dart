import 'package:flutter/material.dart';
import 'package:my_todo_app/data/models/todo_task_model.dart';
import 'package:share_plus/share_plus.dart';

class ShareTaskButton {
  static Future<void> shareTask(TodoTaskModel task) async {
    final text =
        '''
Task: ${task.title}
Description: ${task.description ?? ''}
Shared from Collaborative TODO app.
Ask the owner to add your email to this task to collaborate.
''';
    await Share.share(text);
  }
}
