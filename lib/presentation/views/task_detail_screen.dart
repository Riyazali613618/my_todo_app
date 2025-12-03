import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_todo_app/data/models/todo_task_model.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/usecases/update_task_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_todo_app/data/models/todo_task_model.dart';
import 'package:my_todo_app/presentation/viewModels/providers.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final TodoTaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late TextEditingController titleCtrl;
  late TextEditingController descriptionCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.task.title);
    descriptionCtrl = TextEditingController(
      text: widget.task.description ?? '',
    );
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(taskDetailViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Task Details")),
      body: SingleChildScrollView(  // Add this to make the body scrollable
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                focusColor: Colors.blue,
                fillColor: Colors.grey,
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionCtrl,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                focusColor: Colors.blue,
                fillColor: Colors.grey,
                isDense: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: vm.isLoading
                  ? null
                  : () async {
                final notifier = ref.read(
                  taskDetailViewModelProvider.notifier,
                );
                await notifier.updateTask(
                  widget.task,
                  titleCtrl.text,
                  descriptionCtrl.text.trim(),
                );
                if (mounted) Navigator.pop(context);
              },
              child: vm.isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

}
