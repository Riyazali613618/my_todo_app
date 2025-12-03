import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_todo_app/data/models/todo_task_model.dart';
import 'package:my_todo_app/domain/useCases/complete_task_usecase.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/useCases/share_task_usecase.dart';

class TaskListViewModel extends StateNotifier<AsyncValue<List<TodoTaskModel>>> {
  final TaskRepository repository;
  final String userEmail;
  final CompleteTaskUsecase completeTaskUsecase;
  final ShareTaskUseCase shareTaskUseCase;

  TaskListViewModel(
      this.repository,
      this.userEmail,
      this.completeTaskUsecase,
      this.shareTaskUseCase,
      ) : super(const AsyncLoading()) {
    _watchTasks();
  }

  void _watchTasks() {
    repository.watchTasksForUser(userEmail).listen(
          (tasks) {
        state = AsyncData(tasks);
      },
      onError: (e, st) {
        state = AsyncError(e, st);
      },
    );
  }

  Future<void> toggleComplete(TodoTaskModel task) =>
      completeTaskUsecase(task.id, !task.isCompleted);

  Future<void> shareTask(TodoTaskModel task, String email) =>
      shareTaskUseCase(task.id, email);
}
