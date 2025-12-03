import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/todo_task_model.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/useCases/update_task_usecase.dart';

class TaskDetailViewModel extends StateNotifier<AsyncValue<void>> {
  final UpdateTaskUseCase updateTaskUseCase;

  TaskDetailViewModel(TaskRepository repo)
      : updateTaskUseCase = UpdateTaskUseCase(repo),
        super(const AsyncData(null));

  Future<void> updateTask(TodoTaskModel task, String title, String? description) async {
    state = const AsyncLoading();
    final updated = task.copyWith(title: title, description: description);
    try {
      await updateTaskUseCase(updated);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
