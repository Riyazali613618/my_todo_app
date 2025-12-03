import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_todo_app/data/models/todo_task_model.dart';
import '../viewModels/edit_task_view_model.dart';
import '../viewmodels/providers.dart';
import '../widgets/task_input_field.dart';
import '../widgets/task_list_view.dart';
import '../widgets/share_task_button.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final _controller = TextEditingController();
  final descriptionCtrl = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    final vm = ref.read(taskEditViewModelProvider.notifier);
    vm.addTask(_controller.text, descriptionCtrl.text);
    _controller.clear();
  }

  void _shareTaskInApp(TodoTaskModel task) async {
    // ask email to share WITH
    final emailController = TextEditingController();
    final email = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share task'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Enter email to share'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, emailController.text.trim()),
            child: const Text('Share'),
          ),
        ],
      ),
    );

    if (email != null && email.isNotEmpty) {
      final vm = ref.read(taskEditViewModelProvider.notifier);
      await vm.shareTask(task, email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskListViewModelProvider);
    final editState = ref.watch(taskEditViewModelProvider);

    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width > 600 ? size.width * 0.2 : 16.0;

    return Scaffold(
      appBar: AppBar(title: const Text('My TODO App')),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 8,
        ),
        child: Column(
          children: [
            TaskInputField(
              controller: _controller,
                label:"Title"
            ),
            const SizedBox(height: 8),
            TaskInputField(
              controller: descriptionCtrl,
              label:"Description"
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: _addTask,
                child: const Icon(Icons.add),
              ),
            ),
            const SizedBox(height: 8),

            if (editState.isLoading) const LinearProgressIndicator(),
            Expanded(
              child: tasksAsync.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return const Center(child: Text('No tasks yet. Add one!'));
                  }

                  return TaskListView(
                    tasks: tasks,
                    onToggleComplete: (task) {
                      ref
                          .read(taskEditViewModelProvider.notifier)
                          .toggleComplete(task);
                    },
                    onShare: (task) async {
                      // show a bottom sheet with two options:
                      // 1. Share via app (in-app collaboration)
                      // 2. Share via email/WhatsApp/etc (share_plus)
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.person_add),
                                title: const Text(
                                  'Share to collaborator (email)',
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  _shareTaskInApp(task);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.share),
                                title: const Text('Share via other apps'),
                                onTap: () {
                                  Navigator.pop(context);
                                  ShareTaskButton.shareTask(task);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, st) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
