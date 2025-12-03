import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_todo_app/data/models/todo_task_model.dart';
import '../../data/repositories/task_repository.dart';
import 'providers.dart';

class TaskEditViewModel extends StateNotifier<AsyncValue<void>> {
  final TaskRepository _repository;
  final String _currentUserEmail;

  TaskEditViewModel(this._repository, this._currentUserEmail)
      : super(const AsyncData(null));

  Future<void> addTask(String title, String? description) async {
    if (title.trim().isEmpty) return;
    state = const AsyncLoading();
    try {
      final now = DateTime.now();
      final task = TodoTaskModel(
        id: '', // Firestore will generate
        title: title,
        description: description,
        isCompleted: false,
        ownerId: _currentUserEmail,
        sharedWith: const [],
        createdAt: now,
        updatedAt: now,
      );
      await _repository.addTask(task);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> toggleComplete(TodoTaskModel task) async {
    try {
      await _repository.toggleComplete(task.id, !task.isCompleted);
    } catch (_) {}
  }

  Future<void> shareTask(TodoTaskModel task, String emailToShare) async {
    state = const AsyncLoading();
    try {
      await _repository.shareTask(task.id, emailToShare);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final taskEditViewModelProvider =
StateNotifierProvider<TaskEditViewModel, AsyncValue<void>>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  final email = ref.watch(currentUserEmailProvider);
  return TaskEditViewModel(repo, email);
});
