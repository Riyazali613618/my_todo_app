import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_todo_app/data/models/todo_task_model.dart';
import 'package:my_todo_app/domain/useCases/complete_task_usecase.dart';
import 'package:my_todo_app/presentation/viewModels/task_detail_view_model.dart';
import 'package:my_todo_app/presentation/viewModels/task_list_view_model.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/firestore_task_repository.dart';
import '../../domain/useCases/share_task_usecase.dart';
import '../views/task_detail_screen.dart';

// Simulate current user (email). In real app, use Firebase Auth.
final currentUserEmailProvider = Provider<String>((ref) {
  return 'user1@example.com';
});

// Repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return FirestoreTaskRepository(FirebaseFirestore.instance);
});

// Task list stream provider (VM)
final taskListViewModelProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  final email = ref.watch(currentUserEmailProvider);
  return repo.watchTasksForUser(email);
});

final taskListViewModelProvider1 =
    StateNotifierProvider<TaskListViewModel, AsyncValue<List<TodoTaskModel>>>((
      ref,
    ) {
      final repo = ref.watch(taskRepositoryProvider);
      final email = ref.watch(currentUserEmailProvider);

      return TaskListViewModel(
        repo,
        email,
        CompleteTaskUsecase(repo),
        ShareTaskUseCase(repo),
      );
    });

final taskDetailViewModelProvider =
    StateNotifierProvider<TaskDetailViewModel, AsyncValue<void>>((ref) {
      final repo = ref.watch(taskRepositoryProvider);
      return TaskDetailViewModel(repo);
    });
