import '../../data/repositories/task_repository.dart';

class CompleteTaskUsecase {
  final TaskRepository repository;
  CompleteTaskUsecase(this.repository);

  Future<void> call(String taskId, bool value) =>
      repository.toggleComplete(taskId, value);
}
